class Attendance {
  final String id;
  final String profileId;
  final String tanggal;
  final DateTime? masukAt;
  final DateTime? pulangAt;
  final String status;
  final String? lokasi;
  final String? catatan;
  final DateTime createdAt;
  final List<dynamic>? attendanceEvents;

  Attendance({
    required this.id,
    required this.profileId,
    required this.tanggal,
    this.masukAt,
    this.pulangAt,
    required this.status,
    this.lokasi,
    this.catatan,
    required this.createdAt,
    this.attendanceEvents,
  });

  factory Attendance.fromJson(Map<String, dynamic> json) {
    return Attendance(
      id: json['id'] as String,
      profileId: json['profile_id'] as String,
      tanggal: json['tanggal'] as String,
      masukAt: json['masuk_at'] != null 
          ? DateTime.parse(json['masuk_at'] as String) 
          : null,
      pulangAt: json['pulang_at'] != null 
          ? DateTime.parse(json['pulang_at'] as String) 
          : null,
      status: json['status'] as String,
      lokasi: json['lokasi'] as String?,
      catatan: json['catatan'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      attendanceEvents: json['attendance_events'] as List<dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'profile_id': profileId,
      'tanggal': tanggal,
      'masuk_at': masukAt?.toIso8601String(),
      'pulang_at': pulangAt?.toIso8601String(),
      'status': status,
      'lokasi': lokasi,
      'catatan': catatan,
      'created_at': createdAt.toIso8601String(),
    };
  }

  // Helper methods
  String get formattedMasuk {
    if (masukAt == null) return '-';
    return '${masukAt!.hour.toString().padLeft(2, '0')}:${masukAt!.minute.toString().padLeft(2, '0')}';
  }

  String get formattedPulang {
    if (pulangAt == null) return '-';
    return '${pulangAt!.hour.toString().padLeft(2, '0')}:${pulangAt!.minute.toString().padLeft(2, '0')}';
  }

  String get formattedTanggal {
    final parts = tanggal.split('-');
    if (parts.length == 3) {
      return '${parts[2]}/${parts[1]}/${parts[0]}';
    }
    return tanggal;
  }
}

