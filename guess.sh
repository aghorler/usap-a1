#! /bin/bash

# Prepackaged list of most used passwords in 2016 according to SplashData.
# This list can be customised by entering one plaintext password per line.
# The list must end with an empty newline.
common='./resources/common.txt'

# Binary paths.
wc='/usr/bin/wc'
cat='/bin/cat'
openssl='/usr/bin/openssl'
cut='/usr/bin/cut'

# Check that prepackaged passwords list both exists, and is not empty.
if [ -s "$common" ]; then
	echo "Attempting a simple guessing attack."
	echo ""

	# Read inputted accounts file.
	while read -r account
	do
		# Validate line from inputted accounts file.
		# Specifically, check that the number of characters in the line exceeds an SHA256 hash
		# (64), plus one for the colon (64 + 1 = 65). This also checks that a colon is present.
		if [ "$(echo -n "$account" | $wc -c)" -gt 65 ] && [[ "$account" == *:* ]]; then

			# Read prepackaged passwords list.
			$cat $common | while read -r attempt
			do
				# Generate a SHA256 hash for each password in the prepackaged passwords
				# list. I chose to do this in the script so that the list can be easily
				# edited by the user.
				hash=$(echo -n "$attempt" | $openssl dgst -sha256 | $cut -c 10-)

				# Check if --debug flag is set.
				if [[ "$*" == *--debug* ]]; then
					# Debug mode prints both matches and mismatches.
					if [ "${account#*:}" ==  "$hash" ]; then
						echo "DEBUG (MATCH): ${account%:*}:$attempt ($hash)"
						break
					else
						echo "DEBUG (MISMATCH): ${account%:*}:$attempt ($hash)"
					fi
				else
					# Check if the generated hash matches the hash in the inputted accounts file.
					if [ "${account#*:}" ==  "$hash" ]; then
						echo "${account%:*}:$attempt"
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
	# Print error indicating that the prepackaged passwords list
	# does not exist, or is empty.
	echo "$common does not exist, or is empty."
fi
