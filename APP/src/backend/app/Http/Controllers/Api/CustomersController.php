<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Services\CustomersService;

class CustomersController extends Controller
{
    //
    protected $customersService;

    public function __construct(CustomersService $customersService)
    {
        $this->customersService = $customersService;
    }

    public function index()
    {
        return response()->json($this->customersService->getAllCustomers());
    }

    public function store(Request $request)
    {
        $this->customersService->createCustomer($request->all());
        return response()->json(['message' => 'Customer created successfully']);
    }

    public function update(Request $request, $id)
    {
        $this->customersService->updateCustomer($id, $request->all());
        return response()->json(['message' => 'Customer updated successfully']);
    }

    public function destroy($id)
    {
        $this->customersService->deleteCustomer($id);
        return response()->json(['message' => 'Customer deleted successfully']);
    }
}
