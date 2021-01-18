#!/bin/bash
echo "-------DirTraverseFuzzer-----"
echo "If you have found a web traversal vuln then you can use this script to fuzz it"
echo "Your files will be in the TravFuzz folder and can all be viewed with trav.html. Also make sure to edit the gobuster command on line 12."
echo "Enter your target URL/IP:"

read scan
echo "--Scanning--"
rm -r TravFuzz/ 2>/dev/null
mkdir TravFuzz
mkdir TravFuzz/pngs

gobuster dir -t 30 -w /usr/share/seclists/Fuzzing/lin-traversal.txt -u $scan -e --wildcard -l >> ./TravFuzz/found.txt;
i=0
echo "<HTML><BODY><BR>" > ./TravFuzz/trav.html
for url in $(cat ./TravFuzz/found.txt |grep "Status: 200\|Status: 204\|Status: 301\|Status: 302\|Status: 307\|Status: 403" |grep -v "Size: 0" |cut -d" " -f1);do
	((i++))
	cutycapt --url=$url --out=./TravFuzz/pngs/$i.png
	echo "<b>"$url":</b> <BR><IMG SRC=\""./pngs/""$i"".png"\" width=600 border="6"><BR><BR><BR>" >> ./TravFuzz/trav.html
done
echo "</BODY></HTML>" >> ./TravFuzz/trav.html
echo "--Finished--" 
echo "Check ./TravFuzz/trav.html"
