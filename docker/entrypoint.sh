#!/bin/bash
set -e

APP_DIR="/app"

if [ ! -f "$APP_DIR/artisan" ]; then
    TEMP_DIR="$APP_DIR/laravel_temp"
    composer create-project laravel/laravel "$TEMP_DIR"

    cp -r "$TEMP_DIR"/. "$APP_DIR"/
    rm -rf "$TEMP_DIR"

    if [ ! -f "$APP_DIR/.env" ]; then
        cp "$APP_DIR/.env.example" "$APP_DIR/.env"
        php "$APP_DIR/artisan" key:generate
    fi
else
  if [[ -f .env ]]; then
    echo ".env already exists"
  else
    cp .env.example .env
    php artisan key:generate
    php artisan jwt:secret
  fi

  php artisan migrate --force
  chmod -R 777 storage
fi