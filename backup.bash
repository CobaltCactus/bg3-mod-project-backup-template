#!/bin/bash
# backup.bash: pull all BG3 Mod Project files into a single place for source code management
# by mstephenson6, see guide at https://mod.io/g/baldursgate3/r/git-backups-for-mod-projects
# Edit by TheCobaltCactus to store multiple related mods (zipped to maintain separation) within a single repo.
set -e

#TODO Enter Mod Directory or Directories here
MOD_SUBDIR_NAMES=(
    "notable_guardians_a8abde8c-60f3-1306-0d2e-1fed719dd38e"
)

#TODO Set this path to the BG3 Data Folder
BG3_DATA="/d/Program Files (x86)/Steam/steamapps/common/Baldurs Gate 3/Data"

SUBDIR_LIST=(
    "Projects"
    "Editor/Mods"
    "Mods"
    "Public"
    "Generated/Public"
)

if [ "${#MOD_SUBDIR_NAMES[@]}" -eq 0 ]; then
    echo "MOD_SUBDIR_NAMES must have at least one value in $(basename "$BASH_SOURCE")"
    exit 1
fi

for MOD_SUBDIR_NAME in "${MOD_SUBDIR_NAMES[@]}"; do
    echo "Processing: $MOD_SUBDIR_NAME"

    COPIED=0
    for subdir in "${SUBDIR_LIST[@]}"; do
        rm -rf "$subdir/$MOD_SUBDIR_NAME"
        SRC_ABS_PATH="$BG3_DATA/$subdir/$MOD_SUBDIR_NAME"
        if [ ! -d "$SRC_ABS_PATH" ]; then
            continue
        fi
        mkdir -p "$subdir"
        cp -a "$SRC_ABS_PATH" "$subdir"
        COPIED=1
    done

    if [ "$COPIED" -eq 0 ]; then
        echo "No mod directories found for '$MOD_SUBDIR_NAME' — skipping."
        continue
    fi

    ARCHIVE="${MOD_SUBDIR_NAME}.tar.gz"
    tar -czf "$ARCHIVE" "${SUBDIR_LIST[@]/%//$MOD_SUBDIR_NAME}" --ignore-failed-read 2>/dev/null || \
        tar -czf "$ARCHIVE" $(for s in "${SUBDIR_LIST[@]}"; do [ -d "$s/$MOD_SUBDIR_NAME" ] && echo "$s/$MOD_SUBDIR_NAME"; done)

    for subdir in "Projects" "Editor" "Mods" "Public" "Generated"; do
        rm -rf "$subdir"
    done
done

git add --all
git commit -m "Backup at $(date)"
git push