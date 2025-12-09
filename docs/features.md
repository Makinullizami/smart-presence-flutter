# Daftar Fitur Aplikasi Smart Presence (Absen Cerdas)

## 1. Deskripsi Singkat Aplikasi

Smart Presence adalah aplikasi mobile berbasis Flutter yang dirancang untuk sistem absensi otomatis menggunakan teknologi pengenalan wajah. Aplikasi ini menggunakan backend Laravel untuk API dan penyimpanan data, dengan integrasi ML Kit untuk deteksi wajah secara real-time pada perangkat mobile.

Aplikasi ini memanfaatkan teknologi kecerdasan buatan untuk mendeteksi dan mengenali wajah siswa secara otomatis, sehingga proses absensi menjadi lebih efisien dan akurat. Sistem menggunakan embedding wajah untuk identifikasi siswa, dengan backend yang menyimpan data embedding dan melakukan pencocokan wajah untuk validasi kehadiran.

## 2. Role Pengguna & Kebutuhan

### User (Karyawan / Mahasiswa / Siswa)
- Absen masuk & pulang
- Lihat histori absensi
- Ajukan izin / cuti / sakit
- Lihat jadwal & pengumuman
- Dapat notifikasi pengingat absensi

### Dosen / Guru / Supervisor / Atasan Langsung
- Verifikasi kehadiran kelas/tim
- Lihat daftar hadir per kelas / tim
- Input catatan (misal: terlambat, pulang cepat)
- Approve / reject izin tim

### Admin / HR / TU / Bagian Akademik
- Kelola data user, kelas, divisi, jadwal
- Mengatur aturan absensi (shift, jam fleksibel, lokasi geofence)
- Menarik laporan (harian, mingguan, bulanan)
- Export ke Excel / PDF
- Integrasi dengan sistem lain (HRIS, e-learning, payroll)

## 3. Fitur-Fitur Utama (Level Kompleks)

### 3.1. Fitur Login & Keamanan

**Login via:**
- Email + Password / NIM + Password
- Single Sign-On (SSO) (opsional: Google / akun kampus / akun kantor)
- 2FA / OTP (opsional, via email / WhatsApp / SMS)

**Manajemen sesi:**
- Auto logout bila idle terlalu lama
- Deteksi login ganda (device berbeda)

### 3.2. Fitur Absensi Pintar (Smart Check-In / Check-Out)

**Metode Absensi Kombinasi**
Bisa dikombinasikan sesuai kebijakan instansi:

📍 GPS + Geofence (hanya bisa absen di area tertentu)

📶 WiFi / MAC Address kantor / kampus

🔳 Scan QR Code di ruangan / lokasi tertentu

🤳 Face Recognition + Liveness (pakai kamera depan)

**Logika Validasi Absensi**

**Deteksi:**
- Terlambat
- Pulang cepat
- Tidak hadir

**Validasi:**
- Lokasi di dalam geofence
- Jam absensi sesuai jadwal / shift
- Wajah cocok dengan database (kalau pakai face recognition)

**Menolak absensi bila:**
- Lokasi di luar jangkauan
- Jaringan / GPS dimanipulasi (opsional: deteksi mock location)

**Mode Offline (Opsional tapi Keren)**

Jika tidak ada koneksi internet:
- Data absen disimpan lokal (encrypted)
- Dikirim otomatis ketika online
- Menandai absen sebagai "offline sync" di backend

### 3.3. Fitur Manajemen Jadwal & Shift

**Admin dapat membuat:**
- Jadwal kuliah / mata pelajaran per kelas
- Jadwal shift kerja (pagi, siang, malam)
- Jadwal khusus (event, rapat, UTS/UAS, lembur)

**Pengaturan:**
- Jam toleransi keterlambatan (misal 10 menit)
- Aturan absensi minimum (misal >75% untuk ikut ujian)

**User dapat melihat:**
- Jadwal hari ini
- Jadwal minggu ini
- Notifikasi kalau ada perubahan jadwal

### 3.4. Fitur Izin, Cuti, & Sakit (Request & Approval)

**User dapat:**
- Ajukan izin tidak masuk
- Ajukan cuti (untuk karyawan)
- Ajukan sakit (upload bukti seperti surat dokter)

