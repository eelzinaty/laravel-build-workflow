<?php

use Illuminate\Support\Facades\Route;

Route::get('/', function () {
    // Load the content of the README.md file
    $readmeContent = File::get(base_path('README.md'));

    // Pass the README content to the landing page view
    return view('welcome with super caching', ['readmeContent' => nl2br($readmeContent)]);
});
