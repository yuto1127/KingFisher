<?php

namespace App\Repositories;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\DB;

use App\Models\UserPass;


class UserPassesRepository
{
    public function getAll()
    {

        // dd('test');
        $data = DB::table('user_passes')->get();
        return $data;
        // return 'test';
    }

    public function create(array $data)
    {
        return DB::table('user_passes')->create($data);
    }

    public function update(int $id, array $data)
    {
        $userPass = UserPass::findOrFail($id);
        $userPass->update($data);
        return $userPass;
    }

    public function delete(int $id)
    {
        $userPass = UserPass::findOrFail($id);
        return $userPass->delete();
    }
} 