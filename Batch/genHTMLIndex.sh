#!/bin/bash
# Script to generate HTML index files for directories using 'tree'

# Array of dirs to exclude
exclude_paths=(
    "! -path */.git*"
)

# Get array of dirs
dirs=( $(find $@ -type d ${exclude_paths[@]}) )

for i in "${!dirs[@]}"
do 
	# Check for existing index made by 'tree' (rc=0) or nonexistent (rc=2)
	grep -qsm1 "Made by 'tree'" "${dirs[i]}/index.html"
	if  [ $? -eq 1 ]; then 
		unset 'dirs[i]'
	fi
done

# Reset array
dirs=( "${dirs[@]}"  )

# List dirs
echo "Index will be created in:"
printf '%s\n' "${dirs[@]}"
echo

# Get confirm for creation of index
read -n1 -p "Continue? (y/N) " confirm
if ! echo $confirm | grep -q '^[Yy]$'; then echo -e "\nAborting"; exit 1; fi
echo

# Create the indexes
for i in "${!dirs[@]}"
do 
	cd "${dirs[i]}"
	echo "Creating index in ${dirs[i]}"
	# Generate HTML index - Color, Date, Size(h), No lines(i), Title(T), filter self(I)
	# Pipe to sed: Remove credits, link to parent dir, change colours
	tree -CDhi -H "." -T "$(basename $PWD)" -I "index.html" -L 1 --dirsfirst --charset "utf-8"\
	| sed -e '/<hr>/,+7d' -e 's/href="\.">\./href="..">../'\
	-e 's/BODY {/BODY { color: lime; background: black;/'\
	-e 's/color: black;/color: lime;/'\
	-e 's/color: blue;/color: deepskyblue;/'\
	-e 's/color: green;/color: limegreen;/'\
	-e 's/color: purple;/color: mediumpurple;/'\
	> index.html
	cd $OLDPWD
done
