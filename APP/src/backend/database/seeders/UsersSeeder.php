<?php

namespace Database\Seeders;

use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;
use App\Models\Users;

class UsersSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {

        Users::create([
            'id' => 1,
            'name' => 'Kingfisher',
            'gender' => '男性',
            'barth_day' => '2025-05-22',
            'phone_number' => '090-1234-5678',
            'created_at' => now(),
            'updated_at' => now(),
        ]);
    }
}
