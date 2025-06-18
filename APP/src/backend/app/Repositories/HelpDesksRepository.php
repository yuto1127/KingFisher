<?php

namespace App\Repositories;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\DB;

use App\Models\HelpDesk;


class HelpDesksRepository
{
    public function getAll()
    {
        $data = DB::table('help_desks')->get();
        return $data;
    }

    public function create(array $data)
    {
        return DB::table('help_desks')->insert($data);
    }

    public function update(int $id, array $data)
    {
        DB::table('help_desks')->where('id', $id)->update($data);
        return DB::table('help_desks')->where('id', $id)->first();
    }

    public function delete(int $id)
    {
        return DB::table('help_desks')->where('id', $id)->delete();
    }
} 