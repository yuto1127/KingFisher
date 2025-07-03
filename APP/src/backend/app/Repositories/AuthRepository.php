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
            ->select(
                'users.id',
                'users.name',
                'users.gender',
                'users.barth_day',
                'users.phone_number',
                'users.postal_code',
                'users.prefecture',
                'users.city',
                'users.address_line1',
                'users.address_line2',
                'users.is_active',
                'users.last_login_at',
                'users.created_at',
                'users.updated_at',
                'user_passes.password',
                'user_passes.user_id',
                'user_passes.email'
            )
            ->first();
    }

    public function verifyPasswordWithHash(string $password, string $hashedPassword): bool
    {
        return Hash::check($password, $hashedPassword);
    }

    public function deleteUserTokens(User $user): void
    {
        try {
            if (!Schema::hasTable('personal_access_tokens')) {
                \Log::warning('personal_access_tokens table does not exist', [
                    'user_id' => $user->id
                ]);
                return;
            }

            // テーブルのカラム構造を確認
            $columns = Schema::getColumnListing('personal_access_tokens');
            
            if (in_array('tokenable_id', $columns) && in_array('tokenable_type', $columns)) {
                $deletedCount = DB::table('personal_access_tokens')
                    ->where('tokenable_id', $user->id)
                    ->where('tokenable_type', User::class)
                    ->delete();
                
                \Log::info('Deleted existing tokens', [
                    'user_id' => $user->id,
                    'deleted_count' => $deletedCount
                ]);
            } else {
                // カラムが存在しない場合は、別の方法でトークンを削除
                \Log::warning('personal_access_tokens table missing required columns', [
                    'user_id' => $user->id,
                    'available_columns' => $columns,
                    'required_columns' => ['tokenable_id', 'tokenable_type']
                ]);
                
                // 代替方法：テーブル全体をクリア（注意が必要）
                // DB::table('personal_access_tokens')->truncate();
            }
        } catch (\Exception $e) {
            \Log::error('Error deleting user tokens', [
                'user_id' => $user->id,
                'error' => $e->getMessage(),
                'trace' => $e->getTraceAsString()
            ]);
            
            // エラーが発生してもログイン処理を続行
            // トークン削除の失敗は致命的ではない
        }
    }

    public function createToken(User $user): string
    {
        try {
        if (!Schema::hasTable('personal_access_tokens')) {
                \Log::error('personal_access_tokens table does not exist', [
                    'user_id' => $user->id
                ]);
            throw new \Exception('personal_access_tokensテーブルが存在しません。マイグレーションを実行してください。');
        }

        $token = $user->createToken('auth-token');
            
            \Log::info('Token created successfully', [
                'user_id' => $user->id,
                'token_prefix' => substr($token->plainTextToken, 0, 10) . '...'
            ]);
            
        return $token->plainTextToken;
        } catch (\Exception $e) {
            \Log::error('Error creating token', [
                'user_id' => $user->id,
                'error' => $e->getMessage(),
                'trace' => $e->getTraceAsString()
            ]);
            throw $e;
        }
    }

    public function deleteCurrentToken(User $user): void
    {
        try {
        if (!Schema::hasTable('personal_access_tokens')) {
                \Log::warning('personal_access_tokens table does not exist', [
                    'user_id' => $user->id
                ]);
                return;
        }

        $user->currentAccessToken()->delete();
            
            \Log::info('Current token deleted successfully', [
                'user_id' => $user->id
            ]);
        } catch (\Exception $e) {
            \Log::error('Error deleting current token', [
                'user_id' => $user->id,
                'error' => $e->getMessage(),
                'trace' => $e->getTraceAsString()
            ]);
            
            // エラーが発生してもログアウト処理を続行
            // トークン削除の失敗は致命的ではない
        }
    }
} 