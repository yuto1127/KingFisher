<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Services\EventsService;

class EventsController extends Controller
{
    //
    protected $eventsService;

    public function __construct(EventsService $eventsService)
    {
        $this->eventsService = $eventsService;
    }

    public function index()
    {
        return response()->json(
            $this->eventsService->getAllEvents(),
            200,
            ['Content-Type' => 'application/json; charset=UTF-8'],
            JSON_UNESCAPED_UNICODE
        );
    }

    public function store(Request $request)
    {
        $this->eventsService->createEvent($request->all());
        return response()->json(
            ['message' => 'イベントを作成しました'],
            201,
            ['Content-Type' => 'application/json; charset=UTF-8'],
            JSON_UNESCAPED_UNICODE
        );
    }

    public function update(Request $request, $id)
    {
        $this->eventsService->updateEvent($id, $request->all());
        return response()->json(
            ['message' => 'イベントを更新しました'],
            200,
            ['Content-Type' => 'application/json; charset=UTF-8'],
            JSON_UNESCAPED_UNICODE
        );
    }

    public function destroy($id)
    {
        $this->eventsService->deleteEvent($id);
        return response()->json(
            ['message' => 'イベントを削除しました'],
            200,
            ['Content-Type' => 'application/json; charset=UTF-8'],
            JSON_UNESCAPED_UNICODE
        );
    }


}
