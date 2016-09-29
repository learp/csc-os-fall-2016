ls -lah > y.txt
cat < y.txt | sort | uniq | wc -l > y1.txt
cat y1.txt
rm y1.txt
ls | sort | uniq | wc
rm y.txt