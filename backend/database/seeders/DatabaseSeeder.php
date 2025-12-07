<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;

class DatabaseSeeder extends Seeder
{
    public function run(): void
    {
        // Create admin user
        DB::table('users')->insert([
            'name' => 'System Admin',
            'email' => 'admin@smartpresence.com',
            'password' => Hash::make('password'),
            'role' => 'admin',
            'is_active' => true,
            'created_at' => now(),
            'updated_at' => now(),
        ]);

        // Create sample department
        DB::table('departments')->insert([
            'name' => 'Information Technology',
            'admin_id' => 1,
            'created_at' => now(),
            'updated_at' => now(),
        ]);

        // Create sample class
        DB::table('classes')->insert([
            'name' => 'Computer Science 2024',
            'supervisor_id' => 1,
            'department_id' => 1,
            'created_at' => now(),
            'updated_at' => now(),
        ]);

        // System settings
        $settings = [
            ['key' => 'app_name', 'value' => 'Smart Presence', 'type' => 'string', 'description' => 'Application name'],
            ['key' => 'attendance_tolerance_minutes', 'value' => '10', 'type' => 'integer', 'description' => 'Tolerance time for late attendance in minutes'],
            ['key' => 'minimum_attendance_percentage', 'value' => '75', 'type' => 'integer', 'description' => 'Minimum attendance percentage required'],
            ['key' => 'geofence_enabled', 'value' => 'true', 'type' => 'boolean', 'description' => 'Enable geofence validation'],
            ['key' => 'geofence_center_lat', 'value' => '-6.2088', 'type' => 'string', 'description' => 'Geofence center latitude'],
            ['key' => 'geofence_center_lng', 'value' => '106.8456', 'type' => 'string', 'description' => 'Geofence center longitude'],
            ['key' => 'geofence_radius_meters', 'value' => '500', 'type' => 'integer', 'description' => 'Geofence radius in meters'],
            ['key' => 'face_recognition_threshold', 'value' => '0.8', 'type' => 'string', 'description' => 'Face recognition similarity threshold'],
            ['key' => 'session_timeout_minutes', 'value' => '60', 'type' => 'integer', 'description' => 'Session timeout in minutes'],
            ['key' => 'working_hours_start', 'value' => '08:00', 'type' => 'string', 'description' => 'Working hours start time'],
            ['key' => 'working_hours_end', 'value' => '17:00', 'type' => 'string', 'description' => 'Working hours end time'],
        ];

        foreach ($settings as $setting) {
            DB::table('system_settings')->insert(array_merge($setting, [
                'created_at' => now(),
                'updated_at' => now(),
            ]));
        }
    }
}