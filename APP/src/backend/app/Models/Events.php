<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Events extends Model
{
    //
    protected $fillable = ['title', 'start_date', 'end_date'];

    public function EntryStatus()
    {
        return $this->hasMany(EntryStatus::class);
    }
}
