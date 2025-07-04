<?php

namespace App\Services;

use App\Repositories\CustomersRepository;

class CustomersService
{
    protected $customersRepository;

    public function __construct(CustomersRepository $customersRepository)
    {
        $this->customersRepository = $customersRepository;
    }

    public function getAllCustomers()
    {
        return $this->customersRepository->getAll();
    }

    public function createCustomer(array $data)
    {
        $data['created_at'] = now();
        return $this->customersRepository->create($data);
    }

    public function updateCustomer(int $id, array $data)
    {
        $data['updated_at'] = now();
        return $this->customersRepository->update($id, $data);
    }

    public function deleteCustomer(int $id)
    {
        return $this->customersRepository->delete($id);
    }
} 