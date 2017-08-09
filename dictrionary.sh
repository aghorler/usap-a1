#! /bin/bash

dictionary='/usr/share/dict/words'
openssl='/usr/bin/openssl'
cut='/usr/bin/cut'

while read STRING
do
	# for ((i=0; i < $(wc -l < $dictionary); i++))
	# do
		cat $dictionary | while read line
		do
			hash=$(echo -n $line | $openssl dgst -sha256 | $cut -c 10-)
			
			if [ "${STRING#*:}" ==  "$hash" ]; then
				echo "${STRING#*:} - Passed with $line"
			else
				echo "Fail: $hash for ${STRING#*:}"
			fi
		done
	# done
done
