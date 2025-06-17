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

    public function createUser(array $data)
    {
        // emailとpasswordを分離
        $email = $data['email'] ?? null;
        $password = $data['password'] ?? null;
        
        // user_passesテーブル用のデータを除外
        unset($data['email'], $data['password']);

        // 1. ユーザー登録
        $user = $this->usersRepository->create($data);

        // 2. user_passes登録（emailとpasswordがある場合のみ）
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
        return $this->usersRepository->update($id, $data);
    }

    public function deleteUser(int $id)
    {
        return $this->usersRepository->delete($id);
    }
} 