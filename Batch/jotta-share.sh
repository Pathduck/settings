#!/usr/bin/env bash
# Script to share file with Jotta

# Check if input parameter is provided
[ -z "$1" ] && { echo "Usage: $(basename "$0") <path>"; exit 1; }

input="$1"

# Check if jottad is running, if not start it
tasklist /fi "imagename eq jottad.exe" | grep -ia "jottad.exe" >/dev/null || { cygstart /d/bin/Jotta/jottad; sleep 1; }

# Strip trailing wildcard patterns (*.*, *, .)
input="${input%\/\*\.\*}"
input="${input%\/\*}"
input="${input%\/\.}"

# Strip trailing slashes
input="${input%/}"

# Resolve absolute POSIX path and filename
fullpath="$(realpath -m "$input")"
filename="$(basename "$fullpath")"

# Convert POSIX path to Windows path format for Windows executables
winpath="$(cygpath -w "$fullpath")"

# Result
echo "Absolute Path  : \"$fullpath\""
echo "Windows Path   : \"$winpath\""
echo "Filename/Folder: \"$filename\""

# 6. Call Jotta CLI safely with quoted variables
jotta archive "$winpath" --share --clipboard --nogui --remote="Shares/$filename"
