#! /bin/bash

# Pre-computed bruteforce hash path.
hashes='./resources/bruteforce_hashes.txt'

# Binary paths.
date='/bin/date'
wc='/usr/bin/wc'
cat='/bin/cat'

# The duration (in seconds) for which this script will run.
# This can be customised.
duration=120

# Caluculating the end time by adding the set duration to the current time.
endtime=$(($($date +%s) + duration))

# Check that the bruteforce hash file specified both exists, and is not empty.
if [ -s "$hashes" ]; then
	echo "Attempting bruteforce attack... This will timeout after $duration second/s, but should complete sooner."
	echo ""

	# Read inputted accounts file.
	while read -r account
	do
		# Validate line from inputted accounts file.
		# Specifically, check that the number of characters in the line exceeds an SHA256 hash
		# (64), plus one for the colon (64 + 1 = 65). This also checks that a colon is present.
		if [ "$(echo -n "$account" | $wc -c)" -gt 65 ] && [[ "$account" == *:* ]]; then

			# Read hash file.
			$cat $hashes | while read -r attempt
			do
				# Generate a SHA256 hash for each word in the hash file.
				hash=${attempt#*:}

				# Check if --debug flag is set.
				if [[ "$*" == *--debug* ]]; then
					# Debug mode prints both matches and mismatches.
					if [ "${account#*:}" ==  "$hash" ]; then
						echo "DEBUG (MATCH): ${account%:*}:${attempt%:*} ($hash)"
						break
					else
						echo "DEBUG (MISMATCH): ${account%:*}:${attempt%:*} ($hash)"
					fi
				else
					# Check if the generated hash matches the hash in the inputted accounts file.
					if [ "${account#*:}" ==  "$hash" ]; then
						echo "${account%:*}:${attempt%:*}"
						break
					fi
				fi
			done
		else
			# Print error indicating that the format of a specific line in
			# the inputted accounts file in invalid.
			echo "Invalid format: $account. Please read the instructions."
		fi

		# Exit script if timeout has been exceeded in previous account interation.
		# Including this check inside of the hash loop increases running time significantly.
		if [[ $($date +%s) > "$endtime" ]]; then
			echo "TIMEOUT: $duration second/s reached. See line 13 of this script."
			exit 1
		fi
	done
else
	# Print error indicating that the dictionary does not
	# exist, or is empty.
	echo "$hashes does not exist, or is empty."
	echo "Please alter line 4 of this script to the path of a dictionary."
fi
