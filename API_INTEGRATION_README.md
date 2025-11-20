# API Integration Guide

## Overview
Semua halaman aplikasi SiMontra telah terintegrasi dengan API backend di `https://simontrapresence.vercel.app`.

## Konfigurasi yang Diperlukan

### 1. Supabase Credentials
Edit file `lib/core/services/auth_service.dart` dan ganti nilai default:

```dart
static const String defaultSupabaseUrl = 'https://your-project.supabase.co';
static const String defaultSupabaseAnonKey = 'your-anon-key';
```

Atau set secara dinamis menggunakan:
```dart
await AuthService.setSupabaseCredentials(url, anonKey);
```

### 2. Install Dependencies
Jalankan:
```bash
flutter pub get
```

## Fitur yang Terintegrasi

### ✅ Authentication
- Login dengan Supabase Auth
- Token management (disimpan di SharedPreferences)
- Logout

### ✅ Profile
- Get profile user
- Update profile

### ✅ Attendance (Presensi)
- Get daftar presensi (dengan filter tanggal)
- Create presensi (masuk/pulang)
- Riwayat presensi

### ✅ Activities (Kegiatan)
- Get daftar kegiatan (dengan filter tanggal)
- Create kegiatan baru
- Update kegiatan
- Delete kegiatan
- Riwayat kegiatan

### ✅ Reports (Laporan)
- Get daftar laporan (dengan filter status)
- Create laporan baru
- Get detail laporan
- Update laporan
- Delete laporan
- Riwayat laporan

### ✅ Schedule (Jadwal)
- Get daftar jadwal (dengan filter tanggal)
- Create jadwal baru
- Update jadwal
- Delete jadwal

## Struktur File

### Services
- `lib/core/services/api_service.dart` - API client untuk semua endpoint
- `lib/core/services/auth_service.dart` - Authentication service (Supabase)

### Models
- `lib/core/models/profile.dart` - Profile model
- `lib/core/models/attendance.dart` - Attendance model
- `lib/core/models/activity.dart` - Activity model
- `lib/core/models/report_model.dart` - Report model
- `lib/core/models/schedule.dart` - Schedule model

### Screens yang Diupdate
- `lib/screens/auth/login_screen.dart` - Login dengan Supabase
- `lib/screens/home/home_screen.dart` - Load data dari API
- `lib/screens/attendance/presensi_screen.dart` - Submit presensi
- `lib/screens/attendance/riwayat_presensi_screen.dart` - List presensi
- `lib/screens/activities/isi_kegiatan_screen.dart` - Create kegiatan
- `lib/screens/activities/riwayat_kegiatan_screen.dart` - List kegiatan
- `lib/screens/reports/isi_laporan_screen.dart` - Create laporan
- `lib/screens/reports/riwayat_laporan_screen.dart` - List laporan

## Error Handling
Semua API calls memiliki error handling dengan:
- Loading states
- Error messages
- Retry functionality
- User-friendly error messages

## Catatan Penting

1. **Token Management**: Token disimpan di SharedPreferences dan otomatis ditambahkan ke semua API requests
2. **Date Format**: 
   - Input: `YYYY-MM-DD` untuk tanggal, `HH:mm` untuk waktu
   - Display: `DD/MM/YYYY` untuk tanggal
3. **Authentication**: Semua endpoint (kecuali health check) memerlukan Bearer token
4. **Auto-refresh**: Beberapa screen akan auto-refresh setelah create/update/delete

## Testing

Untuk testing, gunakan akun demo:
- Email: `demo@student.app`
- Password: `Demo1234!`

Atau generate dummy data dengan:
```
POST https://simontrapresence.vercel.app/api/dev/seed
```

## Troubleshooting

1. **401 Unauthorized**: Pastikan token masih valid, coba login ulang
2. **Network Error**: Periksa koneksi internet
3. **Format Error**: Pastikan format tanggal dan waktu sesuai (YYYY-MM-DD, HH:mm)

