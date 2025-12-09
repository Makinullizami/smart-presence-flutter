<?php

namespace App\Http\Requests\Admin;

use Illuminate\Foundation\Http\FormRequest;

class AttendanceSettingsRequest extends FormRequest
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
            'default_work_start_time' => ['required', 'date_format:H:i'],
            'default_work_end_time' => ['required', 'date_format:H:i', 'after:default_work_start_time'],
            'late_tolerance_minutes' => ['required', 'integer', 'min:0', 'max:480'],
            'min_full_attendance_minutes' => ['required', 'integer', 'min:0', 'max:1440'],
            'allow_checkout_without_checkin' => ['required', 'boolean'],
            'allow_attendance_on_holiday' => ['required', 'boolean'],
            'min_attendance_percent' => ['required', 'integer', 'between:0,100'],
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
            'default_work_start_time.required' => 'Jam mulai kerja wajib diisi.',
            'default_work_start_time.date_format' => 'Format jam mulai kerja tidak valid (HH:MM).',
            'default_work_end_time.required' => 'Jam selesai kerja wajib diisi.',
            'default_work_end_time.date_format' => 'Format jam selesai kerja tidak valid (HH:MM).',
            'default_work_end_time.after' => 'Jam selesai kerja harus setelah jam mulai kerja.',
            'late_tolerance_minutes.required' => 'Toleransi keterlambatan wajib diisi.',
            'late_tolerance_minutes.integer' => 'Toleransi keterlambatan harus berupa angka.',
            'late_tolerance_minutes.min' => 'Toleransi keterlambatan minimal 0 menit.',
            'late_tolerance_minutes.max' => 'Toleransi keterlambatan maksimal 480 menit.',
            'min_full_attendance_minutes.required' => 'Minimal menit kehadiran penuh wajib diisi.',
            'min_full_attendance_minutes.integer' => 'Minimal menit kehadiran harus berupa angka.',
            'min_full_attendance_minutes.min' => 'Minimal menit kehadiran minimal 0 menit.',
            'min_full_attendance_minutes.max' => 'Minimal menit kehadiran maksimal 1440 menit.',
            'allow_checkout_without_checkin.required' => 'Pengaturan checkout tanpa checkin wajib diisi.',
            'allow_checkout_without_checkin.boolean' => 'Pengaturan checkout tanpa checkin harus berupa boolean.',
            'allow_attendance_on_holiday.required' => 'Pengaturan kehadiran di hari libur wajib diisi.',
            'allow_attendance_on_holiday.boolean' => 'Pengaturan kehadiran di hari libur harus berupa boolean.',
            'min_attendance_percent.required' => 'Minimal persentase kehadiran wajib diisi.',
            'min_attendance_percent.integer' => 'Minimal persentase kehadiran harus berupa angka.',
            'min_attendance_percent.between' => 'Minimal persentase kehadiran harus antara 0-100.',
        ];
    }
}