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
        $users = [
            [
                'name' => 'Kingfisher',
                'gender' => '男性',
                'barth_day' => '2025-05-22',
                'phone_number' => '090-1234-5678',
                'postal_code' => '100-0001',
                'prefecture' => '東京都',
                'city' => '千代田区',
                'address_line1' => '千代田1-1-1',
                'address_line2' => 'サンプルビル101',
                'is_active' => true
            ],
            [
                'name' => 'helpdesk',
                'gender' => '男性',
                'barth_day' => '1990-01-01',
                'phone_number' => '080-9876-5432',
                'postal_code' => '530-0001',
                'prefecture' => '大阪府',
                'city' => '大阪市北区',
                'address_line1' => '梅田2-2-2',
                'address_line2' => 'ヘルプデスクビル202',
                'is_active' => true
            ],
            [
                'name' => 'customer',
                'gender' => '女性',
                'barth_day' => '1995-03-15',
                'phone_number' => '070-1111-2222',
                'postal_code' => '460-0008',
                'prefecture' => '愛知県',
                'city' => '名古屋市中区',
                'address_line1' => '栄3-3-3',
                'address_line2' => 'カスタマーハイツ303',
                'is_active' => true
            ],
            [
                'name' => 'Guest',
                'gender' => '男性',
                'barth_day' => '2025-05-22',
                'phone_number' => '090-1234-5678',
                'postal_code' => '370-0001',
                'prefecture' => '群馬県',
                'city' => '前橋市',
                'address_line1' => '前橋1-1-1',
                'address_line2' => 'ゲストハイツ101',
                'is_active' => true
            ]
        ];

        foreach ($users as $user) {
            User::create($user);
        }
    }
}
