<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
// コントローラーのインポート
use App\Http\Controllers\Api\RolesController;
use App\Http\Controllers\Api\UsersController;
use App\Http\Controllers\Api\UserPassesController;
use App\Http\Controllers\Api\HelpDesksController;
use App\Http\Controllers\Api\CustomersController;

// role
Route::get('/roles', [RolesController::class, 'index']);
// user
Route::get('/users', [UsersController::class, 'index']);
// userpass
Route::get('/user-passes', [UserPassesController::class, 'index']);
// helpdesk
Route::get('/help-desks', [HelpDesksController::class, 'index']);
// customer
Route::get('/customers', [CustomersController::class, 'index']);


?>