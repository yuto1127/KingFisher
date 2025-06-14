<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Laravel\Sanctum\HasApiTokens;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Notifications\Notifiable;
use Illuminate\Foundation\Auth\User as Authenticatable;

class User extends Authenticatable
{
    use HasApiTokens, HasFactory, Notifiable;

    //
    protected $fillable = [
        'name',
        'gender',
        'barth_day',
        'phone_number',
        'role_id'
    ];

    public function role()
    {
        return $this->belongsTo(Role::class);
    }

    public function userPass()
    {
        return $this->hasOne(UserPass::class);
    }

    public function customers()
    {
        return $this->hasMany(Customer::class);
    }

    public function helpDesks()
    {
        return $this->hasMany(HelpDesk::class);
    }

    public function entryStatuses()
    {
        return $this->hasMany(EntryStatus::class);
    }
}
