<?php

namespace App\Http\Requests\Admin;

use Illuminate\Foundation\Http\FormRequest;

class LocationDeviceSettingsRequest extends FormRequest
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
            'gps_enabled' => ['required', 'boolean'],
            'geofence_radius_meters' => ['required_if:gps_enabled,true', 'integer', 'min:10', 'max:5000'],
            'office_latitude' => ['required_if:gps_enabled,true', 'numeric', 'between:-90,90'],
            'office_longitude' => ['required_if:gps_enabled,true', 'numeric', 'between:-180,180'],
            'wifi_restriction_enabled' => ['required', 'boolean'],
            'allowed_wifi_list' => ['nullable', 'array'],
            'allowed_wifi_list.*.ssid' => ['required_with:allowed_wifi_list', 'string', 'max:100'],
            'allowed_wifi_list.*.description' => ['nullable', 'string', 'max:255'],
            'device_binding_enabled' => ['required', 'boolean'],
            'max_devices_per_user' => ['required_if:device_binding_enabled,true', 'integer', 'min:1', 'max:10'],
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
            'gps_enabled.required' => 'Pengaturan GPS wajib diisi.',
            'gps_enabled.boolean' => 'Pengaturan GPS harus berupa boolean.',
            'geofence_radius_meters.required_if' => 'Radius geofence wajib diisi ketika GPS diaktifkan.',
            'geofence_radius_meters.integer' => 'Radius geofence harus berupa angka.',
            'geofence_radius_meters.min' => 'Radius geofence minimal 10 meter.',
            'geofence_radius_meters.max' => 'Radius geofence maksimal 5000 meter.',
            'office_latitude.required_if' => 'Latitude kantor wajib diisi ketika GPS diaktifkan.',
            'office_latitude.numeric' => 'Latitude kantor harus berupa angka.',
            'office_latitude.between' => 'Latitude kantor harus antara -90 sampai 90.',
            'office_longitude.required_if' => 'Longitude kantor wajib diisi ketika GPS diaktifkan.',
            'office_longitude.numeric' => 'Longitude kantor harus berupa angka.',
            'office_longitude.between' => 'Longitude kantor harus antara -180 sampai 180.',
            'wifi_restriction_enabled.required' => 'Pengaturan restriksi WiFi wajib diisi.',
            'wifi_restriction_enabled.boolean' => 'Pengaturan restriksi WiFi harus berupa boolean.',
            'allowed_wifi_list.array' => 'Daftar WiFi yang diizinkan harus berupa array.',
            'allowed_wifi_list.*.ssid.required_with' => 'SSID WiFi wajib diisi.',
            'allowed_wifi_list.*.ssid.string' => 'SSID WiFi harus berupa string.',
            'allowed_wifi_list.*.ssid.max' => 'SSID WiFi maksimal 100 karakter.',
            'allowed_wifi_list.*.description.string' => 'Deskripsi WiFi harus berupa string.',
            'allowed_wifi_list.*.description.max' => 'Deskripsi WiFi maksimal 255 karakter.',
            'device_binding_enabled.required' => 'Pengaturan binding perangkat wajib diisi.',
            'device_binding_enabled.boolean' => 'Pengaturan binding perangkat harus berupa boolean.',
            'max_devices_per_user.required_if' => 'Maksimal perangkat per pengguna wajib diisi ketika binding perangkat diaktifkan.',
            'max_devices_per_user.integer' => 'Maksimal perangkat per pengguna harus berupa angka.',
            'max_devices_per_user.min' => 'Maksimal perangkat per pengguna minimal 1.',
            'max_devices_per_user.max' => 'Maksimal perangkat per pengguna maksimal 10.',
        ];
    }
}