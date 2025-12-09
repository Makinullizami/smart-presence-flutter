<?php

namespace App\Http\Requests\Admin;

use Illuminate\Foundation\Http\FormRequest;

class SystemSecuritySettingsRequest extends FormRequest
{
    /**
     * Determine if the user is authorized to make this request.
     */
    public function authorize(): bool
    {
        return $this->user()?->can('manage-settings') ?? false;
    }

    /**
     * Get the validation rules that apply to the request.
     *
     * @return array<string, \Illuminate\Contracts\Validation\ValidationRule|array<mixed>|string>
     */
    public function rules(): array
    {
        return [
            'self_registration_enabled' => ['required', 'boolean'],
            'password_min_length' => ['required', 'integer', 'min:6', 'max:32'],
            'password_require_uppercase' => ['required', 'boolean'],
            'password_require_number' => ['required', 'boolean'],
            'password_require_symbol' => ['required', 'boolean'],
            'session_idle_timeout_minutes' => ['required', 'integer', 'min:5', 'max:480'],
            'admin_activity_log_enabled' => ['required', 'boolean'],
            'admin_activity_log_retention_days' => ['required_if:admin_activity_log_enabled,true', 'integer', 'min:1', 'max:365'],
        ];
    }

    /**
     * Get custom messages for validator errors.
     *
     * @return array<string, string>
     */
    public function messages(): array
    {
        return [
            'self_registration_enabled.required' => 'Pengaturan registrasi mandiri wajib diisi.',
            'self_registration_enabled.boolean' => 'Pengaturan registrasi mandiri harus berupa boolean.',
            'password_min_length.required' => 'Panjang minimal password wajib diisi.',
            'password_min_length.integer' => 'Panjang minimal password harus berupa angka.',
            'password_min_length.min' => 'Panjang minimal password minimal 6 karakter.',
            'password_min_length.max' => 'Panjang minimal password maksimal 32 karakter.',
            'password_require_uppercase.required' => 'Pengaturan huruf besar password wajib diisi.',
            'password_require_uppercase.boolean' => 'Pengaturan huruf besar password harus berupa boolean.',
            'password_require_number.required' => 'Pengaturan angka password wajib diisi.',
            'password_require_number.boolean' => 'Pengaturan angka password harus berupa boolean.',
            'password_require_symbol.required' => 'Pengaturan simbol password wajib diisi.',
            'password_require_symbol.boolean' => 'Pengaturan simbol password harus berupa boolean.',
            'session_idle_timeout_minutes.required' => 'Timeout sesi idle wajib diisi.',
            'session_idle_timeout_minutes.integer' => 'Timeout sesi idle harus berupa angka.',
            'session_idle_timeout_minutes.min' => 'Timeout sesi idle minimal 5 menit.',
            'session_idle_timeout_minutes.max' => 'Timeout sesi idle maksimal 480 menit.',
            'admin_activity_log_enabled.required' => 'Pengaturan log aktivitas admin wajib diisi.',
            'admin_activity_log_enabled.boolean' => 'Pengaturan log aktivitas admin harus berupa boolean.',
            'admin_activity_log_retention_days.required_if' => 'Hari retensi log aktivitas admin wajib diisi ketika log diaktifkan.',
            'admin_activity_log_retention_days.integer' => 'Hari retensi log aktivitas admin harus berupa angka.',
            'admin_activity_log_retention_days.min' => 'Hari retensi log aktivitas admin minimal 1 hari.',
            'admin_activity_log_retention_days.max' => 'Hari retensi log aktivitas admin maksimal 365 hari.',
        ];
    }
}