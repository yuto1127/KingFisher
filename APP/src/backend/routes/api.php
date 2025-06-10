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
Route::post('/roles', [RolesController::class, 'store']);
Route::put('/roles/{id}', [RolesController::class, 'update']);
Route::delete('/roles/{id}', [RolesController::class, 'destroy']);
// user
Route::get('/users', [UsersController::class, 'index']);
// userpass
Route::get('/user-passes', [UserPassesController::class, 'index']);
// helpdesk
Route::get('/help-desks', [HelpDesksController::class, 'index']);
// customer
Route::get('/customers', [CustomersController::class, 'index']);


