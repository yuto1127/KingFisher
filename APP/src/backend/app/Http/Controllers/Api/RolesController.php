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
        return response()->json($this->rolesService->getAllRoles());
    }

    public function store(Request $request)
    {
        $this->rolesService->createRole($request->all());
        return response()->json(['message' => 'Role created successfully']);
    }

    public function update(Request $request, $id)
    {
        $this->rolesService->updateRole($id, $request->all());
        return response()->json(['message' => 'Role updated successfully']);
    }

    public function destroy($id)
    {
        $this->rolesService->deleteRole($id);
        return response()->json(['message' => 'Role deleted successfully']);
    }
}