**Flow:**
- User mengisi form (tanggal, alasan, lampiran)
- Masuk ke antrian approval atasan

**Status:**
- Pending, Disetujui, Ditolak

**Notifikasi otomatis ke:**
- User (hasil persetujuan)
- Admin / HR / TU

### 3.5. Fitur Dashboard Mini di Mobile

Di aplikasi mobile, khususnya untuk role supervisor / dosen / guru:

**Lihat:**
- Siapa saja yang sudah absen hari ini
- Siapa yang belum absen / terlambat
- Rekap ringkas satu kelas / satu tim

**Bisa langsung:**
- Tandai kehadiran manual (mis: kalau HP mahasiswa rusak)
- Beri catatan kehadiran (alasan terlambat, dll)

### 3.6. Fitur Laporan & Rekap (Mobile View)

**Rekap Pribadi (untuk User/Siswa/Karyawan):**
- Grafik kehadiran (hadir, izin, sakit, alfa)
- Total keterlambatan per bulan
- Persentase kehadiran bulanan
- Riwayat absensi dengan filter periode

**Rekap Supervisor:**
- Rekap per tim / kelas yang diampu
- Persentase kehadiran kelompok
- Daftar siswa/karyawan dengan status kehadiran
- Laporan keterlambatan per kelas/tim

### 3.7. Fitur Notifikasi & Reminder

**Push Notification:**
- Pengingat jam masuk (misal 10 menit sebelum waktu absensi)
- Pengingat jam pulang (opsional)
- Izin disetujui / ditolak
- Pengumuman penting (rapat, perubahan jadwal, dll)

**In-app Notification:**
- Riwayat notifikasi di dalam aplikasi
- Status baca/belum baca
- Kategori notifikasi (reminder, approval, announcement)
- Notifikasi real-time saat aplikasi terbuka

### 3.8. Fitur Pengumuman & Informasi

**Admin/guru dapat kirim pengumuman:**
- Per kelas (khusus untuk siswa tertentu)
- Per divisi / departemen (khusus untuk karyawan tertentu)
- Global (semua pengguna sistem)

**User dapat:**
- Membaca list pengumuman dengan pagination
- Filter berdasarkan kategori (akademik, umum, urgent)
- Filter berdasarkan tanggal publikasi
- Mark as read/unread untuk tracking
- Search pengumuman berdasarkan keyword

### 3.9. Fitur Pengaturan Profil & Device Binding

**Manajemen Profil Lengkap:**
- Edit informasi pribadi (nama, email, nomor telepon, alamat)
- Update data pribadi (tanggal lahir, jenis kelamin, bio)
- Pengaturan kontak darurat (nama dan nomor telepon)
- Upload dan update foto profil
- Pengaturan preferensi (bahasa, tema aplikasi)

**Keamanan Akun:**
- Ubah password dengan verifikasi password lama
- Pengaturan notifikasi (reminder absensi, pengumuman, dll)
- Riwayat login dan aktivitas akun

**Manajemen Perangkat:**
- Daftar perangkat yang terhubung ke akun
- Batas maksimal perangkat aktif (2 perangkat)
- Verifikasi perangkat baru via email/OTP
- Hapus perangkat yang tidak digunakan
- Deteksi login ganda dari device berbeda
- Informasi detail perangkat (nama, OS, versi app, IP address)

**Fitur Tambahan:**
- Backup dan restore pengaturan
- Export data profil
- Two-factor authentication (2FA) opsional
- Session management otomatis

## 5. Fitur-Fitur Untuk Role SISWA

### 5.1. Login & Autentikasi
- Siswa dapat login menggunakan email dan password yang telah terdaftar
- Validasi input dengan pesan error yang jelas untuk field yang kosong
- Sistem menggunakan token authentication (Laravel Sanctum) untuk keamanan
- Pesan error informatif jika login gagal (password salah, email tidak terdaftar)
- Opsi "Lupa Password" untuk reset password (opsional)

### 5.2. Registrasi Wajah (Face Enrollment)
- Akses halaman registrasi wajah setelah login pertama kali
- Menggunakan kamera perangkat untuk mengambil foto wajah
- ML Kit secara real-time mendeteksi posisi wajah dalam frame kamera
- Sistem memotong (crop) wajah dari gambar asli secara otomatis
- Embedding wajah dikirim ke backend Laravel untuk penyimpanan
- Backend menyimpan embedding wajah dalam format JSON di database
- Konfirmasi berhasil dengan notifikasi dan preview gambar wajah

