<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class UserDevice extends Model
{
    use HasFactory;

    protected $fillable = [
        'user_id',
        'device_id',
        'device_name',
        'device_model',
        'platform',
        'os_version',
        'app_version',
        'fcm_token',
        'is_active',
        'is_verified',
        'last_login_at',
        'ip_address',
        'device_info',
    ];

    protected $casts = [
        'is_active' => 'boolean',
        'is_verified' => 'boolean',
        'last_login_at' => 'datetime',
        'device_info' => 'array',
    ];

    /**
     * Get the user that owns the device
     */
    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }

    /**
     * Scope for active devices
     */
    public function scopeActive($query)
    {
        return $query->where('is_active', true);
    }

    /**
     * Scope for verified devices
     */
    public function scopeVerified($query)
    {
        return $query->where('is_verified', true);
    }

    /**
     * Check if device is within the allowed limit
     */
    public static function isWithinDeviceLimit($userId, $maxDevices = 2): bool
    {
        return self::where('user_id', $userId)
                  ->active()
                  ->count() < $maxDevices;
    }

    /**
     * Get device count for user
     */
    public static function getDeviceCount($userId): int
    {
        return self::where('user_id', $userId)
                  ->active()
                  ->count();
    }

    /**
     * Deactivate old devices if limit exceeded
     */
    public static function enforceDeviceLimit($userId, $maxDevices = 2): void
    {
        $activeDevices = self::where('user_id', $userId)
                            ->active()
                            ->orderBy('last_login_at', 'desc')
                            ->get();

        if ($activeDevices->count() > $maxDevices) {
            // Keep only the most recent devices, deactivate the rest
            $devicesToDeactivate = $activeDevices->skip($maxDevices);

            foreach ($devicesToDeactivate as $device) {
                $device->update(['is_active' => false]);
            }
        }
    }

    /**
     * Generate a unique device ID
     */
    public static function generateDeviceId(): string
    {
        return 'device_' . time() . '_' . strtoupper(substr(md5(uniqid()), 0, 8));
    }

    /**
     * Update FCM token for device
     */
    public function updateFcmToken(string $fcmToken): void
    {
        $this->update(['fcm_token' => $fcmToken]);
    }

    /**
     * Mark device as verified
     */
    public function markAsVerified(): void
    {
        $this->update(['is_verified' => true]);
    }

    /**
     * Deactivate device
     */
    public function deactivate(): void
    {
        $this->update(['is_active' => false]);
    }

    /**
     * Record login activity
     */
    public function recordLogin(string $ipAddress = null): void
    {
        $this->update([
            'last_login_at' => now(),
            'ip_address' => $ipAddress,
        ]);
    }
}