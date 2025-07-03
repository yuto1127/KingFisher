<?php

require_once 'vendor/autoload.php';

use Illuminate\Support\Facades\Hash;
use App\Models\UserPass;
use App\Models\User;

// Laravelアプリケーションをブートストラップ
$app = require_once 'bootstrap/app.php';
$app->make('Illuminate\Contracts\Console\Kernel')->bootstrap();

echo "=== ログインテスト ===\n";

// 1. ユーザーパスデータの確認
echo "1. ユーザーパスデータの確認:\n";
$userPass = UserPass::where('email', 'kingfisher@gmail.com')->first();
if ($userPass) {
    echo "   - Email: {$userPass->email}\n";
    echo "   - User ID: {$userPass->user_id}\n";
    echo "   - Password Hash: " . substr($userPass->password, 0, 20) . "...\n";
} else {
    echo "   - ユーザーパスが見つかりません\n";
    exit(1);
}

// 2. ユーザーデータの確認
echo "\n2. ユーザーデータの確認:\n";
$user = User::find($userPass->user_id);
if ($user) {
    echo "   - ID: {$user->id}\n";
    echo "   - Name: {$user->name}\n";
    echo "   - Active: " . ($user->is_active ? 'Yes' : 'No') . "\n";
} else {
    echo "   - ユーザーが見つかりません\n";
    exit(1);
}

// 3. パスワード検証のテスト
echo "\n3. パスワード検証のテスト:\n";
$testPassword = 'password';
$isValid = Hash::check($testPassword, $userPass->password);
echo "   - Test Password: {$testPassword}\n";
echo "   - Valid: " . ($isValid ? 'Yes' : 'No') . "\n";

// 4. Sanctumトークン生成のテスト
echo "\n4. Sanctumトークン生成のテスト:\n";
try {
    $token = $user->createToken('test-token');
    echo "   - Token created: " . substr($token->plainTextToken, 0, 20) . "...\n";
    echo "   - Token ID: {$token->accessToken->id}\n";
} catch (Exception $e) {
    echo "   - Error creating token: " . $e->getMessage() . "\n";
}

echo "\n=== テスト完了 ===\n"; 