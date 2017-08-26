#! /bin/bash

# Pre-computed hash dictionary path.
dictionary='./resources/dictionary_hashes.txt'

# Binary paths.
wc='/usr/bin/wc'
cat='/bin/cat'

# Check that the dictionary specified both exists, and is not empty.
if [ -s "$dictionary" ]; then
	echo "Attempting dictionary attack..."
	echo ""

	# Read inputted accounts file.
	while read -r account
	do
		# Validate line from inputted accounts file.
		# Specifically, check that the number of characters in the line exceeds an SHA256 hash
		# (64), plus one for the colon (64 + 1 = 65). This also checks that a colon is present.
		if [ "$(echo -n "$account" | $wc -c)" -gt 65 ] && [[ "$account" == *:* ]]; then

			# Read dictionary.
			$cat $dictionary | while read -r attempt
			do
				# Generate a SHA256 hash for each word in the dictionary.
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
	done
else
	# Print error indicating that the dictionary does not
	# exist, or is empty.
	echo "$dictionary does not exist, or is empty."
	echo "Please alter line 4 of this script to the path of a dictionary."
fi
