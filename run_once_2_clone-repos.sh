#!/bin/bash
# Clone personal repos - runs once on new machine setup
# Managed by Chezmoi

set -euo pipefail

# Verify SSH access to GitHub before attempting clones
# ssh -T exits with code 1 even on success; capture output with || true to avoid pipefail
ssh_out=$(ssh -T git@github.com -o StrictHostKeyChecking=no 2>&1 || true)
if ! echo "$ssh_out" | grep -q "successfully authenticated"; then
    echo "ERROR: SSH authentication to GitHub failed."
    echo "Ensure your SSH key is added to https://github.com/settings/keys and run again."
    exit 1
fi

PROJECTS="$HOME/Documents/projects"
mkdir -p "$PROJECTS"

echo "Cloning personal repos to $PROJECTS..."

clone_if_missing() {
    local repo=$1
    local dir=$2
    if [ ! -d "$dir" ]; then
        echo "Cloning $repo..."
        git clone "git@github.com:$repo.git" "$dir"
    else
        echo "Already exists: $dir"
    fi
}

# Fork this repo? Update the list below with your own repos.
clone_if_missing "ThoBustos/my-vault"  "$PROJECTS/my-vault"
clone_if_missing "ThoBustos/openyoko"  "$PROJECTS/openyoko"
clone_if_missing "ThoBustos/ideabench" "$PROJECTS/ideabench"
clone_if_missing "ThoBustos/learnrep"  "$PROJECTS/learnrep"

echo "Done cloning repos."
