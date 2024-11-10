#!/bin/bash
# update-mod-files.bash: pull all BG3 Mod Project files into a single place for source code management
# by mstephenson6, see guide at https://mod.io/g/baldursgate3/r/git-backups-for-mod-projects

# TODO Look in "C:\Program Files (x86)\Steam\steamapps\common\Baldurs Gate 3\Data\Projects" and set MOD_SUBDIR_NAME
# Example:
# MOD_SUBDIR_NAME="CircleOfTheSpores_db7e15fd-b2fc-b159-4bbd-1baab34d8c3a"
MOD_SUBDIR_NAME=""

# This is the MinGW64 path to a Steam install of the toolkit
BG3_DATA="/c/Program Files (x86)/Steam/steamapps/common/Baldurs Gate 3/Data"

# These are set according to "Understanding the Mod Locations", as of Nov 2024, from
# https://mod.io/g/baldursgate3/r/getting-started-creating-a-new-mod
SUBDIR_LIST=(
	"Projects"
	"Editor/Mods"
	"Mods"
	"Public"
	"Generated/Public"
)

if [ -z "$MOD_SUBDIR_NAME" ]; then  
	echo "MOD_SUBDIR_NAME must have a value in $(basename $BASH_SOURCE)";
	return 1 2>/dev/null;
	exit 1;
fi

for subdir in "${SUBDIR_LIST[@]}";
	do mkdir -p $subdir;
	cp -av "$BG3_DATA/$subdir/$MOD_SUBDIR_NAME" "$subdir";
done;

