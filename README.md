**Attention RMIT University students:** 

* Please read and understand the [Plagiarism notice](#plagiarism-notice). 

* Please understand that copying this assignment, without properly citing me as your source, is a violation of University policy. 

* Please note that this work is published under the [MIT License](/LICENSE), and that distributing or using any portion of this work without maintaining the copyright notice is in violation of the license. 

* Please note that, by publishing this work, I am explicitly **NOT** facilitating or allowing plagiarism, and I expressly forbid this work to be used in such a manner. 

# usap-a1

SHA256 password cracking via a guessing attack, a dictionary attack, and a (trival) brute force attack.

## Dependencies

These scripts require a list of accounts in the format of `username` colon (`:`) SHA256 `hash` on each line.

#### Example accounts.txt

`ada:fb1e7ec987523d2cb9e022cec1d6ae7c99dc46edfae4fe51254025fe4bea571f`

#### Binary dependencies

These scripts require `openssl`, `bash`, `cat`, `cut`, and `wc`.

## Using the scripts

`git clone https://github.com/aghorler/usap-a1.git`

`chmod -R 755 usap-a1`

This repository contains three bash scripts. `guess.sh`, `dictionary.sh`, and `bruteforce.sh`.

`./guess.sh < resources/accounts.txt` will run a guessing attack using a [list of commonly used passwords](/resources/common.txt).

`./dictionary.sh < resources/accounts.txt` will run a dictionary attack using the Linux dictionary.

`./bruteforce.sh < resources/accounts.txt` will run a (trival) bruteforce attack using the lowercase English alphabet (1 - 4 characters) with a default timeout of 120 seconds.

Any results will be printed to the terminal.

`ada:lovelace`

#### Debug mode

Running any of the scripts with the `--debug` flag will print hash mismatches along with matches.

`./bruteforce.sh --debug < resources/accounts.txt`

All attempts of the attack will be printed to the terminal.

`DEBUG (MISMATCH): john:d (18ac3e7343f016890c510e93f935261169d9e3f565436429830faf0934f4f8e4)`
`DEBUG (MATCH): john:e (3f79bb7b435b05321651daefd374cdc681dc06faa65e374e38337b88ca046dea)`

## Plagiarism notice

Plagiarism is the presentation of the work, idea or creation of another person as though it is my/our own. It is a form of cheating and is a very serious academic offence that may lead to exclusion from the University. Plagiarised material can be drawn from, and presented in, written, graphic and visual form, including electronic data and oral presentations. Plagiarism occurs when the origin of the material used is not appropriately cited.

Plagiarism includes the act of assisting or allowing another person to plagiarise or to copy my/our work.
