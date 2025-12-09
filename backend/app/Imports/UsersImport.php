<?php

namespace App\Imports;

use App\Models\User;
use Illuminate\Support\Facades\Hash;
use Maatwebsite\Excel\Concerns\ToModel;
use Maatwebsite\Excel\Concerns\WithHeadingRow;
use Maatwebsite\Excel\Concerns\WithValidation;

class UsersImport implements ToModel, WithHeadingRow, WithValidation
{
    public function model(array $row)
    {
        return new User([
            'name' => $row['name'],
            'email' => $row['email'],
            'nip_nim' => $row['nip_nim'],
            'phone' => $row['phone'] ?? null,
            'role' => $row['role'],
            'department_id' => $row['department_id'] ?? null,
            'class_id' => $row['class_id'] ?? null,
            'password' => Hash::make($row['password'] ?? 'password123'),
            'is_active' => true,
        ]);
    }

    public function rules(): array
    {
        return [
            'name' => 'required|string|max:255',
            'email' => 'required|email|unique:users,email',
            'nip_nim' => 'required|string|max:50|unique:users,nip_nim',
            'role' => 'required|in:admin,hr,lecturer,employee,student',
            'department_id' => 'nullable|exists:departments,id',
            'class_id' => 'nullable|exists:classes,id',
        ];
    }
}