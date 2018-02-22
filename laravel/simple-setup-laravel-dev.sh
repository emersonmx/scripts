#!/bin/bash

echo 'Setup dev packages'
composer require doctrine/dbal
composer require --dev barryvdh/laravel-debugbar
composer require --dev barryvdh/laravel-ide-helper

php artisan clear-compiled
php artisan ide-helper:generate
php artisan ide-helper:meta
php artisan optimize

echo '_ide_helper.php' >> .gitignore
echo '.phpstorm.meta.php' >> .gitignore
