<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Services\HelpDesksService;

class HelpDesksController extends Controller
{
    //
    protected $helpDesksService;

    public function __construct(HelpDesksService $helpDesksService)
    {
        $this->helpDesksService = $helpDesksService;
    }

    public function index()
    {
        return response()->json($this->helpDesksService->getAllHelpDesks());
    }

    public function store(Request $request)
    {
        $this->helpDesksService->createHelpDesk($request->all());
        return response()->json(['message' => 'Help desk created successfully']);
    }

    public function update(Request $request, $id)
    {
        $this->helpDesksService->updateHelpDesk($id, $request->all());
        return response()->json(['message' => 'Help desk updated successfully']);
    }

    public function destroy($id)
    {
        $this->helpDesksService->deleteHelpDesk($id);
        return response()->json(['message' => 'Help desk deleted successfully']);
    }
}



