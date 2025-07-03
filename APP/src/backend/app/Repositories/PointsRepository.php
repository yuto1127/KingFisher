<?php

namespace App\Repositories;

use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;

class PointsRepository
{
    /**
     * ユーザーのポイントを取得
     */
    public function getUserPoints(int $userId): int
    {
        try {
            $result = DB::table('points')
                ->where('user_id', $userId)
                ->selectRaw('COALESCE(SUM(point), 0) as total_points')
                ->first();

            return (int) $result->total_points;
        } catch (\Exception $e) {
            Log::error('Database error in getUserPoints', [
                'user_id' => $userId,
                'error' => $e->getMessage()
            ]);
            
            throw $e;
        }
    }

    /**
     * ポイント履歴を取得
     */
    public function getPointHistory(int $userId, int $limit = 10): array
    {
        try {
            $history = DB::table('points')
                ->where('user_id', $userId)
                ->select([
                    'id',
                    'point',
                    'created_at'
                ])
                ->orderBy('created_at', 'desc')
                ->limit($limit)
                ->get()
                ->toArray();

            return $history;
        } catch (\Exception $e) {
            Log::error('Database error in getPointHistory', [
                'user_id' => $userId,
                'limit' => $limit,
                'error' => $e->getMessage()
            ]);
            
            throw $e;
        }
    }

    /**
     * ポイントを追加
     */
    public function addPoints(int $userId, int $points, string $description = ''): bool
    {
        try {
            DB::table('points')->insert([
                'user_id' => $userId,
                'point' => $points,
                'created_at' => now(),
                'updated_at' => now()
            ]);

            return true;
        } catch (\Exception $e) {
            Log::error('Database error in addPoints', [
                'user_id' => $userId,
                'points' => $points,
                'description' => $description,
                'error' => $e->getMessage()
            ]);
            
            throw $e;
        }
    }

    /**
     * ポイントを使用
     */
    public function usePoints(int $userId, int $points, string $description = ''): bool
    {
        try {
            // 現在のポイントをチェック
            $currentPoints = $this->getUserPoints($userId);
            
            if ($currentPoints < $points) {
                throw new \Exception('ポイントが不足しています');
            }

            DB::table('points')->insert([
                'user_id' => $userId,
                'point' => -$points, // 負の値でポイントを使用
                'created_at' => now(),
                'updated_at' => now()
            ]);

            return true;
        } catch (\Exception $e) {
            Log::error('Database error in usePoints', [
                'user_id' => $userId,
                'points' => $points,
                'description' => $description,
                'error' => $e->getMessage()
            ]);
            
            throw $e;
        }
    }

    /**
     * ポイントの詳細情報を取得
     */
    public function getPointDetails(int $pointId): ?object
    {
        try {
            return DB::table('points')
                ->where('id', $pointId)
                ->first();
        } catch (\Exception $e) {
            Log::error('Database error in getPointDetails', [
                'point_id' => $pointId,
                'error' => $e->getMessage()
            ]);
            
            throw $e;
        }
    }
} 