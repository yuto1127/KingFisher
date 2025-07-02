<?php

namespace Database\Seeders;

use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class PointsSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        //
        $user_ids = [1,2,3];
        foreach ($user_ids as $user_id) {
            Point::create([
                'user_id' => $user_id,
                'point' => 0,
            ]);
        }

    }
}
