<?php

require_once 'vendor/autoload.php';

use App\Services\AuthService;
use App\Repositories\AuthRepository;

// Laravelアプリケーションをブートストラップ
$app = require_once 'bootstrap/app.php';
$app->make('Illuminate\Contracts\Console\Kernel')->bootstrap();

echo "=== AuthService ログインテスト ===\n";

try {
    // AuthServiceのインスタンスを作成
    $authRepository = new AuthRepository();
    $authService = new AuthService($authRepository);
    
    $email = 'kingfisher@gmail.com';
    $password = 'password';
    
    echo "ログイン試行: {$email}\n";
    
    // ログイン処理を実行
    $result = $authService->login($email, $password);
    
    echo "ログイン成功!\n";
    echo "Token: " . substr($result['token'], 0, 20) . "...\n";
    echo "User ID: " . $result['user']->id . "\n";
    echo "User Name: " . $result['user']->name . "\n";
    
} catch (Exception $e) {
    echo "ログイン失敗: " . $e->getMessage() . "\n";
    echo "Exception class: " . get_class($e) . "\n";
    
    if ($e instanceof \Illuminate\Validation\ValidationException) {
        echo "Validation errors:\n";
        foreach ($e->errors() as $field => $errors) {
            foreach ($errors as $error) {
                echo "  - {$field}: {$error}\n";
            }
        }
    }
}

echo "\n=== テスト完了 ===\n"; 