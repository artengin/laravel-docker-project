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

APP_DIR="/app"

if [ ! -f "$APP_DIR/artisan" ]; then
    TEMP_DIR="$APP_DIR/laravel_temp"
    composer create-project laravel/laravel "$TEMP_DIR" --prefer-dist

    cp -r "$TEMP_DIR"/. "$APP_DIR"/
    rm -rf "$TEMP_DIR"

    if [ ! -f "$APP_DIR/.env" ]; then
        cp "$APP_DIR/.env.example" "$APP_DIR/.env"
        php "$APP_DIR/artisan" key:generate
    fi
    composer require ronasit/laravel-project-initializator --dev
    chmod -R 777 storage
    chmod 777 database/database.sqlite
fi


ENTRYPOINT_FILE="$APP_DIR/docker/entrypoint.sh"
cat > "$ENTRYPOINT_FILE" <<'EOF'
#!/bin/bash
composer install

if [[ -f .env ]]; then
  echo ".env already exists"
else
  cp .env.example .env
  php artisan key:generate
  php artisan jwt:secret
fi

php artisan migrate --force
chmod -R 777 storage
EOF

chmod +x "$ENTRYPOINT_FILE"

echo "Setup complete!"

rm -- "$(realpath "$0")"