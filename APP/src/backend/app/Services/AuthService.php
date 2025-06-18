<?php

namespace App\Services;

use App\Repositories\AuthRepository;
use App\Models\User;
use Illuminate\Validation\ValidationException;
use Illuminate\Support\Facades\Log;

class AuthService
{
    private $authRepository;

    public function __construct(AuthRepository $authRepository)
    {
        $this->authRepository = $authRepository;
    }

    public function login(string $email, string $password): array
    {
        $user = $this->authRepository->findByEmail($email);
        Log::info(Hash::make($password));
        if (!$user || !$this->authRepository->verifyPassword($user, $password)) {
            throw ValidationException::withMessages([
                'email' => ['認証情報が正しくありません。'],
            ]);
        }

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