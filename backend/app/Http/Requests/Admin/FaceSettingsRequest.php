<?php

namespace App\Http\Requests\Admin;

use Illuminate\Foundation\Http\FormRequest;

class FaceSettingsRequest extends FormRequest
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
            'photo_required' => ['required', 'boolean'],
            'photo_mode' => ['required', 'string', 'in:documentation,face_recognition'],
            'face_service_url' => ['nullable', 'url', 'max:500'],
            'face_similarity_threshold' => ['required', 'integer', 'between:1,100'],
            'liveness_check_enabled' => ['required', 'boolean'],
            'max_face_attempts' => ['required', 'integer', 'min:1', 'max:10'],
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
            'photo_required.required' => 'Pengaturan foto wajib wajib diisi.',
            'photo_required.boolean' => 'Pengaturan foto wajib harus berupa boolean.',
            'photo_mode.required' => 'Mode foto wajib diisi.',
            'photo_mode.string' => 'Mode foto harus berupa string.',
            'photo_mode.in' => 'Mode foto harus documentation atau face_recognition.',
            'face_service_url.url' => 'URL layanan face recognition harus berupa URL yang valid.',
            'face_service_url.max' => 'URL layanan face recognition maksimal 500 karakter.',
            'face_similarity_threshold.required' => 'Threshold kesamaan wajah wajib diisi.',
            'face_similarity_threshold.integer' => 'Threshold kesamaan wajah harus berupa angka.',
            'face_similarity_threshold.between' => 'Threshold kesamaan wajah harus antara 1-100.',
            'liveness_check_enabled.required' => 'Pengaturan liveness check wajib diisi.',
            'liveness_check_enabled.boolean' => 'Pengaturan liveness check harus berupa boolean.',
            'max_face_attempts.required' => 'Maksimal percobaan wajah wajib diisi.',
            'max_face_attempts.integer' => 'Maksimal percobaan wajah harus berupa angka.',
            'max_face_attempts.min' => 'Maksimal percobaan wajah minimal 1.',
            'max_face_attempts.max' => 'Maksimal percobaan wajah maksimal 10.',
        ];
    }
}