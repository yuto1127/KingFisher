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
        return response()->json($this->entryStatusesService->getAllEntryStatuses());
    }

    public function store(Request $request)
    {
        $this->entryStatusesService->createEntryStatus($request->all());
        return response()->json(['message' => 'Entry status created successfully']);
    }

    public function update(Request $request, $id)
    {
        $this->entryStatusesService->updateEntryStatus($id, $request->all());
        return response()->json(['message' => 'Entry status updated successfully']);
    }

    public function destroy($id)
    {
        $this->entryStatusesService->deleteEntryStatus($id);
        return response()->json(['message' => 'Entry status deleted successfully']);
    }
}
