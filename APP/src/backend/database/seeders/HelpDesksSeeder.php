<?php

namespace Database\Seeders;

use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;
use App\Models\HelpDesks;

class HelpDesksSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        //
        $roles = [2,3];
        $users = [2,3];

        foreach ($roles as $index => $role) {
            HelpDesks::create([
                'role_id' => $role,
                'user_id' => $users[$index],
            ]);
        }
    }
}
