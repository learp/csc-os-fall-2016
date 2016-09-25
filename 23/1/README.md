Simple implementation of shell.

Supported features:
1) Pipes, input/output redirection
2) Background execution via '&' in the end of line
3) Wait for single process or job via 'wait %job_id' or 'wait pid'

Tests:
1) Test from wiki: ./test.sh
2) Test for background execution: ./test_background.sh
   This test starts three shell scripts in background which append line to file 'out.txt' and sleep for 5 second
   Then it starts same script in shell and then echoes lines count in out.txt