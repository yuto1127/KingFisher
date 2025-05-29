<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use App\Models\Role;
use App\Models\User;

class Customer extends Model
{
    //
    protected $fillable = ['role_id','user_id'];

    public function role()
    {
        return $this->hasOne(Role::class);
    }

    public function user()
    {
        return $this->hasOne(User::class);
    }
}
