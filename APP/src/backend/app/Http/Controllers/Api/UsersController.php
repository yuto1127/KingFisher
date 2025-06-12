<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Services\UsersService;

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
        return response()->json($this->usersService->getAllUsers());
    }

    public function store(Request $request)
    {
        $this->usersService->createUser($request->all());
        return response()->json(['message' => 'User created successfully']);
    }

    public function update(Request $request, $id)
    {
        $this->usersService->updateUser($id, $request->all());
        return response()->json(['message' => 'User updated successfully']);
    }

    public function destroy($id)
    {
        $this->usersService->deleteUser($id);
        return response()->json(['message' => 'User deleted successfully']);
    }
}

