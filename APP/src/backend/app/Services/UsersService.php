<?php

namespace App\Services;

use App\Repositories\UsersRepository;

class UsersService
{
    protected $usersRepository;

    public function __construct(UsersRepository $usersRepository)
    {
        $this->usersRepository = $usersRepository;
    }

    public function getAllUsers()
    {
        return $this->usersRepository->getAll();
    }

    public function createUser(array $data)
    {
        return $this->usersRepository->create($data);
    }

    public function updateUser(int $id, array $data)
    {
        return $this->usersRepository->update($id, $data);
    }

    public function deleteUser(int $id)
    {
        return $this->usersRepository->delete($id);
    }
} 