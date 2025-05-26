<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use App\Models\User;

class UserPass extends Model
{
    //
    protected $fillable = ['user_id','email','password'];

    public function user()
    {
        return $this->hasOne(Users::class);
    }
}
