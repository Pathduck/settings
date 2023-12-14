#!/bin/sh

#
# This script uninstalls pokemonsay.
#

# Remove the install directory
rm -r "/home/stian/.pokemonsay/"

# Remove the bin files
rm "/home/stian/bin/pokemonsay"
rm "/home/stian/bin/pokemonthink"

# Say what's going on.
echo "'/home/stian/.pokemonsay/' directory was removed."
echo "'/home/stian/bin/pokemonsay' file was removed."
echo "'/home/stian/bin/pokemonthink' file was removed."
