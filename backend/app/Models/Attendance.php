<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Attendance extends Model
{
    use HasFactory;

    protected $fillable = [
        'user_id',
        'date',
        'check_in_time',
        'check_out_time',
        'status',
        'notes',
        'location',
        'validation_method',
        'is_offline_sync',
    ];

    protected $casts = [
        'date' => 'date',
        'check_in_time' => 'datetime',
        'check_out_time' => 'datetime',
        'location' => 'array',
        'is_offline_sync' => 'boolean',
    ];

    public function user()
    {
        return $this->belongsTo(User::class);
    }
}