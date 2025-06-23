<?php

namespace App\Repositories;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\DB;

use App\Models\User;


class UsersRepository
{
    public function getAll()
    {
        $data = DB::table('users')->get();
        return $data;
    }

    public function getById(int $id)
    {
        return DB::table('users')->where('id', $id)->first();
    }

    public function create(array $data)
    {
        $id = DB::table('users')->insertGetId($data);
        return DB::table('users')->where('id', $id)->first();
    }

    public function update(int $id, array $data)
    {
        DB::table('users')->where('id', $id)->update($data);
        return DB::table('users')->where('id', $id)->first();
    }

    public function delete(int $id)
    {
        return DB::table('users')->where('id', $id)->delete();
    }
} 