#!/bin/bash

if [ "$#" -lt 2 ]; then
    printf 'Usage: %s <file path> <text>\n' "$0" >&2
    exit 1
fi

writefile=$1
writestr=$2

if ! parentdir=$(dirname -- "$writefile"); then
    printf 'Error: invalid file path: %s\n' "$writefile" >&2
    exit 1
fi

if ! mkdir -p -- "$parentdir"; then
    printf 'Error: cannot create parent directory: %s\n' "$parentdir" >&2
    exit 1
fi

if ! printf '%s\n' "$writestr" > "$writefile"; then
    printf 'Error: cannot write file: %s\n' "$writefile" >&2
    exit 1
fi
