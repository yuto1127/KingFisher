<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class User extends Model
{
    //
    protected $fillable = ['name', 'gender', 'barth_day', 'phone_number'];

    public function userPass()
    {
        return $this->hasOne(UserPass::class);
    }
}