### 5.3. Melakukan Absensi
- Siswa membuka halaman absensi dengan kamera aktif secara otomatis
- Sistem mendeteksi wajah secara real-time menggunakan ML Kit
- Bounding box hijau menunjukkan area wajah yang terdeteksi
- Sistem mengirim embedding wajah ke backend untuk pencocokan
- Backend membandingkan embedding dengan data siswa terdaftar
- Jika cocok (similarity score > threshold), status "Hadir" dicatat otomatis
- Jika wajah tidak cocok, tampil pesan "Wajah tidak dikenali"
- Notifikasi berhasil dengan suara dan animasi
- Timestamp otomatis berdasarkan waktu server

### 5.4. Lihat Riwayat Absensi
- Tabel riwayat absensi dengan filter harian/mingguan/bulanan
- Menampilkan kolom: Tanggal, Jam Masuk, Status (Hadir/Telat/Tidak Hadir)
- Status "Telat" jika absensi setelah jam 08:00 pagi
- Statistik persentase kehadiran bulanan
- Export riwayat ke PDF (opsional)
- Indikator warna: Hijau (Hadir), Orange (Telat), Merah (Tidak Hadir)

### 5.5. Edit Profil Siswa
- Mengubah data nama lengkap siswa
- Update informasi kelas dan NIM
- Upload ulang foto profil (bukan wajah untuk absensi)
- Upload ulang data wajah jika diperlukan (opsional)
- Validasi input dengan pesan error yang jelas
- Konfirmasi perubahan dengan dialog

### 5.6. Logout
- Tombol logout di menu profil atau app bar
- Konfirmasi logout dengan dialog "Yakin ingin keluar?"
- Menghapus token authentication dari penyimpanan lokal
- Redirect otomatis ke halaman login
- Clear semua data session

## 6. Fitur-Fitur Untuk Role DOSEN/GURU/SUPERVISOR

### 6.1. Login Dosen/Guru/Supervisor
- Akses halaman login khusus dosen/guru/supervisor
- Login menggunakan akun yang telah terdaftar di sistem
- Redirect otomatis ke dashboard dosen/guru/supervisor setelah login berhasil
- Session management dengan token authentication

### 6.2. Verifikasi Kehadiran Kelas/Tim
- Halaman list kelas/tim yang diampu
- Tampilan real-time status kehadiran siswa/karyawan
- Verifikasi absensi masuk dan pulang
- Filter berdasarkan tanggal dan kelas/tim

### 6.3. Lihat Daftar Hadir per Kelas/Tim
- Tabel daftar hadir dengan nama, waktu masuk, waktu pulang
- Status kehadiran: Hadir, Telat, Tidak Hadir
- Export daftar hadir ke PDF
- Statistik kehadiran per kelas/tim

### 6.4. Input Catatan Absensi
- Tambah catatan untuk siswa/karyawan (terlambat, pulang cepat, dll)
- Edit catatan existing
- Validasi input catatan
- Notifikasi perubahan catatan

### 6.5. Approve/Reject Izin Tim
- Halaman list permohonan izin/cuti/sakit dari tim
- Approve atau reject permohonan dengan alasan
- Notifikasi ke siswa/karyawan terkait status permohonan
- Riwayat approve/reject izin

### 6.6. Logout Dosen/Guru/Supervisor
- Logout dengan konfirmasi
- Clear session
- Redirect ke halaman login

## 7. Fitur-Fitur Lengkap Untuk Role ADMIN

### 7.1. Dashboard Admin Utama
- **Real-time Analytics Dashboard:**
  - Total users aktif hari ini
  - Persentase kehadiran keseluruhan
  - Jumlah izin pending approval
  - Status sistem (server, database, API)
  - Quick actions untuk tugas-tugas penting

- **Widget Dashboard:**
  - Grafik kehadiran harian/mingguan/bulanan
  - Top 5 karyawan/siswa paling disiplin
  - Alert untuk absensi abnormal
  - Pengumuman terbaru
  - Aktivitas sistem real-time

