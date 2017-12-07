#!/bin/bash

echo 'Move User to App/Models'
if [ -f 'app/User.php' ]
then
    mkdir -p app/Models
    mv app/User.php app/Models/
    sed 's#^namespace App;#namespace App\\Models;#g' -i app/Models/User.php
fi

sed "s#'App\.User\.#'App.Models.User.#g" -i routes/channels.php
sed 's#App\\User::class#App\\Models\\User::class#g' -i config/auth.php
sed 's#App\\User::class#App\\Models\\User::class#g' -i config/services.php
sed 's#App\\User::class#App\\Models\\User::class#g' -i database/factories/UserFactory.php
sed 's#App\\User#App\\Models\\User#g' -i app/Http/Controllers/Auth/RegisterController.php

echo 'Create Services and Repositories'
mkdir -p app/{Services,Repositories}

echo 'Setup phpunit to use sqlite db in memory'
sed '
/<env name="APP_ENV" value="testing"\/>/ a\
        <env name="DB_CONNECTION" value="sqlite"/>\
        <env name="DB_DATABASE" value=":memory:"/>
' -i phpunit.xml


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
