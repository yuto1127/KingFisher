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
        return $this->morphMany(PersonalAccessToken::class, 'tokenable');
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

    // ユーザーのロール情報を取得
    public function getRoleInfo()
    {
        // まずcustomersテーブルで確認
        $customer = $this->customers()->with('role')->first();
        if ($customer) {
            return [
                'role_id' => $customer->role_id,
                'role_name' => $customer->role->name,
                'type' => 'customer'
            ];
        }

        // customersにない場合はhelp_desksテーブルで確認
        $helpDesk = $this->helpDesks()->with('role')->first();
        if ($helpDesk) {
            return [
                'role_id' => $helpDesk->role_id,
                'role_name' => $helpDesk->role->name,
                'type' => 'help_desk'
            ];
        }

        return null;
    }
}
