#include <stdlib.h>
#include <unistd.h>
#include <stdio.h>
#include <fcntl.h>
#include <string.h>
#include <assert.h>
#include <errno.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <sys/wait.h>

// Simplifed xv6 shell.

#define MAXARGS 10
#define MAXSTRINGLEN 200

// All commands have at least a type. Have looked at the type, the code
// typically casts the *cmd to some specific cmd type.
struct cmd {
  int type;          //  ' ' (exec), | (pipe), '<' or '>' for redirection
};

struct execcmd {
  int type;              // ' '
  char *argv[MAXARGS];   // arguments to the command to be exec-ed
};

struct redircmd {
  int type;          // < or >
  struct cmd *cmd;   // the command to be run (e.g., an execcmd)
  char *file;        // the input/output file
  int mode;          // the mode to open the file with
  int fd;            // the file descriptor number to use for the file
};

struct pipecmd {
  int type;          // |
  struct cmd *left;  // left side of pipe
  struct cmd *right; // right side of pipe
};

int fork1(void);  // Fork but exits on failure.
struct cmd *parsecmd(char*);

int dumpdesc;    //descriptor of dbg output
#ifdef _DEBUG

  #define INIT_DUMP(fd) dumpdesc = dup(fd)
  #define DBG(fmt, ...)                                   \
    if (dumpdesc != 0)                                      \
    {                                                       \
        char buffer[100];                                   \
        int len = snprintf(buffer, 100, fmt, ##__VA_ARGS__);\
        write(dumpdesc, buffer, len);                       \
    }\

#else
  #define INIT_DUMP(fd) (void)fd;
  #define DBG(fmt, ...) (void)fmt;
#endif

//return pointer to string end
//memory safe
char*
format_execcmd_text(struct execcmd* ecmd, char* output, size_t size)
{
    char* end = output;
    if (ecmd) {
        int i = 0;
        while (ecmd->argv[i]) {
            end += snprintf(end, size - (end - output), "%s ", ecmd->argv[i]);
            ++i;
        }
        end -= 1; *end = 0; //pop last space
    }
    return end;
}

//return pointer to string end
//memory safe
char*
format_cmd_text(struct cmd* cmd, char* output, size_t size)
{
    char* end;
    struct redircmd* rcmd;
    struct pipecmd* pcmd;

    switch(cmd->type){
    case ' ':
        return format_execcmd_text((struct execcmd*)cmd, output, size);
    case '>':
    case '<':
        rcmd = (struct redircmd*)cmd;
        end = format_cmd_text(rcmd->cmd, output, size);
        end += snprintf(end, size - (end - output), " %c %s", cmd->type, rcmd->file);
        return end;
    case '|':
        pcmd = (struct pipecmd*)cmd;
        end = format_cmd_text(pcmd->left, output, size);
        end += snprintf(end, size - (end - output), " | ");
        end = format_cmd_text(pcmd->right, end, size - (end - output));
        return end;
    }
    return output;
}

// perror plus cmd text
// Save errno value.
// Print error in format:
// <additional_info>, command <cmd text>: <errno text>\n
void
print_comman_error(struct cmd* cmd, char* additional_info)
{
    int error = errno;
    char buffer[MAXSTRINGLEN];
    memset(buffer, 0, sizeof(buffer));
    format_cmd_text(cmd, buffer, MAXSTRINGLEN);
    if (additional_info)
        fprintf(stderr, "%s, command %s: %s\n", additional_info, buffer, strerror(error));
    else
        fprintf(stderr, "command %s: %s\n", buffer, strerror(error));
    errno = error;
}

// Execute cmd.  Never returns.
void
runcmd(struct cmd *cmd)
{
  int p[2], r, exstat;
  struct execcmd *ecmd;
  struct pipecmd *pcmd;
  struct redircmd *rcmd;

  if(cmd == 0)
    exit(0);

  switch(cmd->type){
  default:
    fprintf(stderr, "unknown runcmd\n");
    exit(-1);

  case ' ':
    ecmd = (struct execcmd*)cmd;
    if(ecmd->argv[0] == 0)
      exit(0);
    if (execvp(ecmd->argv[0], ecmd->argv)) {
      print_comman_error(cmd, "command execution");
      exit(errno);
    }
    break;

  case '>':
  case '<':
    rcmd = (struct redircmd*)cmd;

    r = open(rcmd->file, rcmd->mode, S_IRWXU);
    if (r < 0) {
        print_comman_error(cmd, "open file");
        exit(errno);
    }

    if (dup2(r, rcmd->fd) < 0) {
        print_comman_error(cmd, "io descriptor replacement");
        exit(errno);
    }

    if (close(r) < 0) {
        print_comman_error(cmd, "close dub desc");
        exit(errno);
    }

    runcmd(rcmd->cmd);
    break;

  case '|':
    {
        pcmd = (struct pipecmd*)cmd;

        if (pipe(p) < 0)
            print_comman_error(cmd, "pipe creation");

        int leftpid = fork1();
        if (leftpid == 0) { // left child process
            if (dup2(p[1], fileno(stdout)) < 0) {
                print_comman_error(cmd, "output replacement");
                exit(errno);
            }

            if (close(p[0]) < 0) {
                print_comman_error(cmd, "pipe close out");
                exit(errno);
            }

            runcmd(pcmd->left);
        }

        if (close(p[1]) < 0) { // terminate left process and exit
            int err = errno;
            print_comman_error(cmd, "pipe close in");

            DBG("Terminate child: %d\n", leftpid);
            if (kill(leftpid, SIGTERM) < 0)
                perror("kill left child pipe process");
            exit(err);
        }

        int rightpid = fork1();
        if (rightpid == 0) { // right child process
            if (dup2(p[0], fileno(stdin)) < 0) {
                print_comman_error(cmd, "input replacement");
                exit(errno);
            }

            runcmd(pcmd->right);
        }

        waitpid(leftpid, &exstat, 0);
        int leftcode = WEXITSTATUS(exstat);
        DBG("Child %d exit code: %d\n", leftpid, leftcode);
        if (leftcode != 0) { // terminate right process and exit
            DBG("Terminate child: %d\n", rightpid);
            if (kill(rightpid, SIGTERM) < 0)
                perror("kill right child pipe process");
            exit(leftcode);
        }

        waitpid(rightpid, &exstat, 0);
        int rightcode = WEXITSTATUS(exstat);
        DBG("Child %d exit code: %d\n", rightpid, rightcode);
        exit(rightcode);
    }

    break;
  }
  exit(0);
}

int
getcmd(char *buf, int nbuf)
{

  if (isatty(fileno(stdin)))
    fprintf(stdout, "$ ");
  memset(buf, 0, nbuf);
  fgets(buf, nbuf, stdin);
  if(buf[0] == 0) // EOF
    return -1;
  return 0;
}

int
main(void)
{
  INIT_DUMP(STDOUT_FILENO);
  static char buf[100];
  int r = 0, exitcode = 0;

  // Read and run input commands.
  while(exitcode == 0 && getcmd(buf, sizeof(buf)) >= 0){
    if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' '){
      // Clumsy but will have to do for now.
      // Chdir has no effect on the parent if run in the child.
      buf[strlen(buf)-1] = 0;  // chop \n
      if(chdir(buf+3) < 0)
        fprintf(stderr, "cannot cd %s\n", buf+3);
      continue;
    }
    int pid = fork1();
    if(pid == 0) {
        runcmd(parsecmd(buf));
    }
    waitpid(pid, &r, 0);
    exitcode = WEXITSTATUS(r);
    DBG("Child %d exit code: %d\n", pid, exitcode);
  }
  exit(exitcode);
}

