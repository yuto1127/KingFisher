<?php

namespace Database\Seeders;

use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;
use App\Models\UserPass;

class UserPassSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        UserPass::create([
            'user_id' => 1,
            'email' => 'kingfisher@example.com',
            'password' => 'password',
        ]);
    }
}