### 7.2. Manajemen User Lengkap
- **CRUD Operations untuk semua tipe user:**
  - Karyawan, Mahasiswa/Siswa, Supervisor, Admin
  - Bulk import dari Excel/CSV
  - Bulk export data user
  - Advanced search & filtering

- **User Profile Management:**
  - Edit informasi lengkap (nama, email, kontak, alamat)
  - Assign role & permissions
  - Set supervisor relationship
  - Device binding management
  - Password reset & recovery

- **User Groups & Departments:**
  - Create & manage departments/divisions
  - Assign users ke multiple groups
  - Hierarchical organization structure
  - Department-wise reporting

### 7.3. Sistem Absensi Canggih
- **Konfigurasi Metode Absensi:**
  - GPS Geofencing (set radius, multiple locations)
  - WiFi/MAC Address whitelisting
  - QR Code generation & management
  - Face Recognition settings (threshold, liveness detection)
  - Offline mode configuration

- **Aturan Absensi Dinamis:**
  - Shift & schedule management
  - Flexible working hours
  - Tolerance settings (late arrival, early departure)
  - Holiday & special event handling
  - Auto-approval rules

- **Real-time Monitoring:**
  - Live attendance tracking
  - Location validation logs
  - Device verification status
  - Suspicious activity detection

### 7.4. Manajemen Jadwal & Shift
- **Schedule Management:**
  - Create class schedules (mata pelajaran, dosen, ruangan)
  - Work shift scheduling (pagi, siang, malam, custom)
  - Special events (UTS, UAS, rapat, lembur)
  - Recurring schedule templates

- **Advanced Scheduling:**
  - Conflict detection & resolution
  - Bulk schedule operations
  - Schedule templates & cloning
  - Calendar integration (Google Calendar, Outlook)

- **Schedule Analytics:**
  - Utilization reports
  - Conflict analysis
  - Attendance correlation with schedules

### 7.5. Sistem Izin & Approval Workflow
- **Leave Request Management:**
  - Multiple leave types (cuti, sakit, izin, emergency)
  - Approval workflow (berjenjang/multi-level)
  - Auto-approval rules
  - Leave balance tracking

- **Approval Dashboard:**
  - Pending approvals queue
  - Bulk approval actions
  - Approval history & audit trail
  - Escalation rules for stuck approvals

- **Leave Analytics:**
  - Leave utilization reports
  - Peak leave periods
  - Department-wise leave statistics

### 7.6. Sistem Pengumuman & Komunikasi
- **Announcement Management:**
  - Create targeted announcements
  - Schedule announcement publishing
  - Rich text editor dengan media support
  - Announcement templates

- **Communication Tools:**
  - Broadcast notifications ke semua users
  - Group messaging (departemen, kelas)
  - Emergency alert system
  - Announcement analytics (read rates, engagement)

### 7.7. Reporting & Analytics Canggih
- **Comprehensive Reports:**
  - Daily/Weekly/Monthly attendance reports
  - Department-wise analytics
  - Individual performance tracking
  - Trend analysis & forecasting

- **Advanced Analytics:**
  - Predictive attendance modeling
  - Anomaly detection (sudden absence spikes)
  - Comparative analysis (year-over-year)
  - Custom report builder

- **Export & Integration:**
  - Multiple export formats (PDF, Excel, CSV)
  - Scheduled report delivery
  - API access untuk third-party integration
  - Dashboard embedding untuk web portals

### 7.8. Face Recognition Management
- **Face Database Administration:**
  - Bulk face enrollment
  - Face quality validation
  - Duplicate detection & merging
  - Face backup & recovery

- **ML Model Management:**
  - Face recognition threshold tuning
  - Model performance monitoring
  - Anti-spoofing configuration
  - Liveness detection settings

### 7.9. Device & Security Management
- **Device Management:**
  - Device registration & verification
  - Device blacklisting/whitelisting
  - Device activity monitoring
  - Remote device management

- **Security Settings:**
  - Multi-factor authentication (2FA)
  - Session management & timeout
  - IP whitelisting
  - Audit logging & compliance

### 7.10. System Configuration & Integration
- **System Settings:**
  - Global configuration management
  - Environment-specific settings
  - Feature toggles
  - Performance optimization