int
fork1(void)
{
  int pid;

  pid = fork();
  if(pid == -1)  {
    perror("fork");
    exit(errno);
  }
  else if (pid != 0) {
    DBG("Child PID: %d\n", pid);
  }
  return pid;
}

struct cmd*
execcmd(void)
{
  struct execcmd *cmd;

  cmd = malloc(sizeof(*cmd));
  memset(cmd, 0, sizeof(*cmd));
  cmd->type = ' ';
  return (struct cmd*)cmd;
}

struct cmd*
redircmd(struct cmd *subcmd, char *file, int type)
{
  struct redircmd *cmd;

  cmd = malloc(sizeof(*cmd));
  memset(cmd, 0, sizeof(*cmd));
  cmd->type = type;
  cmd->cmd = subcmd;
  cmd->file = file;
  cmd->mode = (type == '<') ?  O_RDONLY : O_WRONLY|O_CREAT|O_TRUNC;
  cmd->fd = (type == '<') ? 0 : 1;
  return (struct cmd*)cmd;
}

struct cmd*
pipecmd(struct cmd *left, struct cmd *right)
{
  struct pipecmd *cmd;

  cmd = malloc(sizeof(*cmd));
  memset(cmd, 0, sizeof(*cmd));
  cmd->type = '|';
  cmd->left = left;
  cmd->right = right;
  return (struct cmd*)cmd;
}

