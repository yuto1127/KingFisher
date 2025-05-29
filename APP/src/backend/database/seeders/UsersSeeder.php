<?php

namespace Database\Seeders;

use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;
use App\Models\User;

class UsersSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        $names = ['Kingfisher', 'helpdesk', 'customer'];
        $genders = ['男性', '男性', '女性'];
        $barth_days = ['2025-05-22', '1990-01-01', '1995-03-15'];
        $phone_numbers = ['090-1234-5678', '080-9876-5432', '070-1111-2222'];

        foreach ($names as $index => $name) {
            User::create([
                'name' => $name,
                'gender' => $genders[$index],
                'barth_day' => $barth_days[$index],
                'phone_number' => $phone_numbers[$index],
            ]);
        }
        //
    }
}
