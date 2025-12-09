<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('settings', function (Blueprint $table) {
            $table->id();
            $table->string('group')->index(); // e.g. 'profile', 'attendance', 'location_device'
            $table->string('key')->index(); // e.g. 'institution_name', 'work_start_time'
            $table->text('value')->nullable(); // raw stored value (stringified)
            $table->string('type')->default('string'); // value type hint: string, integer, boolean, json, time, float
            $table->boolean('autoload')->default(true); // indicates if loaded by default
            $table->timestamps();

            // Composite unique index to prevent duplicate group+key combinations
            $table->unique(['group', 'key']);
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('settings');
    }
};