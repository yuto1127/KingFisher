<?php

namespace Database\Seeders;

use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;
use App\Models\HelpDesk;
class HelpDesksSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        $roles = [1,2];
        $users = [1,2];
        foreach ($roles as $index => $role) {
            HelpDesk::create([
                'role_id' => $role,
                'user_id' => $users[$index],
            ]);
        }
        //
    }
}
