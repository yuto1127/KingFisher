<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Users extends Model
{
    //
    protected $fillable = ['name', 'gender', 'barth_day', 'phone_number'];
}
