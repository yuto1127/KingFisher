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
        return response()->json(
            $this->helpDesksService->getAllHelpDesks(),
            200,
            ['Content-Type' => 'application/json; charset=UTF-8'],
            JSON_UNESCAPED_UNICODE
        );
    }

    public function store(Request $request)
    {
        $this->helpDesksService->createHelpDesk($request->all());
        return response()->json(
            ['message' => 'ヘルプデスクを作成しました'],
            201,
            ['Content-Type' => 'application/json; charset=UTF-8'],
            JSON_UNESCAPED_UNICODE
        );
    }

    public function update(Request $request, $id)
    {
        $this->helpDesksService->updateHelpDesk($id, $request->all());
        return response()->json(
            ['message' => 'ヘルプデスクを更新しました'],
            200,
            ['Content-Type' => 'application/json; charset=UTF-8'],
            JSON_UNESCAPED_UNICODE
        );
    }

    public function destroy($id)
    {
        $this->helpDesksService->deleteHelpDesk($id);
        return response()->json(
            ['message' => 'ヘルプデスクを削除しました'],
            200,
            ['Content-Type' => 'application/json; charset=UTF-8'],
            JSON_UNESCAPED_UNICODE
        );
    }

    public function storeFromService(array $data)
    {
        $this->helpDesksService->createHelpDesk($data);
        // レスポンス不要
    }
}



