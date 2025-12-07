<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('user_devices', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->constrained()->onDelete('cascade');
            $table->string('device_id')->unique(); // Unique device identifier
            $table->string('device_name')->nullable(); // Human readable device name
            $table->string('device_model')->nullable(); // Device model
            $table->string('platform')->nullable(); // iOS/Android
            $table->string('os_version')->nullable(); // OS version
            $table->string('app_version')->nullable(); // App version
            $table->string('fcm_token')->nullable(); // Firebase token for push notifications
            $table->boolean('is_active')->default(true); // Is device still active
            $table->boolean('is_verified')->default(false); // Has device been verified
            $table->timestamp('last_login_at')->nullable(); // Last login time
            $table->string('ip_address')->nullable(); // IP address of last login
            $table->json('device_info')->nullable(); // Additional device information
            $table->timestamps();

            $table->index(['user_id', 'is_active']);
            $table->index('device_id');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('user_devices');
    }
};