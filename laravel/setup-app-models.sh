#!/bin/bash


#routes/channels.php:14:25:Broadcast::channel('App.User.{id}', function ($user, $id) {
#app/Http/Controllers/Auth/RegisterController.php:5:9:use App\User;
#app/Http/Controllers/Auth/RegisterController.php:61:21:     * @return \App\User
#app/Http/Controllers/Auth/RegisterController.php:65:16:        return User::create([
#app/User.php -> app/Models/User.php
#app/User.php: namespace App;
#config/auth.php:70:28:            'model' => App\User::class
#config/services.php:33:24:        'model' => App\User::class,
#database/factories/UserFactory.php:16:22:$factory->define(App\User::class, function (Faker $faker) {

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
