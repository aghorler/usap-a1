#! /bin/bash

common='./resources/common.txt'
openssl='/usr/bin/openssl'
cut='/usr/bin/cut'

while read STRING
do
	cat $common | while read line
	do
		hash=$(echo -n $line | $openssl dgst -sha256 | $cut -c 10-)

		if [ "${STRING#*:}" ==  "$hash" ]; then
			echo "${STRING#*:} - Passed with $line"
		else
			echo "${STRING#*:} - Failed with $line"
		fi
	done
done
