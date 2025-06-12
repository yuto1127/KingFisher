<?php

namespace App\Repositories;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\DB;

use App\Models\Event;


class EventsRepository
{
    public function getAll()
    {

        // dd('test');
        $data = DB::table('events')->get();
        return $data;
        // return 'test';
    }

    public function create(array $data)
    {
        return DB::table('events')->create($data);
    }

    public function update(int $id, array $data)
    {
        $event = Event::findOrFail($id);
        $event->update($data);
        return $event;
    }

    public function delete(int $id)
    {
        $event = Event::findOrFail($id);
        return $event->delete();
    }
} 