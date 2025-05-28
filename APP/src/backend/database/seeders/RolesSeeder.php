<?php

namespace Database\Seeders;

use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;
use App\Models\Roles;

class RolesSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        $names = ['管理者', '一般', '顧客'];

        foreach ($names as $index => $name) {
            Roles::create([
                'id' => $index + 1, // 1から始まる連番
                'name' => $name,
            ]);
        }
    }
}
