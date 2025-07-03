<?php

namespace App\Services;

use App\Repositories\PointsRepository;
use Illuminate\Support\Facades\Log;

class PointsService
{
    private $pointsRepository;

    public function __construct(PointsRepository $pointsRepository)
    {
        $this->pointsRepository = $pointsRepository;
    }

    /**
     * ユーザーのポイントを取得
     */
    public function getUserPoints(int $userId): int
    {
        try {
            $points = $this->pointsRepository->getUserPoints($userId);
            
            Log::info('User points retrieved successfully', [
                'user_id' => $userId,
                'points' => $points
            ]);

            return $points;
        } catch (\Exception $e) {
            Log::error('Failed to get user points', [
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
            $history = $this->pointsRepository->getPointHistory($userId, $limit);
            
            Log::info('User point history retrieved successfully', [
                'user_id' => $userId,
                'limit' => $limit,
                'count' => count($history)
            ]);

            return $history;
        } catch (\Exception $e) {
            Log::error('Failed to get point history', [
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
            $result = $this->pointsRepository->addPoints($userId, $points, $description);
            
            Log::info('Points added successfully', [
                'user_id' => $userId,
                'points' => $points,
                'description' => $description
            ]);

            return $result;
        } catch (\Exception $e) {
            Log::error('Failed to add points', [
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
            $result = $this->pointsRepository->usePoints($userId, $points, $description);
            
            Log::info('Points used successfully', [
                'user_id' => $userId,
                'points' => $points,
                'description' => $description
            ]);

            return $result;
        } catch (\Exception $e) {
            Log::error('Failed to use points', [
                'user_id' => $userId,
                'points' => $points,
                'description' => $description,
                'error' => $e->getMessage()
            ]);
            
            throw $e;
        }
    }
} 