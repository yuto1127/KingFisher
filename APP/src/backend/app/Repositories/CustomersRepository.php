<?php

namespace App\Repositories;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\DB;

use App\Models\Customer;


class CustomersRepository
{
    public function getAll()
    {

        // dd('test');
        $data = DB::table('customers')->get();
        return $data;
        // return 'test';
    }

    public function create(array $data)
    {
        return DB::table('customers')->create($data);
    }

    public function update(int $id, array $data)
    {
        $customer = Customer::findOrFail($id);
        $customer->update($data);
        return $customer;
    }

    public function delete(int $id)
    {
        $customer = Customer::findOrFail($id);
        return $customer->delete();
    }
} 