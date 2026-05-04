#!/usr/bin/env bash
input=$(cat)

cwd=$(echo "$input"     | jq -r '.workspace.current_dir // .cwd // empty')
used_pct=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
vim_mode=$(echo "$input" | jq -r '.vim.mode // empty')
worktree_branch=$(echo "$input" | jq -r '.worktree.branch // empty')

# Colors
R='\033[0m'
DIM='\033[2m'
WHITE='\033[37m'
BLUE='\033[34m'
YELLOW='\033[33m'
GREEN='\033[32m'
ORANGE='\033[38;5;208m'
RED='\033[31m'
MAGENTA='\033[35m'

SEP="${DIM}  ${R}"

parts=()

# 1. Repo name
if [ -n "$cwd" ] && cd "$cwd" 2>/dev/null; then
    repo=$(basename "$(git rev-parse --show-toplevel 2>/dev/null)" 2>/dev/null)
    [ -n "$repo" ] && parts+=("${WHITE}${repo}${R}")

    # 3. Branch (collected here since we're already in cwd)
    branch=$(git symbolic-ref --short HEAD 2>/dev/null || git rev-parse --short HEAD 2>/dev/null)
    [ -n "$worktree_branch" ] && branch="$worktree_branch"
fi

# 2. Context % (remaining)
if [ -n "$used_pct" ]; then
    used_int=$(printf '%.0f' "$used_pct")
    rem=$((100 - used_int))
    if   [ "$rem" -le 20 ]; then pct_color="$RED"
    elif [ "$rem" -le 30 ]; then pct_color="$ORANGE"
    elif [ "$rem" -le 40 ]; then pct_color="$YELLOW"
    else pct_color="$GREEN"
    fi
    parts+=("${DIM}ctx:${R}${pct_color}${rem}%${R}")
fi

# 3. Branch
[ -n "$branch" ] && parts+=("${BLUE}${branch}${R}")

# 4. PR
if [ -n "$branch" ] && command -v gh &>/dev/null; then
    pr_raw=$(gh pr view --json number,state,isDraft 2>/dev/null)
    if [ -n "$pr_raw" ]; then
        pr_num=$(echo "$pr_raw"   | jq -r '.number // empty')
        pr_state=$(echo "$pr_raw" | jq -r '.state // empty')
        pr_draft=$(echo "$pr_raw" | jq -r '.isDraft // false')
        if [ -n "$pr_num" ]; then
            case "$pr_state" in
                OPEN)
                    if [ "$pr_draft" = "true" ]; then
                        parts+=("${YELLOW}#${pr_num}${R} ${DIM}draft${R}")
                    else
                        parts+=("${YELLOW}#${pr_num}${R} ${GREEN}review${R}")
                    fi
                    ;;
                MERGED) parts+=("${YELLOW}#${pr_num}${R} ${MAGENTA}merged${R}") ;;
                CLOSED) parts+=("${YELLOW}#${pr_num}${R} ${RED}closed${R}") ;;
            esac
        fi
    fi
fi

# Vim mode prefix (single letter, only when active)
prefix=""
if [ -n "$vim_mode" ]; then
    case "$vim_mode" in
        INSERT)  prefix="${GREEN}I${R}  " ;;
        NORMAL)  prefix="${BLUE}N${R}  " ;;
        VISUAL*) prefix="${YELLOW}V${R}  " ;;
    esac
fi

# Join
result=""
for part in "${parts[@]}"; do
    [ -z "$result" ] && result="$part" || result="${result}${SEP}${part}"
done

printf "%b\n" "${prefix}${result}"
