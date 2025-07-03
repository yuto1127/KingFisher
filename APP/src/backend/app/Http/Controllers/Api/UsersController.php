<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Services\UsersService;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\Log;

class UsersController extends Controller
{
    //
    protected $usersService;

    public function __construct(UsersService $usersService)
    {
        $this->usersService = $usersService;
    }

    public function index()
    {
        return response()->json(
            $this->usersService->getAllUsers(),
            200,
            ['Content-Type' => 'application/json; charset=UTF-8'],
            JSON_UNESCAPED_UNICODE
        );
    }

    public function show($id)
    {
        $user = $this->usersService->getUserById($id);
        if (!$user) {
            return response()->json(['message' => 'User not found'], 404);
        }
        return response()->json(
            $user,
            200,
            ['Content-Type' => 'application/json; charset=UTF-8'],
            JSON_UNESCAPED_UNICODE
        );
    }

    public function store(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'name' => 'required|string|max:100',
            'gender' => 'required|string|max:10',
            'barth_day' => 'required|date',
            'phone_number' => 'required|string|max:20',
            // 'role_id' => 'required|exists:roles,id',
            'postal_code' => 'nullable|string|max:8|regex:/^\d{3}-\d{4}$/',
            'prefecture' => 'nullable|string|max:10',
            'city' => 'nullable|string|max:50',
            'address_line1' => 'nullable|string|max:100',
            'address_line2' => 'nullable|string|max:100',
            'is_active' => 'boolean'
        ]);

        if ($validator->fails()) {
            return response()->json(
                ['errors' => $validator->errors()],
                422,
                ['Content-Type' => 'application/json; charset=UTF-8'],
                JSON_UNESCAPED_UNICODE
            );
        }

        $user = $this->usersService->createUser($request->all());
        return response()->json(
            ['id' => $user->id,
            'message' => 'ユーザーを作成しました'],
            201,
            ['Content-Type' => 'application/json; charset=UTF-8'],
            JSON_UNESCAPED_UNICODE
        );
    }

    public function update(Request $request, $id)
    {
        $validator = Validator::make($request->all(), [
            'name' => 'sometimes|required|string|max:100',
            'gender' => 'sometimes|required|string|max:10',
            'barth_day' => 'sometimes|required|date',
            'phone_number' => 'sometimes|required|string|max:20',
            // 'role_id' => 'sometimes|required|exists:roles,id',
            'postal_code' => 'nullable|string|max:8',
            'prefecture' => 'nullable|string|max:10',
            'city' => 'nullable|string|max:50',
            'address_line1' => 'nullable|string|max:100',
            'address_line2' => 'nullable|string|max:100',
            'is_active' => 'boolean'
        ]);

        if ($validator->fails()) {
            return response()->json(
                ['errors' => $validator->errors()],
                422,
                ['Content-Type' => 'application/json; charset=UTF-8'],
                JSON_UNESCAPED_UNICODE
            );
        }
        
        $data = $request->all();
        if (isset($data['postal_code']) && preg_match('/^\d{7}$/', $data['postal_code'])) {
            $data['postal_code'] = substr($data['postal_code'], 0, 3) . '-' . substr($data['postal_code'], 3, 4);
        }

        $this->usersService->updateUser($id, $data);
        return response()->json(
            ['message' => 'ユーザーを更新しました'],
            200,
            ['Content-Type' => 'application/json; charset=UTF-8'],
            JSON_UNESCAPED_UNICODE
        );
    }

    public function destroy($id)
    {
        $this->usersService->deleteUser($id);
        return response()->json(
            ['message' => 'ユーザーを削除しました'],
            200,
            ['Content-Type' => 'application/json; charset=UTF-8'],
            JSON_UNESCAPED_UNICODE
        );
    }
}

