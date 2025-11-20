# API Documentation - PKL Management Backend

Base URL: `https://simontrapresence.vercel.app`

**Semua endpoint memerlukan header Authorization:**
```
Authorization: Bearer <SUPABASE_ACCESS_TOKEN>
```

---

## 1. Profile

### GET `/api/profile`
Mengambil data profile user yang sedang login. Auto-create profile jika belum ada.

**Headers:**
```
Authorization: Bearer <token>
```

**Response:**
```json
{
  "ok": true,
  "profile": {
    "id": "uuid",
    "full_name": "string",
    "username": "string",
    "avatar_url": "string | null",
    "role": "string",
    "created_at": "timestamp"
  }
}
```

### PUT `/api/profile`
Update data profile user.

**Headers:**
```
Authorization: Bearer <token>
Content-Type: application/json
```

**Request Body:**
```json
{
  "full_name": "string (optional)",
  "username": "string (optional)",
  "avatar_url": "string | null (optional)",
  "role": "string (optional)"
}
```

**Response:**
```json
{
  "ok": true,
  "profile": { ... }
}
```

---

## 2. Attendance (Presensi)

### GET `/api/attendance`
Mengambil daftar presensi user. Support filter tanggal.

**Headers:**
```
Authorization: Bearer <token>
```

**Query Parameters:**
- `start` (optional): Filter mulai tanggal (format: `YYYY-MM-DD`)
- `end` (optional): Filter sampai tanggal (format: `YYYY-MM-DD`)

**Example:**
```
GET /api/attendance?start=2025-11-01&end=2025-11-30
```

**Response:**
```json
{
  "ok": true,
  "attendance": [
    {
      "id": "uuid",
      "profile_id": "uuid",
      "tanggal": "2025-11-19",
      "masuk_at": "timestamp | null",
      "pulang_at": "timestamp | null",
      "status": "masuk" | "pulang",
      "lokasi": "string | null",
      "catatan": "string | null",
      "created_at": "timestamp",
      "attendance_events": [...]
    }
  ]
}
```

### POST `/api/attendance`
Mencatat presensi masuk atau pulang.

**Headers:**
```
Authorization: Bearer <token>
Content-Type: application/json
```

**Request Body:**
```json
{
  "tanggal": "2025-11-19",           // REQUIRED (format: YYYY-MM-DD)
  "status": "masuk" | "pulang",      // REQUIRED
  "timestamp": "2025-11-19T08:00:00Z", // OPTIONAL (default: now)
  "lokasi": "string",                // OPTIONAL
  "catatan": "string"                // OPTIONAL
}
```

**Response:**
```json
{
  "ok": true,
  "attendance": { ... }
}
```

---

## 3. Activities (Kegiatan)

### GET `/api/activities`
Mengambil daftar kegiatan user.

**Headers:**
```
Authorization: Bearer <token>
```

**Query Parameters:**
- `tanggal` (optional): Filter berdasarkan tanggal (format: `YYYY-MM-DD`)

**Example:**
```
GET /api/activities?tanggal=2025-11-19
```

**Response:**
```json
{
  "ok": true,
  "activities": [
    {
      "id": "uuid",
      "profile_id": "uuid",
      "tanggal": "2025-11-19",
      "jam_mulai": "08:00",
      "jam_selesai": "16:00",
      "kegiatan": "string",
      "catatan": "string | null",
      "created_at": "timestamp"
    }
  ]
}
```

### POST `/api/activities`
Membuat kegiatan baru.

**Headers:**
```
Authorization: Bearer <token>
Content-Type: application/json
```

**Request Body:**
```json
{
  "tanggal": "2025-11-19",      // REQUIRED (format: YYYY-MM-DD)
  "jam_mulai": "08:00",         // REQUIRED (format: HH:mm)
  "jam_selesai": "16:00",       // REQUIRED (format: HH:mm)
  "kegiatan": "string",         // REQUIRED
  "catatan": "string"           // OPTIONAL
}
```

**Response:**
```json
{
  "ok": true,
  "activity": { ... }
}
```

### GET `/api/activities/[id]`
Mengambil detail kegiatan berdasarkan ID.

**Headers:**
```
Authorization: Bearer <token>
```

**Response:**
```json
{
  "ok": true,
  "activity": { ... }
}
```

### PUT `/api/activities/[id]`
Update kegiatan.

**Headers:**
```
Authorization: Bearer <token>
Content-Type: application/json
```

**Request Body:**
```json
{
  "tanggal": "2025-11-19",
  "jam_mulai": "08:00",
  "jam_selesai": "16:00",
  "kegiatan": "string",
  "catatan": "string"
}
```

**Response:**
```json
{
  "ok": true,
  "activity": { ... }
}
```

### DELETE `/api/activities/[id]`
Hapus kegiatan.

**Headers:**
```
Authorization: Bearer <token>
```

**Response:**
```json
{
  "ok": true
}
```

---

## 4. Reports (Laporan)

### GET `/api/reports`
Mengambil daftar laporan user.

**Headers:**
```
Authorization: Bearer <token>
```

**Query Parameters:**
- `status` (optional): Filter berdasarkan status (`draft`, `submitted`, `approved`, `rejected`)

**Example:**
```
GET /api/reports?status=draft
```

**Response:**
```json
{
  "ok": true,
  "reports": [
    {
      "id": "uuid",
      "profile_id": "uuid",
      "judul": "string",
      "tanggal": "2025-11-19",
      "isi": "string",
      "status": "draft" | "submitted" | "approved" | "rejected",
      "approved_at": "timestamp | null",
      "approver_id": "uuid | null",
      "created_at": "timestamp",
      "updated_at": "timestamp"
    }
  ]
}
```

