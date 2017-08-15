#! /bin/bash

# Binary paths.
date='/bin/date'
wc='/usr/bin/wc'
openssl='/usr/bin/openssl'
cut='/usr/bin/cut'

# The duration (in seconds) for which this script will run.
# This can be customised.
duration=10

# Caluculating the end time by adding the set duration to the current time.
endtime=$(($($date +%s) + duration))

echo "Attempting bruteforce attack. This will timeout after $duration second/s."
echo ""

# Function to compare SHA256 hashes.
function compare {
	fhash=$1
	faccount=$2
	fattempt=$3
	fdebug=$4

	# Check if --debug flag is set.
	if [ "$fdebug" == "true" ]; then
		# Debug mode prints both matches and mismatches.
		if [ "${faccount#*:}" ==  "$fhash" ]; then
			echo "DEBUG (MATCH): ${faccount%:*}:$fattempt ($fhash)"
			return 1
		else
			echo "DEBUG (MISMATCH): ${faccount%:*}:$fattempt ($fhash)"
		fi
	else
		# Check if the generated hash matches the hash in the inputted accounts file.
		if [ "${faccount#*:}" ==  "$fhash" ]; then
			echo "${faccount%:*}:$fattempt"

			# Return a success code (1) if a match was found.
			return 1
		fi
	fi
}

# Read inputted accounts file.
while read -r account
do
	# Validate line from inputted accounts file.
	# Specifically, check that the number of characters in the line exceeds an SHA256 hash
	# (64), plus one for the colon (64 + 1 = 65). This also checks that a colon is present.
	if [ "$(echo -n "$account" | $wc -c)" -gt 65 ] && [[ "$account" == *:* ]]; then

		# Interation 1 - single letters (A).
		for lettera in {a..z} ; do
				# Generate a SHA256 hash for each combination.
				hash=$(echo -n "$lettera" | $openssl dgst -sha256 | $cut -c 10-)

				# Check if --debug flag is set.
				if [[ "$*" == *--debug* ]]; then
					# Call compare function with debug mode enabled.
					compare "$hash" "$account" "$lettera" "true"
				else
					# Call compare function normally.
					compare "$hash" "$account" "$lettera" "false"
				fi

				# Break from loop (skipping to next account) if compare function returned a success code (1).
				if [ "$?" == 1 ]; then
					break
				fi

				# Exit script if timeout has been reached.
				if [[ $($date +%s) > "$endtime" ]]; then
					exit 1
				fi

				# Interation 2 - double letters (AB).
				for letterb in {a..z} ; do
					# Generate a SHA256 hash for each combination.
					hash=$(echo -n "$lettera$letterb" | $openssl dgst -sha256 | $cut -c 10-)

					# Check if --debug flag is set.
					if [[ "$*" == *--debug* ]]; then
						# Call compare function with debug mode enabled.
						compare "$hash" "$account" "$lettera$letterb" "true"
					else
						# Call compare function normally.
						compare "$hash" "$account" "$lettera$letterb" "false"
					fi

					# Break from loop (skipping to next account) if compare function returned a success code (1).
					if [ "$?" == 1 ]; then
						break 2
					fi

					# Exit script if timeout has been reached.
					if [[ $($date +%s) > "$endtime" ]]; then
						exit 1
					fi

					# Interation 3 - triple letters (ABC).
					for letterc in {a..z} ; do
						# Generate a SHA256 hash for each combination.
						hash=$(echo -n "$lettera$letterb$letterc" | $openssl dgst -sha256 | $cut -c 10-)
						compare "$hash" "$account" "$lettera$letterb$letterc"

						# Check if --debug flag is set.
						if [[ "$*" == *--debug* ]]; then
							# Call compare function with debug mode enabled.
							compare "$hash" "$account" "$lettera$letterb$letterc" "true"
						else
							# Call compare function normally.
							compare "$hash" "$account" "$lettera$letterb$letterc" "false"
						fi

						# Break from loop (skipping to next account) if compare function returned a success code (1).
						if [ "$?" == 1 ]; then
							break 3
						fi

						# Exit script if timeout has been reached.
						if [[ $($date +%s) > "$endtime" ]]; then
							exit 1
						fi

						# Interation 4 - quadruple letters (ABCD).
						for letterd in {a..z} ; do
							# Generate a SHA256 hash for each combination.
							hash=$(echo -n "$lettera$letterb$letterc$letterd" | $openssl dgst -sha256 | $cut -c 10-)
							compare "$hash" "$account" "$lettera$letterb$letterc$letterd"

							# Check if --debug flag is set.
							if [[ "$*" == *--debug* ]]; then
								# Call compare function with debug mode enabled.
								compare "$hash" "$account" "$lettera$letterb$letterc$letterd" "true"
							else
								# Call compare function normally.
								compare "$hash" "$account" "$lettera$letterb$letterc$letterd" "false"
							fi

							# Break from loop (skipping to next account) if compare function returned a success code (1).
							if [ "$?" == 1 ]; then
								break 4
							fi

							# Exit script if timeout has been reached.
							if [[ $($date +%s) > "$endtime" ]]; then
								exit 1
							fi
						done
					done
				done
		done
	else
		# Print error indicating that the format of a specific line in
		# the inputted accounts file in invalid.
		echo "Invalid format: $account. Please read the instructions."
	fi
done
