#!/bin/bash

# https://github.com/barryvdh/laravel-debugbar
# https://github.com/barryvdh/laravel-ide-helper

composer require doctrine/dbal
composer require --dev barryvdh/laravel-debugbar
composer require --dev barryvdh/laravel-ide-helper

php artisan clear-compiled
php artisan ide-helper:generate
php artisan ide-helper:meta
php artisan optimize
