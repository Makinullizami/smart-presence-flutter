<?php

namespace App\Http\Requests\Admin;

use Illuminate\Foundation\Http\FormRequest;

class IntegrationSettingsRequest extends FormRequest
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
            'hr_integration_enabled' => ['required', 'boolean'],
            'hr_api_url' => ['nullable', 'url', 'max:500'],
            'hr_api_key' => ['nullable', 'string', 'max:500'],
            'hr_send_attendance_enabled' => ['required', 'boolean'],
            'academic_integration_enabled' => ['required', 'boolean'],
            'academic_api_url' => ['nullable', 'url', 'max:500'],
            'academic_api_key' => ['nullable', 'string', 'max:500'],
            'academic_sync_users' => ['required', 'boolean'],
            'academic_sync_classes' => ['required', 'boolean'],
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
            'hr_integration_enabled.required' => 'Pengaturan integrasi HR wajib diisi.',
            'hr_integration_enabled.boolean' => 'Pengaturan integrasi HR harus berupa boolean.',
            'hr_api_url.url' => 'URL API HR harus berupa URL yang valid.',
            'hr_api_url.max' => 'URL API HR maksimal 500 karakter.',
            'hr_api_key.string' => 'API key HR harus berupa string.',
            'hr_api_key.max' => 'API key HR maksimal 500 karakter.',
            'hr_send_attendance_enabled.required' => 'Pengaturan kirim kehadiran ke HR wajib diisi.',
            'hr_send_attendance_enabled.boolean' => 'Pengaturan kirim kehadiran ke HR harus berupa boolean.',
            'academic_integration_enabled.required' => 'Pengaturan integrasi akademik wajib diisi.',
            'academic_integration_enabled.boolean' => 'Pengaturan integrasi akademik harus berupa boolean.',
            'academic_api_url.url' => 'URL API akademik harus berupa URL yang valid.',
            'academic_api_url.max' => 'URL API akademik maksimal 500 karakter.',
            'academic_api_key.string' => 'API key akademik harus berupa string.',
            'academic_api_key.max' => 'API key akademik maksimal 500 karakter.',
            'academic_sync_users.required' => 'Pengaturan sinkronisasi pengguna akademik wajib diisi.',
            'academic_sync_users.boolean' => 'Pengaturan sinkronisasi pengguna akademik harus berupa boolean.',
            'academic_sync_classes.required' => 'Pengaturan sinkronisasi kelas akademik wajib diisi.',
            'academic_sync_classes.boolean' => 'Pengaturan sinkronisasi kelas akademik harus berupa boolean.',
        ];
    }
}