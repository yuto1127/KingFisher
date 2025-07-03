<?php

namespace Database\Seeders;

use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;
use App\Models\UserPass;
use Illuminate\Support\Facades\Hash;

class UserPassesSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        $emails = ['kingfisher@gmail.com', 'helpdesk@gmail.com', 'customer@gmail.com'];
        $passwords = ['password', 'password', 'password'];
        foreach ($emails as $index => $email) {
            UserPass::create([
                'user_id' => $index + 1,
                'email' => $email,
                'password' => Hash::make($passwords[$index]),
            ]);
        }
        //
    }
}
