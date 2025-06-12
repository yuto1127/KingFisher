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
        return Role::create($data);
    }

    public function update(int $id, array $data)
    {
        $role = Role::findOrFail($id);
        $role->update($data);
        return $role;
    }

    public function delete(int $id)
    {
        $role = Role::findOrFail($id);
        return $role->delete();
    }
} 