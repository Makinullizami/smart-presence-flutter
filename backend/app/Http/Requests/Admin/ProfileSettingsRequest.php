<?php

namespace App\Http\Requests\Admin;

use Illuminate\Foundation\Http\FormRequest;

class ProfileSettingsRequest extends FormRequest
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
            'institution_name' => ['required', 'string', 'max:255'],
            'institution_logo_path' => ['nullable', 'string', 'max:500'],
            'address' => ['required', 'string', 'max:500'],
            'phone' => ['nullable', 'string', 'max:20', 'regex:/^[\+]?[0-9\-\s\(\)]+$/'],
            'official_email' => ['nullable', 'email', 'max:255'],
            'timezone' => ['required', 'string', 'timezone'],
            'academic_year_active' => ['nullable', 'string', 'max:20'],
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
            'institution_name.required' => 'Nama instansi wajib diisi.',
            'address.required' => 'Alamat instansi wajib diisi.',
            'phone.regex' => 'Format nomor telepon tidak valid.',
            'official_email.email' => 'Format email tidak valid.',
            'timezone.timezone' => 'Timezone tidak valid.',
        ];
    }
}