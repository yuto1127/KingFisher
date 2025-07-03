<?php

namespace App\Repositories;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\DB;

use App\Models\Role;


class RolesRepository
{
    public function getAll()
    {

        // dd('test');
        $data = DB::table('roles')->get();
        return $data;
        // return 'test';
    }

    public function create(array $data)
    {
        return DB::table('roles')->insert($data);
    }

    public function update(int $id, array $data)
    {
        DB::table('roles')->where('id', $id)->update($data);
        return DB::table('roles')->where('id', $id)->first();
    }

    public function delete(int $id)
    {
        return DB::table('roles')->where('id', $id)->delete();
    }
} 