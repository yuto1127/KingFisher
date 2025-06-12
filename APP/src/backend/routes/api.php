<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
// コントローラーのインポート
use App\Http\Controllers\Api\RolesController;
use App\Http\Controllers\Api\UsersController;
use App\Http\Controllers\Api\UserPassesController;
use App\Http\Controllers\Api\HelpDesksController;
use App\Http\Controllers\Api\CustomersController;
use App\Http\Controllers\Api\EventsController;
use App\Http\Controllers\Api\EntryStatusesController;

// role
Route::get('/roles', [RolesController::class, 'index']);
Route::post('/roles', [RolesController::class, 'store']);
Route::put('/roles/{id}', [RolesController::class, 'update']);
Route::delete('/roles/{id}', [RolesController::class, 'destroy']);
// user
Route::get('/users', [UsersController::class, 'index']);
Route::post('/users', [UsersController::class, 'store']);
Route::put('/users/{id}', [UsersController::class, 'update']);
Route::delete('/users/{id}', [UsersController::class, 'destroy']);
// userpass
Route::get('/user-passes', [UserPassesController::class, 'index']);
Route::post('/user-passes', [UserPassesController::class, 'store']);
Route::put('/user-passes/{id}', [UserPassesController::class, 'update']);
Route::delete('/user-passes/{id}', [UserPassesController::class, 'destroy']);
// helpdesk
Route::get('/help-desks', [HelpDesksController::class, 'index']);
Route::post('/help-desks', [HelpDesksController::class, 'store']);
Route::put('/help-desks/{id}', [HelpDesksController::class, 'update']);
Route::delete('/help-desks/{id}', [HelpDesksController::class, 'destroy']);
// customer
Route::get('/customers', [CustomersController::class, 'index']);
Route::post('/customers', [CustomersController::class, 'store']);
Route::put('/customers/{id}', [CustomersController::class, 'update']);
Route::delete('/customers/{id}', [CustomersController::class, 'destroy']);
// event
Route::get('/events', [EventsController::class, 'index']);
Route::post('/events', [EventsController::class, 'store']);
Route::put('/events/{id}', [EventsController::class, 'update']);
Route::delete('/events/{id}', [EventsController::class, 'destroy']);
// entry-status
Route::get('/entry-statuses', [EntryStatusesController::class, 'index']);
Route::post('/entry-statuses', [EntryStatusesController::class, 'store']);
Route::put('/entry-statuses/{id}', [EntryStatusesController::class, 'update']);
Route::delete('/entry-statuses/{id}', [EntryStatusesController::class, 'destroy']);





