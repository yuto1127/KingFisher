<?php

namespace Database\Seeders;

use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;
use App\Models\EntryStatus;

class EntryStatusesSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        //
        $users = [1,2,3,4];
        foreach ($users as $user) {
            EntryStatus::create([
                'user_id' => $user,
                'status' => 'exit',
                'entry_at' => '2025-01-01 00:00:00',
                'exit_at' => '2025-01-01 00:00:00',
            ]);
        }
    }
}
