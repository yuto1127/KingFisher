<?php

namespace App\Repositories;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;
use App\Models\UserPass;

class UserPassesRepository
{
    public function getAll()
    {
        $data = DB::table('user_passes')->get();
        return $data;
    }

    public function create(array $data)
    {
        // パスワードが存在する場合は暗号化
        if (isset($data['password'])) {
            $data['password'] = Hash::make($data['password']);
        }
        return DB::table('user_passes')->insert($data);
    }

    public function update(int $id, array $data)
    {
        // パスワードが存在する場合は暗号化
        if (isset($data['password'])) {
            $data['password'] = Hash::make($data['password']);
        }
        DB::table('user_passes')->where('id', $id)->update($data);
        return DB::table('user_passes')->where('id', $id)->first();
    }

    public function delete(int $id)
    {
        return DB::table('user_passes')->where('id', $id)->delete();
    }

    // パスワードの検証
    public function verifyPassword(int $id, string $password)
    {
        $userPass = DB::table('user_passes')->where('id', $id)->first();
        if (!$userPass) {
            return false;
        }
        return Hash::check($password, $userPass->password);
    }

    // パスワードの更新
    public function updatePassword(int $id, string $newPassword)
    {
        return DB::table('user_passes')
            ->where('id', $id)
            ->update(['password' => Hash::make($newPassword)]);
    }

    // パスワードによる検索
    public function findByPassword(string $password)
    {
        $userPasses = DB::table('user_passes')->get();
        foreach ($userPasses as $userPass) {
            if (Hash::check($password, $userPass->password)) {
                return $userPass;
            }
        }
        return null;
    }
} 