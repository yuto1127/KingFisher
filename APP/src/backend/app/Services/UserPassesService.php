<?php

namespace App\Services;

use App\Repositories\UserPassesRepository;
use Illuminate\Validation\ValidationException;
use Illuminate\Support\Facades\Hash;

class UserPassesService
{
    protected $userPassesRepository;

    public function __construct(UserPassesRepository $userPassesRepository)
    {
        $this->userPassesRepository = $userPassesRepository;
    }

    public function getAllUserPasses()
    {
        return $this->userPassesRepository->getAll();
    }

    public function createUserPass(array $data)
    {
        $data['created_at'] = now();
        if (!isset($data['password'])) {
            throw ValidationException::withMessages([
                'password' => ['パスワードは必須です。'],
            ]);
        }
        if (!isset($data['user_id']) || $data['user_id'] === null) {
            throw ValidationException::withMessages([
                'user_id' => ['ユーザーIDは必須です。'],
            ]);
        }
        $data['password'] = Hash::make($data['password']);
        return $this->userPassesRepository->create($data);
    }

    public function updateUserPass(int $id, array $data)
    {
        $data['updated_at'] = now();
        return $this->userPassesRepository->update($id, $data);
    }

    public function deleteUserPass(int $id)
    {
        return $this->userPassesRepository->delete($id);
    }

    // パスワードの検証
    public function verifyPassword(int $id, string $password)
    {
        if (!$this->userPassesRepository->verifyPassword($id, $password)) {
            throw ValidationException::withMessages([
                'password' => ['パスワードが正しくありません。'],
            ]);
        }
        return true;
    }

    // パスワードの更新
    public function updatePassword(int $id, string $newPassword)
    {
        return $this->userPassesRepository->updatePassword($id, $newPassword);
    }

    // パスワードによる検索
    public function findByPassword(string $password)
    {
        $userPass = $this->userPassesRepository->findByPassword($password);
        if (!$userPass) {
            throw ValidationException::withMessages([
                'password' => ['パスワードに一致するユーザーパスが見つかりません。'],
            ]);
        }
        return $userPass;
    }
} 