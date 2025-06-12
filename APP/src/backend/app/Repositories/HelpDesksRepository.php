<?php

namespace App\Repositories;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\DB;

use App\Models\HelpDesk;


class HelpDesksRepository
{
    public function getAll()
    {

        // dd('test');
        $data = DB::table('help_desks')->get();
        return $data;
        // return 'test';
    }

    public function create(array $data)
    {
        return DB::table('help_desks')->create($data);
    }

    public function update(int $id, array $data)
    {
        $helpDesk = HelpDesk::findOrFail($id);
        $helpDesk->update($data);
        return $helpDesk;
    }

    public function delete(int $id)
    {
        $helpDesk = HelpDesk::findOrFail($id);
        return $helpDesk->delete();
    }
} 