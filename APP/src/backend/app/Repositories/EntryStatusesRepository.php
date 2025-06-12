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
        return DB::table('entry_statuses')->create($data);
    }

    public function update(int $id, array $data)
    {
        $entryStatus = EntryStatus::findOrFail($id);
        $entryStatus->update($data);
        return $entryStatus;
    }

    public function delete(int $id)
    {
        $entryStatus = EntryStatus::findOrFail($id);
        return $entryStatus->delete();
    }
} 