#!/bin/sh

# Sample script that checks if google maps key exist in comitted files
# if so then reject commit
 
if git rev-parse --verify HEAD >/dev/null 2>&1
then
    against=HEAD
else
    # Initial commit: diff against an empty tree object
    against=4b825dc642cb6eb9a060e54bf8d69288fbee4904
fi
 
# Redirect output to stderr.
exec 1>&2
 
# Check changed files for an AWS keys
KEY_ID=$(git diff --cached --name-only -z $against | xargs -0 cat | grep -c -E '(AIza)[A-Za-z0-9]+_[A-Za-z0-9]+_[A-Za-z0-9]+')

if [ $KEY_ID -ne 0 ]; then
	echo "🚨 Commit Rejected 🚨\n"
    echo "🔑 Found pattern for Google Maps Key"
    echo "\nPlease check your code and remove API keys."
    exit 1
fi
 
# Normal exit
exit 0
