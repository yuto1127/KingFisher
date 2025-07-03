<?php

namespace App\Services;

use App\Repositories\RolesRepository;

class RolesService
{
    protected $rolesRepository;

    public function __construct(RolesRepository $rolesRepository)
    {
        $this->rolesRepository = $rolesRepository;
    }

    public function getAllRoles()
    {
        return $this->rolesRepository->getAll();
    }

    public function createRole(array $data)
    {
        $data['created_at'] = now();
        return $this->rolesRepository->create($data);
    }

    public function updateRole(int $id, array $data)
    {
        $data['updated_at'] = now();
        return $this->rolesRepository->update($id, $data);
    }

    public function deleteRole(int $id)
    {
        return $this->rolesRepository->delete($id);
    }
} 