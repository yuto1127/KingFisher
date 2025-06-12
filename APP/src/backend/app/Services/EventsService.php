<?php

namespace App\Services;

use App\Repositories\EventsRepository;

class EventsService
{
    protected $eventsRepository;

    public function __construct(EventsRepository $eventsRepository)
    {
        $this->eventsRepository = $eventsRepository;
    }

    public function getAllEvents()
    {
        return $this->eventsRepository->getAll();
    }

    public function createEvent(array $data)
    {
        return $this->eventsRepository->create($data);
    }

    public function updateEvent(int $id, array $data)
    {
        return $this->eventsRepository->update($id, $data);
    }

    public function deleteEvent(int $id)
    {
        return $this->eventsRepository->delete($id);
    }
} 