<?php

namespace App\Services;

use App\Repositories\UserPassesRepository;

class UserPassesService
{
    protected $userPassesRepository;

    public function __construct(UserPassesRepository $userPassesRepository)
    {
        $this->userPassesRepository = $userPassesRepository;
    }

    public function getAllUserPasses()
    {
        return $this->userPassesRepository->getAll();
    }

    public function createUserPass(array $data)
    {
        return $this->userPassesRepository->create($data);
    }

    public function updateUserPass(int $id, array $data)
    {
        return $this->userPassesRepository->update($id, $data);
    }

    public function deleteUserPass(int $id)
    {
        return $this->userPassesRepository->delete($id);
    }
} 