<?php

namespace Database\Seeders;

use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;
use App\Models\Role;

class RolesSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        $names = ['admin', 'helpdesk', 'customer'];
        foreach ($names as $name) {
            Role::updateOrCreate(
                ['name' => $name],
                ['name' => $name]
            );
        }
    }
}
