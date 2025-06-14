<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Services\EntryStatusesService;

class EntryStatusesController extends Controller
{
    //
    protected $entryStatusesService;

    public function __construct(EntryStatusesService $entryStatusesService)
    {
        $this->entryStatusesService = $entryStatusesService;
    }

    public function index()
    {
        return response()->json(
            $this->entryStatusesService->getAllEntryStatuses(),
            200,
            ['Content-Type' => 'application/json; charset=UTF-8'],
            JSON_UNESCAPED_UNICODE
        );
    }

    public function store(Request $request)
    {
        $this->entryStatusesService->createEntryStatus($request->all());
        return response()->json(
            ['message' => '入場ステータスを作成しました'],
            201,
            ['Content-Type' => 'application/json; charset=UTF-8'],
            JSON_UNESCAPED_UNICODE
        );
    }

    public function update(Request $request, $id)
    {
        $this->entryStatusesService->updateEntryStatus($id, $request->all());
        return response()->json(
            ['message' => '入場ステータスを更新しました'],
            200,
            ['Content-Type' => 'application/json; charset=UTF-8'],
            JSON_UNESCAPED_UNICODE
        );
    }

    public function destroy($id)
    {
        $this->entryStatusesService->deleteEntryStatus($id);
        return response()->json(
            ['message' => '入場ステータスを削除しました'],
            200,
            ['Content-Type' => 'application/json; charset=UTF-8'],
            JSON_UNESCAPED_UNICODE
        );
    }
}
