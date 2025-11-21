#!/usr/bin/env bash

# Exit immediately if a command exits with a non-zero status.
set -e

# 1. Setup Environment
# Render passes variables via the environment, but Laravel's Artisan key:generate 
# command requires a .env file to be present when run. We create one from the 
# example file if it doesn't exist.
if [ ! -f .env ]; then
    cp .env.example .env
fi

# 2. Install PHP Dependencies
echo "--- Running composer install ---"
composer install --no-dev --prefer-dist

# 3. Generate Application Key (into the .env file)
echo "--- Generating Application Key ---"
php artisan key:generate

# 4. Clear and Cache Configuration/Routes for Performance
echo "--- Caching config and routes ---"
php artisan config:cache
php artisan route:cache

# 5. Run Database Migrations
# The --force flag confirms the migration command can run in production.
echo "--- Running database migrations ---"
php artisan migrate --force

# 6. Build Frontend Assets (Chatify may require this if it uses Laravel Mix/Vite)
# NOTE: Uncomment and set up Node.js for this if needed later.
# echo "--- Building Frontend Assets ---"
# npm install
# npm run build

echo "--- Deployment Script Complete ---"
