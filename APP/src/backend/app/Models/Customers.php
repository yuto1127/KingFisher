<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use App\Models\Roles;
use App\Models\Users;

class Customers extends Model
{
    //
    protected $fillable = ['role_id','user_id'];

    public function role()
    {
        return $this->hasOne(Roles::class);
    }

    public function user()
    {
        return $this->hasOne(Users::class);
    }
}
