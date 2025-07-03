<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use App\Models\User;

class EntryStatus extends Model
{
    //
    protected $fillable = ['user_id','status','entry_at','exit_at'];

    public function user()
    {
        return $this->belongsTo(User::class);
    }
}
