<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
use Laravel\Sanctum\HasApiTokens;

class User extends Authenticatable
{
    use HasApiTokens, HasFactory, Notifiable;

    protected $fillable = [
        'name',
        'email',
        'password',
        'role',
        'nim',
        'employee_id',
        'class_id',
        'department_id',
        'phone',
        'address',
        'date_of_birth',
        'gender',
        'profile_photo_path',
        'bio',
        'emergency_contact_name',
        'emergency_contact_phone',
        'notification_preferences',
        'language_preference',
        'theme_preference',
        'is_active',
        'last_login_at',
        'fcm_token',
    ];

    protected $hidden = [
        'password',
        'remember_token',
    ];

    protected $casts = [
        'email_verified_at' => 'datetime',
        'last_login_at' => 'datetime',
        'date_of_birth' => 'date',
        'password' => 'hashed',
        'is_active' => 'boolean',
        'notification_preferences' => 'array',
    ];

    public function attendances()
    {
        return $this->hasMany(Attendance::class);
    }

    public function faces()
    {
        return $this->hasMany(Face::class);
    }

    public function class()
    {
        return $this->belongsTo(ClassModel::class, 'class_id');
    }

    public function department()
    {
        return $this->belongsTo(Department::class);
    }

    public function appeals()
    {
        return $this->hasMany(Appeal::class);
    }

    public function notifications()
    {
        return $this->hasMany(Notification::class);
    }

    public function supervisedClasses()
    {
        return $this->hasMany(ClassModel::class, 'supervisor_id');
    }

    public function managedDepartment()
    {
        return $this->hasOne(Department::class, 'admin_id');
    }

    public function approvedAppeals()
    {
        return $this->hasMany(Appeal::class, 'approved_by');
    }

    public function announcements()
    {
        return $this->hasMany(Announcement::class, 'created_by');
    }

    public function devices()
    {
        return $this->hasMany(UserDevice::class);
    }

    public function activeDevices()
    {
        return $this->devices()->active();
    }

    public function verifiedDevices()
    {
        return $this->devices()->verified();
    }

    /**
     * Get profile photo URL
     */
    public function getProfilePhotoUrlAttribute()
    {
        return $this->profile_photo_path
            ? asset('storage/' . $this->profile_photo_path)
            : null;
    }

    /**
     * Get notification preferences with defaults
     */
    public function getNotificationPreferences()
    {
        return array_merge([
            'attendance_reminder' => true,
            'announcement' => true,
            'appeal_status' => true,
            'schedule_change' => true,
        ], $this->notification_preferences ?? []);
    }

    /**
     * Update FCM token for all active devices
     */
    public function updateFcmToken(string $fcmToken, string $deviceId = null): void
    {
        if ($deviceId) {
            $this->devices()->where('device_id', $deviceId)->update(['fcm_token' => $fcmToken]);
        } else {
            $this->activeDevices()->update(['fcm_token' => $fcmToken]);
        }
    }
}