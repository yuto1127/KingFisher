<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Services\UserPassesService;

class UserPassesController extends Controller
{
    //
    protected $userPassesService;

    public function __construct(UserPassesService $userPassesService)
    {
        $this->userPassesService = $userPassesService;
    }

    public function index()
    {
        return response()->json(
            $this->userPassesService->getAllUserPasses(),
            200,
            ['Content-Type' => 'application/json; charset=UTF-8'],
            JSON_UNESCAPED_UNICODE
        );
    }

    public function store(Request $request)
    {
        $this->userPassesService->createUserPass($request->all());
        return response()->json(
            ['message' => 'ユーザーパスを作成しました'],
            201,
            ['Content-Type' => 'application/json; charset=UTF-8'],
            JSON_UNESCAPED_UNICODE
        );
    }

    public function update(Request $request, $id)
    {
        $this->userPassesService->updateUserPass($id, $request->all());
        return response()->json(
            ['message' => 'ユーザーパスを更新しました'],
            200,
            ['Content-Type' => 'application/json; charset=UTF-8'],
            JSON_UNESCAPED_UNICODE
        );
    }

    public function destroy($id)
    {
        $this->userPassesService->deleteUserPass($id);
        return response()->json(
            ['message' => 'ユーザーパスを削除しました'],
            200,
            ['Content-Type' => 'application/json; charset=UTF-8'],
            JSON_UNESCAPED_UNICODE
        );
    }

    // パスワードの検証
    public function verifyPassword(Request $request, $id)
    {
        $request->validate([
            'password' => 'required|string',
        ]);

        $this->userPassesService->verifyPassword($id, $request->password);
        return response()->json(
            ['message' => 'パスワードが正しいです'],
            200,
            ['Content-Type' => 'application/json; charset=UTF-8'],
            JSON_UNESCAPED_UNICODE
        );
    }

    // パスワードの更新
    public function updatePassword(Request $request, $id)
    {
        $request->validate([
            'password' => 'required|string|min:8',
        ]);

        $this->userPassesService->updatePassword($id, $request->password);
        return response()->json(
            ['message' => 'パスワードを更新しました'],
            200,
            ['Content-Type' => 'application/json; charset=UTF-8'],
            JSON_UNESCAPED_UNICODE
        );
    }

    // パスワードによる検索
    public function findByPassword(Request $request)
    {
        $request->validate([
            'password' => 'required|string',
        ]);

        $userPass = $this->userPassesService->findByPassword($request->password);
        return response()->json(
            $userPass,
            200,
            ['Content-Type' => 'application/json; charset=UTF-8'],
            JSON_UNESCAPED_UNICODE
        );
    }
}
