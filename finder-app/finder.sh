#!/bin/bash

set -o pipefail

if [ "$#" -lt 2 ]; then
    printf 'Usage: %s <directory> <search string>\n' "$0" >&2
    exit 1
fi

filesdir=$1
searchstr=$2

if [ ! -d "$filesdir" ]; then
    printf 'Error: not a directory: %s\n' "$filesdir" >&2
    exit 1
fi

if ! filesdir=$(cd -- "$filesdir" && pwd -P); then
    printf 'Error: cannot access directory: %s\n' "$1" >&2
    exit 1
fi

# NUL delimiters preserve filenames containing whitespace or newlines.
if ! result=$(
    find "$filesdir" -type f -print0 |
    (
        file_count=0
        matching_lines=0

        while IFS= read -r -d '' file; do
            file_count=$((file_count + 1))
            matches=$(grep -a -F -c -- "$searchstr" "$file")
            grep_status=$?
            if [ "$grep_status" -gt 1 ]; then
                exit 1
            fi
            matching_lines=$((matching_lines + matches))
        done

        printf 'The number of files are %s and the number of matching lines are %s\n' \
            "$file_count" "$matching_lines"
    )
); then
    printf 'Error: could not search all files in: %s\n' "$filesdir" >&2
    exit 1
fi

printf '%s\n' "$result"
