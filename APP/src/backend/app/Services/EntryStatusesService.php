<?php

namespace App\Services;

use App\Repositories\EntryStatusesRepository;

class EntryStatusesService
{
    protected $entryStatusesRepository;

    public function __construct(EntryStatusesRepository $entryStatusesRepository)
    {
        $this->entryStatusesRepository = $entryStatusesRepository;
    }

    public function getAllEntryStatuses()
    {
        return $this->entryStatusesRepository->getAll();
    }

    public function createEntryStatus(array $data)
    {
        $data['created_at'] = now();
        return $this->entryStatusesRepository->create($data);
    }

    public function updateEntryStatus(int $id, array $data)
    {
        $data['updated_at'] = now();
        return $this->entryStatusesRepository->update($id, $data);
    }

    public function deleteEntryStatus(int $id)
    {
        return $this->entryStatusesRepository->delete($id);
    }
} 