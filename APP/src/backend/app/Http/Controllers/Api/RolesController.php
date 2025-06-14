<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Services\RolesService;

class RolesController extends Controller
{
    protected $rolesService;

    public function __construct(RolesService $rolesService)
    {
        $this->rolesService = $rolesService;
    }

    public function index()
    {
        return response()->json(
            $this->rolesService->getAllRoles(),
            200,
            ['Content-Type' => 'application/json; charset=UTF-8'],
            JSON_UNESCAPED_UNICODE
        );
    }

    public function store(Request $request)
    {
        $this->rolesService->createRole($request->all());
        return response()->json(
            ['message' => 'ロールを作成しました'],
            201,
            ['Content-Type' => 'application/json; charset=UTF-8'],
            JSON_UNESCAPED_UNICODE
        );
    }

    public function update(Request $request, $id)
    {
        $this->rolesService->updateRole($id, $request->all());
        return response()->json(
            ['message' => 'ロールを更新しました'],
            200,
            ['Content-Type' => 'application/json; charset=UTF-8'],
            JSON_UNESCAPED_UNICODE
        );
    }

    public function destroy($id)
    {
        $this->rolesService->deleteRole($id);
        return response()->json(
            ['message' => 'ロールを削除しました'],
            200,
            ['Content-Type' => 'application/json; charset=UTF-8'],
            JSON_UNESCAPED_UNICODE
        );
    }
}
