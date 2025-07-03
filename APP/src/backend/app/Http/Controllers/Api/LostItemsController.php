<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Services\LostItemsService;
use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;

class LostItemsController extends Controller
{
    public function __construct(
        private LostItemsService $service
    ) {}

    /**
     * 全ての落とし物を取得
     */
    public function index(): JsonResponse
    {
        try {
            $items = $this->service->getAll();
            return response()->json($items);
        } catch (\Exception $e) {
            return response()->json(['error' => $e->getMessage()], 500);
        }
    }

    /**
     * 最近の落とし物を取得
     */
    public function recent(Request $request): JsonResponse
    {
        try {
            $limit = $request->get('limit', 5);
            $items = $this->service->getRecent($limit);
            return response()->json($items);
        } catch (\Exception $e) {
            return response()->json(['error' => $e->getMessage()], 500);
        }
    }

    /**
     * 特定の落とし物を取得
     */
    public function show(int $id): JsonResponse
    {
        try {
            $item = $this->service->findById($id);
            if (!$item) {
                return response()->json(['error' => '落とし物が見つかりません'], 404);
            }
            return response()->json($item);
        } catch (\Exception $e) {
            return response()->json(['error' => $e->getMessage()], 500);
        }
    }

    /**
     * 新しい落とし物を作成
     */
    public function store(Request $request): JsonResponse
    {
        try {
            $validated = $request->validate([
                'title' => 'required|string|max:255',
                'description' => 'required|string',
                'location' => 'required|string|max:255',
                'status' => 'string|in:保管中,返却済み,廃棄',
            ]);

            $item = $this->service->create($validated);
            return response()->json($item, 201);
        } catch (\Illuminate\Validation\ValidationException $e) {
            return response()->json(['error' => $e->errors()], 422);
        } catch (\Exception $e) {
            return response()->json(['error' => $e->getMessage()], 500);
        }
    }

    /**
     * 落とし物を更新
     */
    public function update(Request $request, int $id): JsonResponse
    {
        try {
            $validated = $request->validate([
                'title' => 'string|max:255',
                'description' => 'string',
                'location' => 'string|max:255',
                'status' => 'string|in:保管中,返却済み,廃棄',
            ]);

            $success = $this->service->update($id, $validated);
            if (!$success) {
                return response()->json(['error' => '落とし物が見つかりません'], 404);
            }

            $item = $this->service->findById($id);
            return response()->json($item);
        } catch (\Illuminate\Validation\ValidationException $e) {
            return response()->json(['error' => $e->errors()], 422);
        } catch (\Exception $e) {
            return response()->json(['error' => $e->getMessage()], 500);
        }
    }

    /**
     * 落とし物を削除
     */
    public function destroy(int $id): JsonResponse
    {
        try {
            $success = $this->service->delete($id);
            if (!$success) {
                return response()->json(['error' => '落とし物が見つかりません'], 404);
            }
            return response()->json(['message' => '落とし物を削除しました']);
        } catch (\Exception $e) {
            return response()->json(['error' => $e->getMessage()], 500);
        }
    }

    /**
     * タイトルで検索
     */
    public function search(Request $request): JsonResponse
    {
        try {
            $query = $request->get('q', '');
            if (empty($query)) {
                return response()->json([]);
            }

            $items = $this->service->searchByTitle($query);
            return response()->json($items);
        } catch (\Exception $e) {
            return response()->json(['error' => $e->getMessage()], 500);
        }
    }

    /**
     * ステータスを更新
     */
    public function updateStatus(Request $request, int $id): JsonResponse
    {
        try {
            $validated = $request->validate([
                'status' => 'required|string|in:保管中,返却済み,廃棄',
            ]);

            $success = $this->service->updateStatus($id, $validated['status']);
            if (!$success) {
                return response()->json(['error' => '落とし物が見つかりません'], 404);
            }

            $item = $this->service->findById($id);
            return response()->json($item);
        } catch (\Illuminate\Validation\ValidationException $e) {
            return response()->json(['error' => $e->errors()], 422);
        } catch (\Exception $e) {
            return response()->json(['error' => $e->getMessage()], 500);
        }
    }
} 