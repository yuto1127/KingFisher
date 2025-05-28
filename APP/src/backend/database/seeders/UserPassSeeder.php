<?php

namespace Database\Seeders;

use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;
use App\Models\UserPass;

class UserpassSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        $emails = ['kingfisher@example.com', 'general@example.com', 'customer@example.com'];
        $passwords = ['password', 'password', 'password'];

        foreach ($emails as $index => $email) {
            UserPass::create([
                'user_id' => $index + 1,
                'email' => $email,
                'password' => $passwords[$index],
            ]);
        }
    }
}
