<?php

use Illuminate\Support\Facades\Route;

// routes/web.php
Route::get('/login', function () {
    // ログイン画面のビューを返す
    return view('login');
})->name('login');

Route::get('/', function () {
    return view('welcome');
});
