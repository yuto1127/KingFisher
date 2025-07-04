<?php

namespace App\Repositories;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\DB;

use App\Models\EntryStatus;


class EntryStatusesRepository
{
    public function getAll()
    {

        // dd('test');
        $data = DB::table('entry_statuses')->get();
        return $data;
        // return 'test';
    }

    public function create(array $data)
    {
        return DB::table('entry_statuses')->insert($data);
    }

    public function update(int $id, array $data)
    {
        DB::table('entry_statuses')->where('id', $id)->update($data);
        return DB::table('entry_statuses')->where('id', $id)->first();
    }

    public function delete(int $id)
    {
        return DB::table('entry_statuses')->where('id', $id)->delete();
    }

    // ユーザーIDで最新の入退室状況を取得
    public function getLatestByUserId(int $userId)
    {
        return DB::table('entry_statuses')
            ->where('user_id', $userId)
            ->orderBy('created_at', 'desc')
            ->first();
    }
} 