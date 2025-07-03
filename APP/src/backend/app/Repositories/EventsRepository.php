<?php

namespace App\Repositories;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\DB;

use App\Models\Event;


class EventsRepository
{
    public function getAll()
    {
        $data = DB::table('events')->get();
        return $data;
    }

    public function create(array $data)
    {
        return DB::table('events')->insert($data);
    }

    public function update(int $id, array $data)
    {
        DB::table('events')->where('id', $id)->update($data);
        return DB::table('events')->where('id', $id)->first();
    }

    public function delete(int $id)
    {
        return DB::table('events')->where('id', $id)->delete();
    }
} 