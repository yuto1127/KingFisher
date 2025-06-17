<?php

namespace App\Services;

use App\Repositories\UsersRepository;
use App\Models\User;
use App\Models\UserPass;
use Illuminate\Support\Facades\Hash;
use App\Http\Controllers\Api\HelpDesksController;
use App\Http\Controllers\Api\CustomersController;
use App\Http\Controllers\Api\UserPassesController;

class UsersService
{
    protected $usersRepository;

    public function __construct(UsersRepository $usersRepository)
    {
        $this->usersRepository = $usersRepository;
    }

    public function getAllUsers()
    {
        return $this->usersRepository->getAll();
    }

    public function createUser(array $data)
    {
        // 1. ユーザー登録
        $user = $this->usersRepository->create($data);

        // 2. user_passes登録
        app(UserPassesController::class)
            ->store(new \Illuminate\Http\Request([
                'user_id' => $user->id,
                'email' => $data['email'],
                'password' => $data['password'], // store側でハッシュ化される前提
            ]));

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