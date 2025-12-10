#!/bin/bash
set -e

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
    chmod -R 777 storage
    chmod 777 database/database.sqlite
    composer require ronasit/laravel-project-initializator --dev

    echo
    read -p $'\033[32mSet project name:\033[0m ' PROJECT_NAME

    php "$APP_DIR/artisan" init "$PROJECT_NAME"
    php "$APP_DIR/artisan" migrate
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

rm -- "$(realpath "${BASH_SOURCE[0]}")"