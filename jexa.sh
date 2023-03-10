#!/bin/bash
clear
echo "Masukkan Password VPS"
cd /var/www/pterodactyl
cp -R /var/www/pterodactyl /var/www/pterodactyl-backup
mysqldump -u root -p panel > /var/www/pterodactyl-backup/panel.sql
php artisan down
curl -L -o panel.tar.gz https://github.com/jexactyl/jexactyl/releases/latest/download/panel.tar.gz
tar -xzvf panel.tar.gz && rm -f panel.tar.gz
chmod -R 755 storage/* bootstrap/cache
composer install --no-dev --optimize-autoloader
php artisan optimize:clear
php artisan migrate --seed --force
chown -R www-data:www-data /var/www/pterodactyl/*
php artisan queue:restart
php artisan up
