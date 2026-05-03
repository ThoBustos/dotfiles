#!/bin/bash
# Clone personal repos - runs once on new machine setup
# Managed by Chezmoi

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

clone_if_missing "ThoBustos/my-vault"  "$PROJECTS/my-vault"
clone_if_missing "ThoBustos/openyoko"  "$PROJECTS/openyoko"
clone_if_missing "ThoBustos/ideabench" "$PROJECTS/ideabench"
clone_if_missing "ThoBustos/learnrep"  "$PROJECTS/learnrep"

echo "Done cloning repos."
