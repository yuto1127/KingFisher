#!/bin/bash

echo "=== KingFisher Database Setup ==="

# マイグレーションの実行
echo "Running migrations..."
php artisan migrate --force

# シーダーの実行（順序を考慮）
echo "Running seeders..."

echo "1. Seeding roles..."
php artisan db:seed --class=RolesSeeder --force

echo "2. Seeding users..."
php artisan db:seed --class=UsersSeeder --force

echo "3. Seeding user passes..."
php artisan db:seed --class=UserPassesSeeder --force

echo "4. Seeding help desks..."
php artisan db:seed --class=HelpDesksSeeder --force

echo "5. Seeding customers..."
php artisan db:seed --class=CustomersSeeder --force

echo "6. Seeding events..."
php artisan db:seed --class=EventsSeeder --force

echo "7. Seeding entry statuses..."
php artisan db:seed --class=EntryStatusesSeeder --force

echo "8. Seeding points..."
php artisan db:seed --class=PointsSeeder --force

echo "=== Database setup completed successfully! ===" 