### POST `/api/reports`
Membuat laporan baru.

**Headers:**
```
Authorization: Bearer <token>
Content-Type: application/json
```

**Request Body:**
```json
{
  "judul": "string",                    // REQUIRED
  "tanggal": "2025-11-19",              // REQUIRED (format: YYYY-MM-DD)
  "isi": "string",                      // REQUIRED
  "status": "draft" | "submitted"       // OPTIONAL (default: "draft")
}
```

**Response:**
```json
{
  "ok": true,
  "report": { ... }
}
```

### GET `/api/reports/[id]`
Mengambil detail laporan beserta history.

**Headers:**
```
Authorization: Bearer <token>
```

**Response:**
```json
{
  "ok": true,
  "report": {
    ...report_fields...,
    "report_history": [
      {
        "id": "uuid",
        "report_id": "uuid",
        "editor_id": "uuid",
        "isi": "string",
        "status": "string",
        "edited_at": "timestamp"
      }
    ]
  }
}
```

### PUT `/api/reports/[id]`
Update laporan.

**Headers:**
```
Authorization: Bearer <token>
Content-Type: application/json
```

**Request Body:**
```json
{
  "judul": "string",
  "tanggal": "2025-11-19",
  "isi": "string",
  "status": "draft" | "submitted" | "approved" | "rejected"
}
```

**Response:**
```json
{
  "ok": true,
  "report": { ... }
}
```

### DELETE `/api/reports/[id]`
Hapus laporan.

**Headers:**
```
Authorization: Bearer <token>
```

**Response:**
```json
{
  "ok": true
}
```

---

## 5. Schedule (Jadwal)

### GET `/api/schedule`
Mengambil daftar jadwal user.

**Headers:**
```
Authorization: Bearer <token>
```

**Query Parameters:**
- `tanggal` (optional): Filter berdasarkan tanggal (format: `YYYY-MM-DD`)

**Example:**
```
GET /api/schedule?tanggal=2025-11-19
```

**Response:**
```json
{
  "ok": true,
  "schedule": [
    {
      "id": "uuid",
      "profile_id": "uuid",
      "tanggal": "2025-11-19",
      "jam": "08:00" | null,
      "judul": "string",
      "deskripsi": "string | null",
      "created_at": "timestamp"
    }
  ]
}
```

### POST `/api/schedule`
Membuat jadwal baru.

**Headers:**
```
Authorization: Bearer <token>
Content-Type: application/json
```

**Request Body:**
```json
{
  "tanggal": "2025-11-19",      // REQUIRED (format: YYYY-MM-DD)
  "judul": "string",            // REQUIRED
  "jam": "08:00",               // OPTIONAL (format: HH:mm)
  "deskripsi": "string"         // OPTIONAL
}
```

**Response:**
```json
{
  "ok": true,
  "schedule": { ... }
}
```

### PUT `/api/schedule/[id]`
Update jadwal.

**Headers:**
```
Authorization: Bearer <token>
Content-Type: application/json
```

**Request Body:**
```json
{
  "tanggal": "2025-11-19",
  "jam": "08:00",
  "judul": "string",
  "deskripsi": "string"
}
```

**Response:**
```json
{
  "ok": true,
  "schedule": { ... }
}
```

### DELETE `/api/schedule/[id]`
Hapus jadwal.

**Headers:**
```
Authorization: Bearer <token>
```

**Response:**
```json
{
  "ok": true
}
```

---

## 6. Health Check

### GET `/api/health/supabase`
Cek koneksi ke Supabase (tidak perlu auth).

**Response:**
```json
{
  "ok": true,
  "checkedTable": "profiles",
  "rowCount": 1,
  "timestamp": "2025-11-19T14:00:00.000Z"
}
```

---

## 7. Dev/Seed (Development Only)

### POST `/api/dev/seed`
Generate dummy data untuk testing. **Hanya untuk development!**

**Response:**
```json
{
  "ok": true,
  "user": {
    "id": "uuid",
    "email": "demo@student.app"
  },
  "inserts": {
    "attendance": 2,
    "activities": 2,
    "reports": 2
  },
  "note": "Login with demo@student.app / Demo1234! to test."
}
```

---

## Error Response Format

Semua endpoint mengembalikan error dalam format:

```json
{
  "ok": false,
  "message": "Error description"
}
```

**Status Codes:**
- `200` - Success
- `400` - Bad Request (missing/invalid fields)
- `401` - Unauthorized (invalid/missing token)
- `500` - Internal Server Error

---

## Contoh Penggunaan di Postman

1. **Login via Supabase Auth** untuk dapat token:
   ```
   POST https://<project-ref>.supabase.co/auth/v1/token?grant_type=password
   Headers:
     apikey: <NEXT_PUBLIC_SUPABASE_ANON_KEY>
     Content-Type: application/json
   Body:
     {
       "email": "demo@student.app",
       "password": "Demo1234!"
     }
   ```
   Copy `access_token` dari response.

2. **Gunakan token untuk akses API:**
   ```
   POST https://simontrapresence.vercel.app/api/attendance
   Headers:
     Authorization: Bearer <access_token>
     Content-Type: application/json
   Body:
     {
       "tanggal": "2025-11-19",
       "status": "masuk",
       "lokasi": "Kantor Pusat"
     }
   ```

---

## Catatan Penting

- Semua endpoint (kecuali `/api/health/supabase`) memerlukan **Authorization Bearer token** dari Supabase Auth.
- Format tanggal selalu `YYYY-MM-DD`.
- Format waktu selalu `HH:mm` (24-hour format).
- Semua timestamp menggunakan ISO 8601 format.
- User hanya bisa mengakses data miliknya sendiri (filtered by `profile_id`).

