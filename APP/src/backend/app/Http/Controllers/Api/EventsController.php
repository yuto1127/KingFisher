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
        return response()->json($this->eventsService->getAllEvents());
    }

    public function store(Request $request)
    {
        $this->eventsService->createEvent($request->all());
        return response()->json(['message' => 'Event created successfully']);
    }

    public function update(Request $request, $id)
    {
        $this->eventsService->updateEvent($id, $request->all());
        return response()->json(['message' => 'Event updated successfully']);
    }

    public function destroy($id)
    {
        $this->eventsService->deleteEvent($id);
        return response()->json(['message' => 'Event deleted successfully']);
    }


}
