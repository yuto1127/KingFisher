<?php

namespace App\Repositories;

use App\Models\LostItem;
use Illuminate\Database\Eloquent\Collection;

class LostItemsRepository
{
    /**
     * 全ての落とし物を取得
     */
    public function getAll(): Collection
    {
        return LostItem::orderBy('created_at', 'desc')->get();
    }

    /**
     * 最近の落とし物を取得
     */
    public function getRecent(int $limit = 5): Collection
    {
        return LostItem::orderBy('created_at', 'desc')
            ->limit($limit)
            ->get();
    }

    /**
     * IDで落とし物を取得
     */
    public function findById(int $id): ?LostItem
    {
        return LostItem::find($id);
    }

    /**
     * タイトルで検索
     */
    public function searchByTitle(string $query): Collection
    {
        return LostItem::where('title', 'like', "%{$query}%")
            ->orderBy('created_at', 'desc')
            ->get();
    }

    /**
     * 新しい落とし物を作成
     */
    public function create(array $data): LostItem
    {
        return LostItem::create($data);
    }

    /**
     * 落とし物を更新
     */
    public function update(int $id, array $data): bool
    {
        $item = $this->findById($id);
        if (!$item) {
            return false;
        }
        return $item->update($data);
    }

    /**
     * 落とし物を削除
     */
    public function delete(int $id): bool
    {
        $item = $this->findById($id);
        if (!$item) {
            return false;
        }
        return $item->delete();
    }

    /**
     * ステータスを更新
     */
    public function updateStatus(int $id, string $status): bool
    {
        return $this->update($id, ['status' => $status]);
    }
} 