- **Third-party Integrations:**
  - HRIS systems (SAP, Workday, etc.)
  - Learning Management Systems
  - Payroll systems
  - Calendar systems
  - Notification services (email, SMS, push)

- **API Management:**
  - RESTful API documentation
  - API key management
  - Rate limiting & throttling
  - Webhook configuration

### 7.11. Backup & Disaster Recovery
- **Automated Backup:**
  - Database backup scheduling
  - File storage backup
  - Configuration backup
  - Point-in-time recovery

- **Disaster Recovery:**
  - Failover configuration
  - Data replication
  - Emergency procedures
  - Business continuity planning

### 7.12. User Support & Help Desk
- **Admin Help System:**
  - Built-in documentation
  - Video tutorials
  - FAQ & troubleshooting guides
  - Support ticket system

- **User Training:**
  - Onboarding materials
  - Training modules
  - User adoption analytics
  - Feedback collection

### 7.13. Performance Monitoring & Optimization
- **System Monitoring:**
  - Server performance metrics
  - API response times
  - Database query performance
  - User activity analytics

- **Optimization Tools:**
  - Cache management
  - Database optimization
  - CDN configuration
  - Load balancing

### 7.14. Compliance & Audit
- **Compliance Management:**
  - GDPR compliance tools
  - Data retention policies
  - Privacy settings
  - Consent management

- **Audit Trail:**
  - Complete activity logging
  - Change tracking
  - Compliance reporting
  - Forensic analysis tools

### 7.15. Advanced Features & Customization
- **Workflow Automation:**
  - Custom approval workflows
  - Automated notifications
  - Scheduled tasks
  - Business rule engine

- **Customization Options:**
  - UI theming & branding
  - Custom fields & forms
  - Workflow customization
  - Report customization

### 7.16. Login & Session Management
- **Advanced Authentication:**
  - SSO integration (Google, Microsoft, SAML)
  - Multi-factor authentication
  - Biometric authentication
  - Social login options

- **Session Security:**
  - Session timeout configuration
  - Concurrent session limits
  - Device tracking
  - Suspicious activity detection

### 7.17. Logout & Security
- **Secure Logout:**
  - Complete session cleanup
  - Token invalidation
  - Device logout
  - Audit logging

- **Security Monitoring:**
  - Failed login attempts tracking
  - Security incident alerts
  - Compliance monitoring
  - Threat detection

## 8. Fitur AI yang Digunakan

### 8.1. Face Detection (ML Kit – On Device)
- Deteksi real-time posisi wajah dalam frame kamera
- Bounding box hijau mengelilingi wajah terdeteksi
- Landmark detection untuk mata, hidung, dan mulut
- Face tracking untuk mengikuti pergerakan wajah
- Confidence score untuk akurasi deteksi
- Multiple face detection dalam satu frame

### 8.2. Face Embedding (Backend Processing)
- Konversi gambar wajah menjadi vektor numerik 128-dimensi
- Penyimpanan embedding dalam format JSON di database
- Pencocokan wajah menggunakan cosine similarity
- Threshold konfigurasi untuk menentukan kecocokan
- Batch processing untuk embedding massal
- Optimisasi performa dengan indexing

## 9. Arsitektur Singkat Sistem

Aplikasi Smart Presence menggunakan arsitektur client-server dengan Flutter sebagai frontend mobile dan web, Laravel sebagai backend API, serta MySQL/MariaDB sebagai database. Sistem ML Kit berjalan on-device untuk face detection real-time, sementara face recognition dan embedding processing dilakukan di backend untuk akurasi dan keamanan. File storage digunakan untuk menyimpan gambar wajah, dengan sistem backup otomatis untuk mencegah kehilangan data.

## 10. Struktur Navigasi Aplikasi

