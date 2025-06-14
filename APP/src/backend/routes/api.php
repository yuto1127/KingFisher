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
use App\Http\Controllers\Api\AuthController;

// 認証関連のルート（認証不要）
Route::post('/login', [AuthController::class, 'login']);

// 認証が必要なルートグループ
Route::middleware('auth:sanctum')->group(function () {
    // ログアウト
    Route::post('/logout', [AuthController::class, 'logout']);

    // role
    Route::prefix('roles')->group(function () {
        Route::get('/', [RolesController::class, 'index']);
        Route::post('/', [RolesController::class, 'store']);
        Route::put('/{id}', [RolesController::class, 'update']);
        Route::delete('/{id}', [RolesController::class, 'destroy']);
    });

    // user
    Route::prefix('users')->group(function () {
        Route::get('/', [UsersController::class, 'index']);
        Route::post('/', [UsersController::class, 'store']);
        Route::put('/{id}', [UsersController::class, 'update']);
        Route::delete('/{id}', [UsersController::class, 'destroy']);
    });

    // userpass
    Route::prefix('user-passes')->group(function () {
        Route::get('/', [UserPassesController::class, 'index']);
        Route::post('/', [UserPassesController::class, 'store']);
        Route::put('/{id}', [UserPassesController::class, 'update']);
        Route::delete('/{id}', [UserPassesController::class, 'destroy']);
        
        // パスワード関連の新しいルート
        Route::post('/{id}/verify-password', [UserPassesController::class, 'verifyPassword']);
        Route::put('/{id}/password', [UserPassesController::class, 'updatePassword']);
        Route::post('/find-by-password', [UserPassesController::class, 'findByPassword']);
    });

    // helpdesk
    Route::prefix('help-desks')->group(function () {
        Route::get('/', [HelpDesksController::class, 'index']);
        Route::post('/', [HelpDesksController::class, 'store']);
        Route::put('/{id}', [HelpDesksController::class, 'update']);
        Route::delete('/{id}', [HelpDesksController::class, 'destroy']);
    });

    // customer
    Route::prefix('customers')->group(function () {
        Route::get('/', [CustomersController::class, 'index']);
        Route::post('/', [CustomersController::class, 'store']);
        Route::put('/{id}', [CustomersController::class, 'update']);
        Route::delete('/{id}', [CustomersController::class, 'destroy']);
    });

    // event
    Route::prefix('events')->group(function () {
        Route::get('/', [EventsController::class, 'index']);
        Route::post('/', [EventsController::class, 'store']);
        Route::put('/{id}', [EventsController::class, 'update']);
        Route::delete('/{id}', [EventsController::class, 'destroy']);
    });

    // entry-status
    Route::prefix('entry-statuses')->group(function () {
        Route::get('/', [EntryStatusesController::class, 'index']);
        Route::post('/', [EntryStatusesController::class, 'store']);
        Route::put('/{id}', [EntryStatusesController::class, 'update']);
        Route::delete('/{id}', [EntryStatusesController::class, 'destroy']);
    });
});





