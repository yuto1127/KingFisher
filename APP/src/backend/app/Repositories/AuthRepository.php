<?php

namespace App\Repositories;

use App\Models\User;
use App\Models\UserPass;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;

class AuthRepository
{
    public function findByEmail(string $email): ?User
    {
        $userPass = DB::table('user_passes')
            ->join('users', 'user_passes.user_id', '=', 'users.id')
            ->where('user_passes.email', $email)
            ->select('users.*', 'user_passes.password', 'user_passes.user_id')
            ->first();

        if (!$userPass) {
            return null;
        }

        return User::find($userPass->user_id);
    }

    public function findByEmailWithPassword(string $email): ?object
    {
        return DB::table('user_passes')
            ->join('users', 'user_passes.user_id', '=', 'users.id')
            ->where('user_passes.email', $email)
            ->select('users.*', 'user_passes.password', 'user_passes.user_id')
            ->first();
    }

    public function verifyPassword(User $user, string $password): bool
    {
        $userPass = DB::table('user_passes')
            ->where('user_id', $user->id)
            ->first();

        if (!$userPass) {
            return false;
        }

        return Hash::check($password, $userPass->password);
    }

    public function verifyPasswordWithHash(string $password, string $hashedPassword): bool
    {
        return Hash::check($password, $hashedPassword);
    }

    public function deleteUserTokens(User $user): void
    {
        if (Schema::hasTable('personal_access_tokens')) {
            DB::table('personal_access_tokens')
                ->where('tokenable_id', $user->id)
                ->where('tokenable_type', User::class)
                ->delete();
        }
    }

    public function createToken(User $user): string
    {
        if (!Schema::hasTable('personal_access_tokens')) {
            throw new \Exception('personal_access_tokensテーブルが存在しません。マイグレーションを実行してください。');
        }

        $token = $user->createToken('auth-token');
        return $token->plainTextToken;
    }

    public function deleteCurrentToken(User $user): void
    {
        if (!Schema::hasTable('personal_access_tokens')) {
            throw new \Exception('personal_access_tokensテーブルが存在しません。マイグレーションを実行してください。');
        }

        $user->currentAccessToken()->delete();
    }
} 