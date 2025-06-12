<?php

namespace App\Services;

use App\Repositories\HelpDesksRepository;

class HelpDesksService
{
    protected $helpDesksRepository;

    public function __construct(HelpDesksRepository $helpDesksRepository)
    {
        $this->helpDesksRepository = $helpDesksRepository;
    }

    public function getAllHelpDesks()
    {
        return $this->helpDesksRepository->getAll();
    }

    public function createHelpDesk(array $data)
    {
        return $this->helpDesksRepository->create($data);
    }

    public function updateHelpDesk(int $id, array $data)
    {
        return $this->helpDesksRepository->update($id, $data);
    }

    public function deleteHelpDesk(int $id)
    {
        return $this->helpDesksRepository->delete($id);
    }
} 