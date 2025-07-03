<?php

namespace App\Services;

use App\Repositories\EntryStatusesRepository;
use Carbon\Carbon;

class EntryStatusesService
{
    protected $entryStatusesRepository;

    public function __construct(EntryStatusesRepository $entryStatusesRepository)
    {
        $this->entryStatusesRepository = $entryStatusesRepository;
    }

    public function getAllEntryStatuses()
    {
        return $this->entryStatusesRepository->getAll();
    }

    public function createEntryStatus(array $data)
    {
        $data['created_at'] = now();
        return $this->entryStatusesRepository->create($data);
    }

    public function updateEntryStatus(int $id, array $data)
    {
        $data['updated_at'] = now();
        return $this->entryStatusesRepository->update($id, $data);
    }

    public function deleteEntryStatus(int $id)
    {
        return $this->entryStatusesRepository->delete($id);
    }

    // 入退室状況を切り替える
    public function toggleEntryStatus(int $userId)
    {
        // 日本時間で現在時刻を取得
        $now = Carbon::now('Asia/Tokyo');
        
        // ユーザーの最新の入退室状況を取得
        $latestEntryStatus = $this->entryStatusesRepository->getLatestByUserId($userId);
        
        if ($latestEntryStatus) {
            // 既存のレコードがある場合
            $newStatus = ($latestEntryStatus->status === 'entry') ? 'exit' : 'entry';
            $updateData = [
                'status' => $newStatus,
                'updated_at' => $now,
            ];
            
            // 入室の場合はentry_atを、退室の場合はexit_atを更新
            if ($newStatus === 'entry') {
                $updateData['entry_at'] = $now;
            } else {
                $updateData['exit_at'] = $now;
            }
            
            $updatedEntryStatus = $this->entryStatusesRepository->update($latestEntryStatus->id, $updateData);
            
            return [
                'message' => $newStatus === 'entry' ? '入室を記録しました' : '退室を記録しました',
                'status' => $newStatus,
                'entry_status' => $updatedEntryStatus,
                'action' => 'updated'
            ];
        } else {
            // 新規レコードを作成
            $newData = [
                'user_id' => $userId,
                'status' => 'entry',
                'entry_at' => $now,
                'exit_at' => $now, // 初期値として同じ時刻を設定
                'created_at' => $now,
                'updated_at' => $now,
            ];
            
            $this->entryStatusesRepository->create($newData);
            
            return [
                'message' => '入室を記録しました',
                'status' => 'entry',
                'action' => 'created'
            ];
        }
    }

    // 特定ユーザーの入退室状況を取得
    public function getUserEntryStatus(int $userId)
    {
        return $this->entryStatusesRepository->getLatestByUserId($userId);
    }
} 