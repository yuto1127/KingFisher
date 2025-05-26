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
        $names = ['Kingfisher', 'general', 'customer'];
        $genders = ['男性', '女性', '男性'];
        $barth_days = ['2025-05-22', '1990-01-01', '1995-03-15'];
        $phone_numbers = ['090-1234-5678', '080-9876-5432', '070-1111-2222'];

        foreach ($names as $index => $name) {
            Users::create([
                'name' => $name,
                'gender' => $genders[$index],
                'barth_day' => $barth_days[$index],
                'phone_numbers' => $phone_numbers[$index],
            ]);
        }
    }
}