```
Login Page
├── Siswa/Karyawan Login → Dashboard User
│   ├── Profil User → Edit Profil
│   ├── Absensi → Kamera Face Detection → Konfirmasi Absensi
│   ├── Riwayat Absensi → Detail per Tanggal
│   ├── Ajukan Izin → Form Izin/Cuti/Sakit
│   ├── Jadwal & Pengumuman → View Schedule & Announcements
│   └── Notifikasi → Reminder Absensi
│
├── Dosen/Guru/Supervisor Login → Dashboard Supervisor
│   ├── Verifikasi Kehadiran → List Kelas/Tim → Real-time Status
│   ├── Daftar Hadir → View & Export per Kelas/Tim
│   ├── Input Catatan → Add Notes (Terlambat, Pulang Cepat)
│   └── Approve Izin → Review & Approve/Reject Requests
│
└── Admin Login → Dashboard Admin
    ├── Manajemen User → CRUD User → Manajemen Wajah
    ├── Monitoring Absensi → Filter & View → Detail User
    ├── Laporan Absensi → Generate PDF/Excel
    ├── Manajemen Kelas/Divisi → CRUD → Assign User
    ├── Pengaturan Sistem → Konfigurasi Rules → Integrasi Sistem
    └── Pengaturan Absensi → Shift, Geofence, Rules
```

## 11. Daftar Fitur Versi MVP (Minimal)

- ✅ Autentikasi login user (siswa/karyawan), supervisor, dan admin
- ✅ Registrasi wajah user dengan ML Kit
- ✅ Absensi otomatis dengan face recognition
- ✅ Riwayat absensi user harian/mingguan
- ✅ Dashboard supervisor untuk verifikasi kehadiran
- ✅ Dashboard admin untuk monitoring
- ✅ Laporan absensi harian untuk admin
- ✅ Manajemen data user dasar
- ✅ Sistem izin/cuti/sakit dasar

## 12. Fitur Tambahan (Opsional)

- Push notification untuk reminder absensi
- GPS location tracking untuk validasi lokasi
- QR Code sebagai backup method absensi
- Export laporan dalam format PDF dengan chart
- Multi-admin dengan role-based permissions
- Dark mode UI theme
- Offline mode dengan sync otomatis
- Biometric authentication (fingerprint/face unlock)
- Integration dengan sistem akademik sekolah
- Real-time dashboard dengan WebSocket

## 13. Teknologi yang Digunakan

### Frontend (Flutter)
- Framework: Flutter 3.x dengan Dart
- State Management: GetX
- UI Components: Material Design 3
- Camera Integration: camera package
- Face Detection: google_mlkit_face_detection
- HTTP Client: http package
- Local Storage: flutter_secure_storage

### Backend (Laravel)
- Framework: Laravel 10.x dengan PHP 8.1+
- Authentication: Laravel Sanctum
- Database: MySQL/MariaDB
- API: RESTful JSON API
- File Storage: Laravel Storage
- Validation: Laravel Request Validation

### AI/ML
- Face Detection: Google ML Kit (on-device)
- Face Recognition: Cosine Similarity Algorithm
- Embedding Storage: JSON format in database
- Threshold Configuration: Admin adjustable

### Database Schema
- Users table: id, name, email, password, role (user/supervisor/admin), nim, employee_id, class_id, department_id
- Attendances table: id, user_id, date, check_in_time, check_out_time, status, notes, location
- Faces table: id, user_id, image_path, embedding, status
- Classes table: id, name, supervisor_id, department_id
- Departments table: id, name, admin_id
- Appeals table: id, user_id, type (izin/cuti/sakit), start_date, end_date, reason, status, approved_by, approved_at
- Schedules table: id, class_id, day, start_time, end_time, subject
- Announcements table: id, title, content, created_by, target_role, created_at
- Notifications table: id, user_id, title, message, type, read_at

---

## 14. Konsep Struktur Aplikasi Mobile (Arsitektur Frontend)

### 14.1. Layering

#### Presentation Layer (UI)

**Screens / Pages:**
- Login / Register
- Dashboard User
- Halaman Absensi (Check-in/Check-out)
- Histori Absensi
- Izin & Cuti
- Jadwal
- Pengaturan Profil

**Untuk supervisor/admin:**
- Monitoring Kehadiran
- Approval Izin
- Rekap Singkat

**Widget:**
- Card rekap, grafik kecil, list item absensi, dll

#### State Management Layer
**Bisa pakai:**
- Provider / Riverpod / Bloc / GetX (pilih salah satu)

**Contoh modul state:**
- AuthState
- AttendanceState
- ScheduleState
- PermissionRequestState (izin/cuti)
- NotificationState

#### Domain Layer

**Entity / Model (kelas-kelas murni):**
- User, Role
- AttendanceRecord
- Schedule
- PermissionRequest (izin/cuti)
- Announcement

