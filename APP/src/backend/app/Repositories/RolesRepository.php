<?php

namespace App\Repositories;

use App\Models\Role;

class RolesRepository
{
    public function getAll()
    {
        return Role::all();
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