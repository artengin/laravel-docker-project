#!/bin/bash
set -e

is_valid_ssh_url() {
    [[ "$1" =~ ^git@[^:]+:[^/]+/.+\.git$ ]]
}

is_repo_accessible() {
    git ls-remote "$1" &>/dev/null
}

git remote get-url origin &>/dev/null && git remote remove origin

while true; do
    echo
    read -rp "Enter SSH Git repository URL: " repo_url

    if ! is_valid_ssh_url "$repo_url"; then
        echo "Invalid SSH URL. Example: git@github.com:user/repo.git"
        continue
    fi

    if ! is_repo_accessible "$repo_url"; then
        echo "Cannot access repository at '$repo_url'. Check URL or SSH keys."
        continue
    fi

    git remote add origin "$repo_url"
    echo "Added new remote 'origin' → $repo_url"
    break
done