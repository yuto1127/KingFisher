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
        // 1回のクエリでユーザー情報とパスワードハッシュを取得
        $userData = $this->authRepository->findByEmailWithPassword($email);
        
        if (!$userData) {
            throw ValidationException::withMessages([
                'email' => ['認証情報が正しくありません。'],
            ]);
        }

        // パスワード検証
        if (!$this->authRepository->verifyPasswordWithHash($password, $userData->password)) {
            throw ValidationException::withMessages([
                'email' => ['認証情報が正しくありません。'],
            ]);
        }

        // Userモデルのインスタンスを作成
        $user = User::find($userData->user_id);

        // 既存のトークンを削除
        $this->authRepository->deleteUserTokens($user);

        // 新しいトークンを生成
        $token = $this->authRepository->createToken($user);

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