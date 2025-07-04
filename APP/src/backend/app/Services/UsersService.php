<?php

namespace App\Services;

use App\Repositories\UsersRepository;
use App\Models\User;
use App\Models\UserPass;
use Illuminate\Support\Facades\Hash;
use App\Http\Controllers\Api\HelpDesksController;
use App\Http\Controllers\Api\CustomersController;
use App\Services\UserPassesService;

class UsersService
{
    protected $usersRepository;
    protected $userPassesService;

    public function __construct(UsersRepository $usersRepository, UserPassesService $userPassesService)
    {
        $this->usersRepository = $usersRepository;
        $this->userPassesService = $userPassesService;
    }

    public function getAllUsers()
    {
        return $this->usersRepository->getAll();
    }

    public function getUserById(int $id)
    {
        return $this->usersRepository->getById($id);
    }

    public function createUser(array $data)
    {
        $data['created_at'] = now();
        // 郵便番号が7桁数字のみの場合はハイフンを追加
        if (isset($data['postal_code']) && preg_match('/^\d{7}$/', $data['postal_code'])) {
            $data['postal_code'] = substr($data['postal_code'], 0, 3) . '-' . substr($data['postal_code'], 3, 4);
        }
        // emailとpasswordを分離
        $email = $data['email'] ?? null;
        $password = $data['password'] ?? null;
        
        // user_passesテーブル用のデータを除外
        unset($data['email'], $data['password']);

        // 1. ユーザー登録
        $user = $this->usersRepository->create($data);
        
        // デバッグ用ログ

        // // 2. user_passes登録（emailとpasswordがある場合のみ）
        if ($email && $password) {
            $this->userPassesService->createUserPass([
                'user_id' => $user->id,
                'email' => $email,
                'password' => $password,
            ]);
        }

        // // 3. メールアドレスで分岐し、helpdeskまたはcustomerに登録
        // if (isset($data['email']) && str_ends_with($data['email'], '@chuo.ac.jp')) {
        //     // HelpDeskControllerのstoreFromServiceを呼び出し
        //     app(HelpDesksController::class)->storeFromService([
        //         'user_id' => $user->id,
        //         'role_id' => 2,
        //     ]);
        // } else {
        //     // CustomersControllerのstoreFromServiceを呼び出し
        //     app(CustomersController::class)->storeFromService([
        //         'user_id' => $user->id,
        //         'role_id' => 3,
        //     ]);
        // }
        return $user;
    }

    public function updateUser(int $id, array $data)
    {
        $data['updated_at'] = now();
        return $this->usersRepository->update($id, $data);
    }

    public function deleteUser(int $id)
    {
        return $this->usersRepository->delete($id);
    }
} 