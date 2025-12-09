<?php

namespace App\Http\Requests\Admin;

use Illuminate\Foundation\Http\FormRequest;

class NotificationEmailSettingsRequest extends FormRequest
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
            'push_enabled' => ['required', 'boolean'],
            'fcm_server_key' => ['nullable', 'string', 'max:500'],
            'fcm_sender_id' => ['nullable', 'string', 'max:100'],
            'reminder_before_work_enabled' => ['required', 'boolean'],
            'reminder_before_work_minutes' => ['required_if:reminder_before_work_enabled,true', 'integer', 'min:1', 'max:480'],
            'reminder_if_not_checked_in_enabled' => ['required', 'boolean'],
            'reminder_not_checked_in_time' => ['nullable', 'date_format:H:i'],
            'notify_leave_decision_enabled' => ['required', 'boolean'],
            'daily_summary_to_supervisor_enabled' => ['required', 'boolean'],
            'email_enabled' => ['required', 'boolean'],
            'smtp_host' => ['nullable', 'string', 'max:255'],
            'smtp_port' => ['nullable', 'integer', 'min:1', 'max:65535'],
            'smtp_username' => ['nullable', 'string', 'max:255'],
            'smtp_password' => ['nullable', 'string', 'max:500'],
            'smtp_encryption' => ['nullable', 'string', 'in:ssl,tls,none'],
            'smtp_from_address' => ['nullable', 'email', 'max:255'],
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
            'push_enabled.required' => 'Pengaturan push notification wajib diisi.',
            'push_enabled.boolean' => 'Pengaturan push notification harus berupa boolean.',
            'fcm_server_key.string' => 'FCM server key harus berupa string.',
            'fcm_server_key.max' => 'FCM server key maksimal 500 karakter.',
            'fcm_sender_id.string' => 'FCM sender ID harus berupa string.',
            'fcm_sender_id.max' => 'FCM sender ID maksimal 100 karakter.',
            'reminder_before_work_enabled.required' => 'Pengaturan reminder sebelum kerja wajib diisi.',
            'reminder_before_work_enabled.boolean' => 'Pengaturan reminder sebelum kerja harus berupa boolean.',
            'reminder_before_work_minutes.required_if' => 'Menit reminder sebelum kerja wajib diisi ketika reminder diaktifkan.',
            'reminder_before_work_minutes.integer' => 'Menit reminder sebelum kerja harus berupa angka.',
            'reminder_before_work_minutes.min' => 'Menit reminder sebelum kerja minimal 1.',
            'reminder_before_work_minutes.max' => 'Menit reminder sebelum kerja maksimal 480.',
            'reminder_if_not_checked_in_enabled.required' => 'Pengaturan reminder jika belum check-in wajib diisi.',
            'reminder_if_not_checked_in_enabled.boolean' => 'Pengaturan reminder jika belum check-in harus berupa boolean.',
            'reminder_not_checked_in_time.date_format' => 'Format waktu reminder check-in tidak valid (HH:MM).',
            'notify_leave_decision_enabled.required' => 'Pengaturan notifikasi keputusan cuti wajib diisi.',
            'notify_leave_decision_enabled.boolean' => 'Pengaturan notifikasi keputusan cuti harus berupa boolean.',
            'daily_summary_to_supervisor_enabled.required' => 'Pengaturan ringkasan harian ke supervisor wajib diisi.',
            'daily_summary_to_supervisor_enabled.boolean' => 'Pengaturan ringkasan harian ke supervisor harus berupa boolean.',
            'email_enabled.required' => 'Pengaturan email wajib diisi.',
            'email_enabled.boolean' => 'Pengaturan email harus berupa boolean.',
            'smtp_host.string' => 'SMTP host harus berupa string.',
            'smtp_host.max' => 'SMTP host maksimal 255 karakter.',
            'smtp_port.integer' => 'SMTP port harus berupa angka.',
            'smtp_port.min' => 'SMTP port minimal 1.',
            'smtp_port.max' => 'SMTP port maksimal 65535.',
            'smtp_username.string' => 'SMTP username harus berupa string.',
            'smtp_username.max' => 'SMTP username maksimal 255 karakter.',
            'smtp_password.string' => 'SMTP password harus berupa string.',
            'smtp_password.max' => 'SMTP password maksimal 500 karakter.',
            'smtp_encryption.in' => 'Enkripsi SMTP harus ssl, tls, atau none.',
            'smtp_from_address.email' => 'Alamat email pengirim SMTP harus valid.',
            'smtp_from_address.max' => 'Alamat email pengirim SMTP maksimal 255 karakter.',
        ];
    }
}