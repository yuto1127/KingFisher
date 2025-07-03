<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Services\PointsService;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Log;

class PointsController extends Controller
{
    private $pointsService;

    public function __construct(PointsService $pointsService)
    {
        $this->pointsService = $pointsService;
    }

    /**
     * ユーザーのポイントを取得
     */
    public function getUserPoints(Request $request)
    {
        try {
            $user = $request->user();
            
            if (!$user) {
                return response()->json(
                    ['error' => '認証が必要です'],
                    401,
                    ['Content-Type' => 'application/json; charset=UTF-8'],
                    JSON_UNESCAPED_UNICODE
                );
            }

            $points = $this->pointsService->getUserPoints($user->id);

            Log::info('User points retrieved', [
                'user_id' => $user->id,
                'points' => $points
            ]);

            return response()->json(
                [
                    'points' => $points,
                    'message' => 'ポイントを取得しました'
                ],
                200,
                ['Content-Type' => 'application/json; charset=UTF-8'],
                JSON_UNESCAPED_UNICODE
            );
        } catch (\Exception $e) {
            Log::error('Get user points error', [
                'user_id' => $user->id ?? 'unknown',
                'error' => $e->getMessage(),
                'trace' => $e->getTraceAsString()
            ]);

            return response()->json(
                ['error' => 'ポイントの取得に失敗しました: ' . $e->getMessage()],
                500,
                ['Content-Type' => 'application/json; charset=UTF-8'],
                JSON_UNESCAPED_UNICODE
            );
        }
    }

    /**
     * ポイント履歴を取得
     */
    public function getPointHistory(Request $request)
    {
        try {
            $user = $request->user();
            
            if (!$user) {
                return response()->json(
                    ['error' => '認証が必要です'],
                    401,
                    ['Content-Type' => 'application/json; charset=UTF-8'],
                    JSON_UNESCAPED_UNICODE
                );
            }

            $limit = $request->input('limit', 10);
            $history = $this->pointsService->getPointHistory($user->id, $limit);

            Log::info('User point history retrieved', [
                'user_id' => $user->id,
                'limit' => $limit,
                'count' => count($history)
            ]);

            return response()->json(
                [
                    'history' => $history,
                    'message' => 'ポイント履歴を取得しました'
                ],
                200,
                ['Content-Type' => 'application/json; charset=UTF-8'],
                JSON_UNESCAPED_UNICODE
            );
        } catch (\Exception $e) {
            Log::error('Get point history error', [
                'user_id' => $user->id ?? 'unknown',
                'error' => $e->getMessage(),
                'trace' => $e->getTraceAsString()
            ]);

            return response()->json(
                ['error' => 'ポイント履歴の取得に失敗しました: ' . $e->getMessage()],
                500,
                ['Content-Type' => 'application/json; charset=UTF-8'],
                JSON_UNESCAPED_UNICODE
            );
        }
    }
} 