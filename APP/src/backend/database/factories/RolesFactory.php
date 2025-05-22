<?php

namespace Database\Factories;

use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends \Illuminate\Database\Eloquent\Factories\Factory<\App\Models\Model>
 */
class RolesFactory extends Factory
{
    /**
     * Define the model's default state.
     *
     * @return array<string, mixed>
     */
    public function definition(): array
    {
        static $id = 1; // 連番の初期値を設定

        $names = ['管理者', '一般', '顧客']; // nameの候補

        return [
            'id' => $id++, // 連番でidを設定
        ];
    }
}
