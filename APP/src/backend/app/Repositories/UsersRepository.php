<?php

namespace App\Repositories;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\DB;

use App\Models\User;


class UsersRepository
{
    public function getAll()
    {

        // dd('test');
        $data = DB::table('users')->get();
        return $data;
        // return 'test';
    }

    public function create(array $data)
    {
        return DB::table('users')->create($data);
    }

    public function update(int $id, array $data)
    {
        $user = User::findOrFail($id);
        $user->update($data);
        return $user;
    }

    public function delete(int $id)
    {
        $user = User::findOrFail($id);
        return $user->delete();
    }
} 