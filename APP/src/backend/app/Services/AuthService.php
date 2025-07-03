<?php

namespace App\Services;

use App\Repositories\AuthRepository;
use App\Models\User;
use Illuminate\Validation\ValidationException;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\DB;

class AuthService
{
    private $authRepository;

    public function __construct(AuthRepository $authRepository)
    {
        $this->authRepository = $authRepository;
    }

    public function login(string $email, string $password): array
    {
        Log::info('AuthService: Starting login process', ['email' => $email]);

        // 1回のクエリでユーザー情報とパスワードハッシュを取得
        $userData = $this->authRepository->findByEmailWithPassword($email);
        
        Log::info('AuthService: User data retrieved', [
            'email' => $email,
            'user_found' => $userData !== null,
            'user_id' => $userData?->user_id ?? null,
            'user_email_from_db' => $userData?->email ?? null,
            'user_name_from_db' => $userData?->name ?? null
        ]);

        if (!$userData) {
            Log::warning('AuthService: User not found', ['email' => $email]);
            throw ValidationException::withMessages([
                'email' => ['メールアドレスが正しくありません。'],
            ]);
        }

        // パスワード検証
        $passwordValid = $this->authRepository->verifyPasswordWithHash($password, $userData->password);
        
        Log::info('AuthService: Password verification result', [
            'email' => $email,
            'password_valid' => $passwordValid,
            'password_length' => strlen($password),
            'hashed_password_prefix' => substr($userData->password, 0, 20) . '...',
            'password_check_result' => Hash::check($password, $userData->password)
        ]);

        if (!$passwordValid) {
            Log::warning('AuthService: Invalid password', ['email' => $email]);
            throw ValidationException::withMessages([
                'password' => ['パスワードが正しくありません。'],
            ]);
        }

        // Userモデルのインスタンスを作成
        $user = User::find($userData->user_id);
        
        if (!$user) {
            Log::error('AuthService: User model not found', [
                'email' => $email,
                'user_id' => $userData->user_id
            ]);
            throw ValidationException::withMessages([
                'email' => ['ユーザー情報の取得に失敗しました。'],
            ]);
        }

        // メールアドレスをユーザーオブジェクトに追加
        $user->email = $userData->email ?? $email; // データベースから取得できない場合は引数のemailを使用

        // ロール情報を取得
        $roleInfo = $user->getRoleInfo();
        
        if ($roleInfo) {
            $user->role_id = $roleInfo['role_id'];
            $user->role_name = $roleInfo['role_name'];
            $user->role_type = $roleInfo['type'];
        }

        Log::info('AuthService: User model found', [
            'email' => $email,
            'user_id' => $user->id,
            'user_name' => $user->name,
            'user_email' => $user->email,
            'role_id' => $user->role_id ?? null,
            'role_name' => $user->role_name ?? null,
            'role_type' => $user->role_type ?? null
        ]);

        // 既存のトークンを削除
        $this->authRepository->deleteUserTokens($user);

        // 新しいトークンを生成
        $token = $this->authRepository->createToken($user);

        Log::info('AuthService: Login successful', [
            'email' => $email,
            'user_id' => $user->id,
            'token_generated' => !empty($token)
        ]);

        return [
            'token' => $token,
            'user' => $user
        ];
    }

    public function logout(User $user): void
    {
        $this->authRepository->deleteCurrentToken($user);
    }

    public function register(array $data): array
    {
        Log::info('AuthService: Starting registration process', [
            'email' => $data['email'],
            'name' => $data['name']
        ]);

        try {
            // トランザクション開始
            DB::beginTransaction();

            // 1. ユーザー情報を作成
            $userData = [
                'name' => $data['name'],
                'gender' => $data['gender'],
                'barth_day' => $data['barth_day'],
                'phone_number' => $data['phone_number'],
                'postal_code' => $data['postal_code'] ?? null,
                'prefecture' => $data['prefecture'] ?? null,
                'city' => $data['city'] ?? null,
                'address_line1' => $data['address_line1'] ?? null,
                'address_line2' => $data['address_line2'] ?? null,
                'is_active' => true,
            ];

            $user = User::create($userData);

            Log::info('AuthService: User created', [
                'user_id' => $user->id,
                'name' => $user->name
            ]);

            // 2. ユーザーパス情報を作成
            $userPassData = [
                'user_id' => $user->id,
                'email' => $data['email'],
                'password' => Hash::make($data['password']),
            ];

            \App\Models\UserPass::create($userPassData);

            Log::info('AuthService: UserPass created', [
                'user_id' => $user->id,
                'email' => $data['email']
            ]);

            // 3. 顧客情報を作成（デフォルトロールID: 3）
            $customerData = [
                'user_id' => $user->id,
                'role_id' => 3, // デフォルトの顧客ロール
            ];

            \App\Models\Customer::create($customerData);

            Log::info('AuthService: Customer created', [
                'user_id' => $user->id,
                'role_id' => 3
            ]);

            // トランザクションコミット
            DB::commit();

            Log::info('AuthService: Registration successful', [
                'user_id' => $user->id,
                'email' => $data['email']
            ]);

            return [
                'user_id' => $user->id,
                'message' => '会員登録が完了しました'
            ];

        } catch (\Exception $e) {
            // トランザクションロールバック
            DB::rollBack();

            Log::error('AuthService: Registration failed', [
                'error' => $e->getMessage(),
                'trace' => $e->getTraceAsString()
            ]);

            throw $e;
        }
    }
} 