<?php

namespace Database\Seeders;

use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;
use App\Models\Customer;

class CustomersSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        $customers = [
            [
                'role_id' => 3,
                'user_id' => 3,
            ]
        ];

        foreach ($customers as $customer) {
            Customer::create($customer);
        }
    }
}
