<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use App\Models\Users;

class UserPass extends Model
{
    //
    protected $fillable = ['user_id','email','password'];

    public function user()
    {
        return $this->hasOne(User::class);
    }
}