**Use Case / Service Abstraction:**
- LoginUser
- GetTodayAttendanceStatus
- SubmitAttendance
- RequestPermission
- ApprovePermission

#### Data Layer

**Repositories:**
- AuthRepository
- AttendanceRepository
- ScheduleRepository
- PermissionRepository
- NotificationRepository

**Data Source:**
- Remote (REST API / GraphQL)
- Local (SharedPreferences / SQLite / Hive)

**Network:**
- HTTP Client
- Interceptor (untuk token, logging, retry)

#### Core Layer

**Constants:**
- API base URL, route name, dll

**Helpers:**
- Formatter tanggal, validator, dll

**Error handling:**
- Exception class

**Config:**
- Environment dev / prod

---

## 15. Konsep Struktur Sistem Secara Keseluruhan (End-to-End)

### 15.1. Arsitektur Tingkat Tinggi

```
Mobile App (Flutter)
⬇️
API Gateway / Backend Main Service (Laravel / Node / Spring / dll)
⬇️
Database (Relasional: MySQL/PostgreSQL)
⬇️
Service Pendukung:
├── Face Recognition Service (Python/ML, terpisah)
├── Notification Service (Firebase Cloud Messaging)
├── Queue / Worker (RabbitMQ, Redis Queue, dsb)
└── Dashboard Web untuk admin (React/Vue + API yang sama)
```

### 15.2. Modul di Backend

#### Module: Auth & Role Management
- Register (opsional; bisa hanya diinput admin)
- Login, refresh token, logout
- Role & Permission (Admin, HR, Guru, Karyawan, Mahasiswa)

#### Module: User & Profil
- CRUD user, import dari file (Excel)
- Relasi: user–kelas, user–divisi, user–shift

#### Module: Attendance
**Endpoint:**
- `POST /attendance/checkin`
- `POST /attendance/checkout`
- `GET /attendance/history`

**Logika:**
- Hitung telat, pulang cepat
- Simpan lokasi, metode absensi, device ID

#### Module: Schedule & Shift
- CRUD jadwal
- Relasi ke user / kelas / divisi
- Pengaturan waktu & toleransi

#### Module: Permission (Izin / Cuti / Sakit)
- Ajukan izin
- Proses approval berjenjang (atasan → HR/Admin)
- Notifikasi status

#### Module: Announcement
- Admin input pengumuman
- Targeting ke grup tertentu

#### Module: Reporting
**Aggregate data:**
- Rekap per user
- Rekap per kelas/divisi
- Rekap per rentang tanggal
- Export CSV/PDF

#### Module: Notification
- Integrasi FCM
- Queue untuk push notif massal (biar tidak berat)

#### Module: Face Recognition (Opsional Tingkat Lanjut)
**Service terpisah:**
- Endpoint untuk:
  - Register wajah (enrollment)
  - Verify wajah saat absensi
  - Menyimpan embedding wajah (bukan foto mentah) di DB khusus

---

## 16. Alur Kerja (Flow) Absensi Menggunakan Mobile

### 16.1. Flow Absen Masuk (Check-In)

```
User buka aplikasi → Login berhasil → Dashboard
    ↓
Dashboard menampilkan:
├── Jam kerja hari ini (dari schedule)
├── Status kehadiran hari ini
├── Tombol "Absen Masuk" (aktif jika waktu sudah sesuai schedule)
    ↓
User tekan "Absen Masuk"
    ↓
Aplikasi melakukan validasi awal:
├── ✅ GPS Location (cek geofence)
├── ✅ WiFi Connection (jika diperlukan)
├── ✅ Device ID validation
    ↓
Buka kamera untuk face recognition:
├── 📱 ML Kit mendeteksi wajah real-time
├── 🤳 User memposisikan wajah di frame
├── 📸 Auto-capture atau manual capture
    ↓
Kirim data ke backend:
├── user_id, timestamp, location, device_id
├── metode_absensi (face/gps/wifi/qr)
├── face_embedding atau photo_data
    ↓
Backend processing:
├── 🔍 Validasi lokasi (dalam geofence radius)
├── ⏰ Validasi waktu (terlambat/tidak)
├── 👤 Validasi wajah (jika menggunakan ML)
├── 📱 Validasi device (authorized device)
    ↓
Simpan ke database:
├── Tabel attendances: check_in_time, status, location
├── Status: 'present', 'late', notes
    ↓
Response ke mobile app:
├── ✅ Berhasil: "Absen masuk berhasil"
├── ⚠️ Terlambat: "Absen masuk berhasil. Status: Terlambat X menit"
├── ❌ Gagal: "Absen gagal: [alasan]"
    ↓
User mendapat notifikasi:
├── Push notification
├── In-app notification
├── Update dashboard status
```