// Parsing

char whitespace[] = " \t\r\n\v";
char symbols[] = "<|>";

int
gettoken(char **ps, char *es, char **q, char **eq)
{
  char *s;
  int ret;

  s = *ps;
  while(s < es && strchr(whitespace, *s))
    s++;
  if(q)
    *q = s;
  ret = *s;
  switch(*s){
  case 0:
    break;
  case '|':
  case '<':
    s++;
    break;
  case '>':
    s++;
    break;
  default:
    ret = 'a';
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
      s++;
    break;
  }
  if(eq)
    *eq = s;

  while(s < es && strchr(whitespace, *s))
    s++;
  *ps = s;
  return ret;
}

int
peek(char **ps, char *es, char *toks)
{
  char *s;

  s = *ps;
  while(s < es && strchr(whitespace, *s))
    s++;
  *ps = s;
  return *s && strchr(toks, *s);
}

struct cmd *parseline(char**, char*);
struct cmd *parsepipe(char**, char*);
struct cmd *parseexec(char**, char*);

// make a copy of the characters in the input buffer, starting from s through es.
// null-terminate the copy to make it a string.
char
*mkcopy(char *s, char *es)
{
  int n = es - s;
  char *c = malloc(n+1);
  assert(c);
  strncpy(c, s, n);
  c[n] = 0;
  return c;
}

struct cmd*
parsecmd(char *s)
{
  char *es;
  struct cmd *cmd;

  es = s + strlen(s);
  cmd = parseline(&s, es);
  peek(&s, es, "");
  if(s != es){
    fprintf(stderr, "leftovers: %s\n", s);
    exit(-1);
  }
  return cmd;
}

struct cmd*
parseline(char **ps, char *es)
{
  struct cmd *cmd;
  cmd = parsepipe(ps, es);
  return cmd;
}

struct cmd*
parsepipe(char **ps, char *es)
{
  struct cmd *cmd;

  cmd = parseexec(ps, es);
  if(peek(ps, es, "|")){
    gettoken(ps, es, 0, 0);
    cmd = pipecmd(cmd, parsepipe(ps, es));
  }
  return cmd;
}

struct cmd*
parseredirs(struct cmd *cmd, char **ps, char *es)
{
  int tok;
  char *q, *eq;

  while(peek(ps, es, "<>")){
    tok = gettoken(ps, es, 0, 0);
    if(gettoken(ps, es, &q, &eq) != 'a') {
      fprintf(stderr, "missing file for redirection\n");
      exit(-1);
    }
    switch(tok){
    case '<':
      cmd = redircmd(cmd, mkcopy(q, eq), '<');
      break;
    case '>':
      cmd = redircmd(cmd, mkcopy(q, eq), '>');
      break;
    }
  }
  return cmd;
}

struct cmd*
parseexec(char **ps, char *es)
{
  char *q, *eq;
  int tok, argc;
  struct execcmd *cmd;
  struct cmd *ret;

  ret = execcmd();
  cmd = (struct execcmd*)ret;

  argc = 0;
  ret = parseredirs(ret, ps, es);
  while(!peek(ps, es, "|")){
    if((tok=gettoken(ps, es, &q, &eq)) == 0)
      break;
    if(tok != 'a') {
      fprintf(stderr, "syntax error\n");
      exit(-1);
    }
    cmd->argv[argc] = mkcopy(q, eq);
    argc++;
    if(argc >= MAXARGS) {
      fprintf(stderr, "too many args\n");
      exit(-1);
    }
    ret = parseredirs(ret, ps, es);
  }
  cmd->argv[argc] = 0;
  return ret;
}

