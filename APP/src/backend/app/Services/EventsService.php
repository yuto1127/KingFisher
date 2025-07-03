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
        $data['created_at'] = now();
        return $this->eventsRepository->create($data);
    }

    public function updateEvent(int $id, array $data)
    {
        $data['updated_at'] = now();
        return $this->eventsRepository->update($id, $data);
    }

    public function deleteEvent(int $id)
    {
        return $this->eventsRepository->delete($id);
    }
} 