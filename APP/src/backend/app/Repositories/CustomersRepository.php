<?php

namespace App\Repositories;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\DB;

use App\Models\Customer;


class CustomersRepository
{
    public function getAll()
    {
        $data = DB::table('customers')->get();
        return $data;
    }

    public function create(array $data)
    {
        return DB::table('customers')->insert($data);
    }

    public function update(int $id, array $data)
    {
        DB::table('customers')->where('id', $id)->update($data);
        return DB::table('customers')->where('id', $id)->first();
    }

    public function delete(int $id)
    {
        return DB::table('customers')->where('id', $id)->delete();
    }
} 