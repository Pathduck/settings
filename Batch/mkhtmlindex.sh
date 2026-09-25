#!/bin/bash
# Script to generate HTML index files for directories using 'tree'
# Works with 'tree' 1.7.0 under Cygwin

# Array of dirs to exclude
exclude_paths=(
	! -path "*/.git*"
)

# Collect directories into array
mapfile -d '' dirs < <(find "$@" -type d "${exclude_paths[@]}" -print0)

# Check array directories for existing index.html
for i in "${!dirs[@]}"; do
	if [[ -f "${dirs[i]}/index.html" ]] && ! grep -qsm1 "Made by 'tree'" "${dirs[i]}/index.html"; then
		unset 'dirs[i]'
	fi
done

# Re-index array
dirs=( "${dirs[@]}" )

# No directories found
if [[ ${#dirs[@]} -eq 0 ]]; then
	echo "No matching directories found."
	exit 1
fi

# List dirs
echo "Index will be created in:"
printf '%s\n' "${dirs[@]}"
echo

# Get confirm for creation of index
read -r -n1 -p "Continue? (y/N) " confirm
echo
if ! [[ "$confirm" =~ ^[Yy]$ ]]; then
	echo -e "Aborting!"
	exit 1
fi

# Generate HTML indexes
for dir in "${dirs[@]}"; do
	echo "Creating index in $dir"
	pushd "$dir" > /dev/null || { echo "Failed to enter $dir, skipping..."; continue; }

	# Call 'tree' with: Color, Size(h), No lines(i), Baseref(H), Title(T), Filter self(I)
	# Pipe to 'sed': Remove credits, link to parent dir, change colours
	tree -Chi -H "." -T "🗁 $(basename "$PWD")" -I "index.html" -L 1 \
		--dirsfirst --charset "utf-8" \
		| sed \
			-e '/<hr>/,+7d' \
			-e 's/href="\.\/*">\./href="..">../' \
			-e 's/BODY {\(.*\)}/BODY {\1color: lime; background: black; }/' \
			-e 's/color: black;/color: lime;/' \
			-e 's/color: blue;/color: deepskyblue;/' \
			-e 's/color: green;/color: limegreen;/' \
			-e 's/color: purple;/color: mediumpurple;/' \
		> index.html
	popd > /dev/null || exit 1
done
