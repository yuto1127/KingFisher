<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class LostItem extends Model
{
    use HasFactory;

    protected $fillable = [
        'title',
        'description',
        'location',
        'status',
        'icon',
    ];

    protected $casts = [
        'created_at' => 'datetime',
        'updated_at' => 'datetime',
    ];

    /**
     * アイコン名からアイコンを取得
     */
    public function getIconAttribute($value)
    {
        return $value ?: 'inventory';
    }

    /**
     * ステータス名からステータスを取得
     */
    public function getStatusAttribute($value)
    {
        return $value ?: '保管中';
    }
} 