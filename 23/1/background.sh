rm -f out.txt 2> /dev/null
echo Starting 3 background scripts (5 sec sleep)
./echo_and_sleep.sh &
./echo_and_sleep.sh &
./echo_and_sleep.sh &
echo Starting same script synchronously (5 sec sleep)
./echo_and_sleep.sh
echo Synchronous script finished
echo Printing lines count, 4 expected:
wc -l out.txt