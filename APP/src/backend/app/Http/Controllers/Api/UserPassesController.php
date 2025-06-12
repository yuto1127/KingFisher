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
        return response()->json($this->userPassesService->getAllUserPasses());
    }

    public function store(Request $request)
    {
        $this->userPassesService->createUserPass($request->all());
        return response()->json(['message' => 'User pass created successfully']);
    }

    public function update(Request $request, $id)
    {
        $this->userPassesService->updateUserPass($id, $request->all());
        return response()->json(['message' => 'User pass updated successfully']);
    }

    public function destroy($id)
    {
        $this->userPassesService->deleteUserPass($id);
        return response()->json(['message' => 'User pass deleted successfully']);
    }

}
