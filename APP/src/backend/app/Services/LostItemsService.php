<?php

namespace App\Services;

use App\Repositories\LostItemsRepository;
use Illuminate\Database\Eloquent\Collection;

class LostItemsService
{
    public function __construct(
        private LostItemsRepository $repository
    ) {}

    /**
     * 全ての落とし物を取得
     */
    public function getAll(): Collection
    {
        return $this->repository->getAll();
    }

    /**
     * 最近の落とし物を取得
     */
    public function getRecent(int $limit = 5): Collection
    {
        return $this->repository->getRecent($limit);
    }

    /**
     * IDで落とし物を取得
     */
    public function findById(int $id)
    {
        return $this->repository->findById($id);
    }

    /**
     * タイトルで検索
     */
    public function searchByTitle(string $query): Collection
    {
        return $this->repository->searchByTitle($query);
    }

    /**
     * 新しい落とし物を作成
     */
    public function create(array $data)
    {
        // アイコン名を自動設定
        $data['icon'] = $this->getIconFromTitle($data['title'] ?? '');
        
        return $this->repository->create($data);
    }

    /**
     * 落とし物を更新
     */
    public function update(int $id, array $data): bool
    {
        // アイコン名を自動設定
        if (isset($data['title'])) {
            $data['icon'] = $this->getIconFromTitle($data['title']);
        }
        
        return $this->repository->update($id, $data);
    }

    /**
     * 落とし物を削除
     */
    public function delete(int $id): bool
    {
        return $this->repository->delete($id);
    }

    /**
     * ステータスを更新
     */
    public function updateStatus(int $id, string $status): bool
    {
        return $this->repository->updateStatus($id, $status);
    }

    /**
     * タイトルからアイコン名を取得
     */
    private function getIconFromTitle(string $title): string
    {
        $title = strtolower($title);
        
        if (str_contains($title, '財布') || str_contains($title, 'wallet')) {
            return 'account_balance_wallet';
        } elseif (str_contains($title, '傘') || str_contains($title, 'umbrella')) {
            return 'umbrella';
        } elseif (str_contains($title, 'スマートフォン') || str_contains($title, 'phone')) {
            return 'phone_android';
        } elseif (str_contains($title, '鍵') || str_contains($title, 'key')) {
            return 'key';
        } elseif (str_contains($title, '眼鏡') || str_contains($title, 'glasses')) {
            return 'remove_red_eye';
        } elseif (str_contains($title, 'バッグ') || str_contains($title, 'bag')) {
            return 'work';
        } else {
            return 'inventory';
        }
    }
} 