### 16.2. Flow Absen Pulang (Check-Out)

```
Dashboard menampilkan status "Sudah absen masuk"
Tombol "Absen Pulang" aktif sesuai schedule
    ↓
User tekan "Absen Pulang"
    ↓
Validasi sama seperti check-in:
├── GPS Location validation
├── WiFi validation (jika perlu)
├── Face recognition (opsional)
    ↓
Backend menghitung:
├── Durasi kerja = check_out_time - check_in_time
├── Status pulang: 'on_time', 'early', 'overtime'
├── Validasi tidak boleh pulang terlalu awal
    ↓
Update database:
├── Tabel attendances: check_out_time, duration, final_status
    ↓
Response: "Absen pulang berhasil. Durasi kerja: X jam Y menit"
```

### 16.3. Validasi Detail per Metode

#### GPS + Geofence Validation
```
1. Get current location (latitude, longitude)
2. Calculate distance from office/school center
3. Check if within allowed radius (default: 100m)
4. Validate GPS accuracy (< 50m error)
5. Reject if location spoofed (optional)
```

#### WiFi/MAC Address Validation
```
1. Scan available WiFi networks
2. Check for authorized SSID
3. Validate MAC address whitelist
4. Optional: Signal strength check
```

#### Face Recognition Validation
```
1. Capture face image/video
2. Extract facial features (ML Kit)
3. Compare with enrolled face data
4. Calculate similarity score (> 0.8)
5. Liveness detection (anti-spoofing)
```

#### QR Code Validation
```
1. Scan QR code at location
2. Validate QR content and timestamp
3. Check location proximity to QR
4. One-time use validation
```

### 16.4. Error Handling & Fallback

#### Offline Mode
```
Jika tidak ada internet:
├── Simpan data lokal (encrypted)
├── Queue untuk sync nanti
├── Mark as "offline_pending"
├── Sync otomatis saat online
```

#### Validation Failures
```
Lokasi tidak valid:
├── "Lokasi di luar area kerja"
├── Saran: "Pastikan Anda di area kantor"

Wajah tidak cocok:
├── "Wajah tidak dikenali"
├── "Coba posisikan wajah lebih jelas"

Device tidak authorized:
├── "Device belum terdaftar"
├── "Hubungi admin untuk verifikasi"
```

#### Network Issues
```
Timeout/connection error:
├── Retry mechanism (3x attempts)
├── Fallback to offline mode
├── User notification
```

### 16.5. Real-time Status Updates

#### Dashboard Live Status
```
✅ Sudah Absen Masuk (08:00)
⏰ Belum Absen Pulang
📍 Lokasi: Dalam area kerja
🔋 Battery: 85%
📶 Network: WiFi (Office)
```

#### Push Notifications
```
🔔 "Waktunya absen masuk!" (10 menit sebelum)
🔔 "Absen masuk berhasil - Tepat waktu"
🔔 "Jangan lupa absen pulang!"
🔔 "Absen pulang berhasil - Durasi: 8 jam 30 menit"
```

### 16.6. Admin Monitoring Flow

```
Supervisor/Admin login → Dashboard Monitoring
    ↓
Real-time view:
├── Siapa sudah absen hari ini
├── Siapa terlambat/belum absen
├── Live location tracking (jika enabled)
    ↓
Manual actions:
├── Tandai absen manual (emergency)
├── Beri catatan keterlambatan
├── Approve absen yang bermasalah
    ↓
Reports generation:
├── Daily attendance summary
├── Late arrival statistics
├── Location validation logs
```

---

**Dibuat untuk keperluan tugas kuliah Smart Presence (Absen Cerdas)**
**Teknologi: Flutter + Laravel + ML Kit**
**Tanggal: November 2024**