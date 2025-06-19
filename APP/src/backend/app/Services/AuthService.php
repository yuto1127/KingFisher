<?php

namespace App\Services;

use App\Repositories\AuthRepository;
use App\Models\User;
use Illuminate\Validation\ValidationException;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Hash;

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
            'user_id' => $userData?->user_id ?? null
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
} 