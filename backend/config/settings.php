<?php

return [
    /*
    |--------------------------------------------------------------------------
    | Settings Configuration
    |--------------------------------------------------------------------------
    |
    | This file contains the configuration for the settings system.
    | Each group contains the mapping of keys to their data types.
    |
    */

    'groups' => [
        'profile' => [
            'institution_name' => 'string',
            'institution_logo_path' => 'string',
            'address' => 'string',
            'phone' => 'string',
            'official_email' => 'string',
            'timezone' => 'string',
            'academic_year_active' => 'string',
        ],

        'attendance' => [
            'default_work_start_time' => 'time',
            'default_work_end_time' => 'time',
            'late_tolerance_minutes' => 'integer',
            'min_full_attendance_minutes' => 'integer',
            'allow_checkout_without_checkin' => 'boolean',
            'allow_attendance_on_holiday' => 'boolean',
            'min_attendance_percent' => 'integer',
        ],

        'location_device' => [
            'gps_enabled' => 'boolean',
            'geofence_radius_meters' => 'integer',
            'office_latitude' => 'string',
            'office_longitude' => 'string',
            'wifi_restriction_enabled' => 'boolean',
            'allowed_wifi_list' => 'json',
            'device_binding_enabled' => 'boolean',
            'max_devices_per_user' => 'integer',
        ],

        'face' => [
            'photo_required' => 'boolean',
            'photo_mode' => 'string',
            'face_service_url' => 'string',
            'face_similarity_threshold' => 'integer',
            'liveness_check_enabled' => 'boolean',
            'max_face_attempts' => 'integer',
        ],

        'notification_email' => [
            'push_enabled' => 'boolean',
            'fcm_server_key' => 'string',
            'fcm_sender_id' => 'string',
            'reminder_before_work_enabled' => 'boolean',
            'reminder_before_work_minutes' => 'integer',
            'reminder_if_not_checked_in_enabled' => 'boolean',
            'reminder_not_checked_in_time' => 'time',
            'notify_leave_decision_enabled' => 'boolean',
            'daily_summary_to_supervisor_enabled' => 'boolean',
            'email_enabled' => 'boolean',
            'smtp_host' => 'string',
            'smtp_port' => 'integer',
            'smtp_username' => 'string',
            'smtp_password' => 'string',
            'smtp_encryption' => 'string',
            'smtp_from_address' => 'string',
        ],

        'integration' => [
            'hr_integration_enabled' => 'boolean',
            'hr_api_url' => 'string',
            'hr_api_key' => 'string',
            'hr_send_attendance_enabled' => 'boolean',
            'academic_integration_enabled' => 'boolean',
            'academic_api_url' => 'string',
            'academic_api_key' => 'string',
            'academic_sync_users' => 'boolean',
            'academic_sync_classes' => 'boolean',
        ],

        'system_security' => [
            'self_registration_enabled' => 'boolean',
            'password_min_length' => 'integer',
            'password_require_uppercase' => 'boolean',
            'password_require_number' => 'boolean',
            'password_require_symbol' => 'boolean',
            'session_idle_timeout_minutes' => 'integer',
            'admin_activity_log_enabled' => 'boolean',
            'admin_activity_log_retention_days' => 'integer',
        ],
    ],
];