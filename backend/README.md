# Smart Presence Backend - Laravel API

Backend API untuk aplikasi Smart Presence menggunakan Laravel dengan autentikasi Sanctum.

## Fitur

- Autentikasi pengguna dengan Laravel Sanctum
- Manajemen absensi siswa
- Pengenalan wajah dengan penyimpanan embedding
- API RESTful untuk komunikasi dengan aplikasi Flutter

## Persyaratan

- PHP >= 8.1
- Composer
- MySQL/MariaDB
- Laravel 10.x

## Instalasi

1. Clone repository ini
2. Masuk ke direktori backend: `cd backend`
3. Install dependencies: `composer install`
4. Copy file environment: `cp .env.example .env`
5. Generate application key: `php artisan key:generate`

## Konfigurasi Database

Edit file `.env`:

```env
DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=smart_presence
DB_USERNAME=root
DB_PASSWORD=
```

## Menjalankan Migrasi

```bash
php artisan migrate
```

## Menjalankan Server

```bash
php artisan serve
```

Server akan berjalan di `http://localhost:8000`

## API Endpoints

### Authentication
- `POST /api/auth/register` - Registrasi pengguna baru
- `POST /api/auth/login` - Login pengguna
- `POST /api/auth/logout` - Logout pengguna

### Attendance
- `POST /api/attendance` - Tandai kehadiran
- `GET /api/attendance/{userId}` - Riwayat kehadiran pengguna
- `GET /api/attendance` - Semua data kehadiran (admin)

### Face Recognition
- `POST /api/faces/embedding` - Upload embedding wajah
- `GET /api/faces/{userId}` - Data wajah pengguna
- `POST /api/faces/recognize` - Kenali wajah

## Struktur Database

### Users Table
- id (primary key)
- name
- email (unique)
- password (hashed)
- role (admin/student)
- nim (nullable)
- class (nullable)
- timestamps

### Attendances Table
- id (primary key)
- user_id (foreign key)
- date
- time
- status (present/absent/late)
- timestamps

### Faces Table
- id (primary key)
- user_id (foreign key)
- image_path
- embedding (JSON)
- timestamps

## Testing API

Gunakan tools seperti Postman atau cURL untuk testing API endpoints.

Contoh request login:
```bash
curl -X POST http://localhost:8000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"admin@example.com","password":"password"}'
```

## Storage

File gambar wajah disimpan di `storage/app/public/faces/`. Jalankan:
```bash
php artisan storage:link
```

## Security

- Password di-hash menggunakan bcrypt
- Autentikasi menggunakan Laravel Sanctum tokens
- Validasi input pada semua endpoints
- Rate limiting untuk mencegah abuse

## Error Handling

API mengembalikan response JSON dengan format:
```json
{
  "message": "Error description",
  "errors": {...}
}
```

Status codes:
- 200: Success
- 201: Created
- 401: Unauthorized
- 422: Validation Error
- 500: Server Error