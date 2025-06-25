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
use Illuminate\Support\Facades\Hash;

// 認証関連のルート（認証不要）
Route::get('/ping', function () {
    return response()->json(['message' => 'pong'], 200);
});

// デバッグ用エンドポイント
Route::get('/debug/users', function () {
    $users = \Illuminate\Support\Facades\DB::table('users')->get();
    $userPasses = \Illuminate\Support\Facades\DB::table('user_passes')->get();
    
    return response()->json([
        'users' => $users,
        'user_passes' => $userPasses,
        'count' => [
            'users' => $users->count(),
            'user_passes' => $userPasses->count()
        ]
    ]);
});

// 新規登録ユーザーのデバッグ用エンドポイント
Route::get('/debug/registration-test/{email}', function ($email) {
    $userPass = \Illuminate\Support\Facades\DB::table('user_passes')
        ->where('email', $email)
        ->first();
    
    if (!$userPass) {
        return response()->json([
            'error' => 'ユーザーパスが見つかりません',
            'email' => $email
        ]);
    }
    
    $user = \Illuminate\Support\Facades\DB::table('users')
        ->where('id', $userPass->user_id)
        ->first();
    
    $customer = \Illuminate\Support\Facades\DB::table('customers')
        ->where('user_id', $userPass->user_id)
        ->first();
    
    $role = null;
    if ($customer) {
        $role = \Illuminate\Support\Facades\DB::table('roles')
            ->where('id', $customer->role_id)
            ->first();
    }
    
    return response()->json([
        'email' => $email,
        'user_pass' => $userPass,
        'user' => $user,
        'customer' => $customer,
        'role' => $role,
        'all_tables_complete' => $userPass && $user && $customer && $role
    ]);
});

// パスワードテスト用エンドポイント
Route::post('/debug/test-password', function (Request $request) {
    $email = $request->input('email');
    $password = $request->input('password');
    
    $userPass = \Illuminate\Support\Facades\DB::table('user_passes')
        ->where('email', $email)
        ->first();
    
    if (!$userPass) {
        return response()->json([
            'error' => 'ユーザーが見つかりません',
            'email' => $email
        ]);
    }
    
    $isValid = Hash::check($password, $userPass->password);
    
    return response()->json([
        'email' => $email,
        'password_provided' => $password,
        'stored_hash' => $userPass->password,
        'is_valid' => $isValid,
        'user_id' => $userPass->user_id
    ]);
});

Route::post('/login', [AuthController::class, 'login']);
Route::post('/register', [AuthController::class, 'register']);
Route::post('/users', [UsersController::class, 'store']);
Route::post('/user-passes', [UserPassesController::class, 'store']);
Route::post('/customers', [CustomersController::class, 'store']);


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
        Route::get('/{id}', [UsersController::class, 'show']);
        Route::put('/{id}', [UsersController::class, 'update']);
        Route::delete('/{id}', [UsersController::class, 'destroy']);
    });
    
    // userpass
    Route::prefix('user-passes')->group(function () {
        Route::get('/', [UserPassesController::class, 'index']);
        Route::put('/{id}', [UserPassesController::class, 'update']);
        Route::delete('/{id}', [UserPassesController::class, 'destroy']);
        
        // パスワード関連の新しいルート
        Route::post('/{id}/verify-password', [UserPassesController::class, 'verifyPassword']);
        Route::put('/{id}/password', [UserPassesController::class, 'updatePassword']);
        Route::post('/find-by-password', [UserPassesController::class, 'findByPassword']);
        Route::post('/check-email', [UserPassesController::class, 'checkEmailExists']);
    });
    
    // helpdesk
    Route::prefix('help-desks')->group(function () {
        Route::get('/', [HelpDesksController::class, 'index']);
        Route::post('/help-desks', [HelpDesksController::class, 'store']);
        Route::put('/{id}', [HelpDesksController::class, 'update']);
        Route::delete('/{id}', [HelpDesksController::class, 'destroy']);
    });
    
    // customer
    Route::prefix('customers')->group(function () {
        Route::get('/', [CustomersController::class, 'index']);
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
        
        // バーコードスキャンによる入退室処理
        Route::post('/toggle', [EntryStatusesController::class, 'toggleEntryStatus']);
        Route::get('/user/{userId}', [EntryStatusesController::class, 'getUserEntryStatus']);
    });
});






