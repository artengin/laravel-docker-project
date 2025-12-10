#!/bin/bash
set -e

if command -v git &>/dev/null && git rev-parse --is-inside-work-tree &>/dev/null; then
    git remote get-url origin &>/dev/null && git remote remove origin

    new_commit=$(git commit-tree HEAD^{tree} -m "chore: initial commit")
    git reset --soft "$new_commit"

    git commit --amend -m "chore: initial commit" &>/dev/null

    read -rp "Do you want to add a remote Git repository? [Y/N]: " add_remote
    add_remote=${add_remote,,}

    if [[ "$add_remote" == "y" || "$add_remote" == "yes" ]]; then
        is_valid_ssh_url() {
            [[ "$1" =~ ^git@[^:]+:[^/]+/.+\.git$ ]]
        }

        is_repo_accessible() {
            git ls-remote "$1" &>/dev/null
        }

        while true; do
            echo
            read -rp "Enter the SSH Git repository URL of the project: " repo_url

            if ! is_valid_ssh_url "$repo_url"; then
                echo "Invalid SSH URL. Example: git@github.com:user/repo.git"
                continue
            fi

            if ! is_repo_accessible "$repo_url"; then
                echo "Cannot access repository at '$repo_url'. Check URL or SSH keys."
                continue
            fi

            git remote add origin "$repo_url"
            echo "Added new remote 'origin' $repo_url"
            break
        done
    fi
fi

if command -v docker &>/dev/null; then
    docker compose up -d
    docker compose exec -it nginx bash /app/init-project.sh
else
    echo "Error: Docker is not installed. Cannot start containers."
    exit 1
fi

rm -- "$(realpath "${BASH_SOURCE[0]}")"