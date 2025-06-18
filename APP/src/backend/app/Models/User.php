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
        'postal_code',
        'prefecture',
        'city',
        'address_line1',
        'address_line2',
        'is_active',
        'last_login_at'
    ];

    protected $casts = [
        'barth_day' => 'date',
        'last_login_at' => 'datetime',
        'is_active' => 'boolean'
    ];

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

    public function personalAccessTokens()
    {
        return $this->hasMany(PersonalAccessToken::class, 'user_id');
    }

    // 住所を完全な文字列として取得
    public function getFullAddressAttribute(): string
    {
        $address = [];
        if ($this->postal_code) {
            $address[] = $this->postal_code;
        }
        if ($this->prefecture) {
            $address[] = $this->prefecture;
        }
        if ($this->city) {
            $address[] = $this->city;
        }
        if ($this->address_line1) {
            $address[] = $this->address_line1;
        }
        if ($this->address_line2) {
            $address[] = $this->address_line2;
        }
        return implode(' ', $address);
    }
}
