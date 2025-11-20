class Activity {
  final String id;
  final String profileId;
  final String tanggal;
  final String jamMulai;
  final String jamSelesai;
  final String kegiatan;
  final String? catatan;
  final DateTime createdAt;

  Activity({
    required this.id,
    required this.profileId,
    required this.tanggal,
    required this.jamMulai,
    required this.jamSelesai,
    required this.kegiatan,
    this.catatan,
    required this.createdAt,
  });

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      id: json['id'] as String,
      profileId: json['profile_id'] as String,
      tanggal: json['tanggal'] as String,
      jamMulai: json['jam_mulai'] as String,
      jamSelesai: json['jam_selesai'] as String,
      kegiatan: json['kegiatan'] as String,
      catatan: json['catatan'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'profile_id': profileId,
      'tanggal': tanggal,
      'jam_mulai': jamMulai,
      'jam_selesai': jamSelesai,
      'kegiatan': kegiatan,
      'catatan': catatan,
      'created_at': createdAt.toIso8601String(),
    };
  }

  // Helper methods
  String get formattedTanggal {
    final parts = tanggal.split('-');
    if (parts.length == 3) {
      return '${parts[2]}/${parts[1]}/${parts[0]}';
    }
    return tanggal;
  }

  String get jamRange {
    // Remove seconds if present (HH:mm:ss -> HH:mm)
    final mulai = jamMulai.length > 5 ? jamMulai.substring(0, 5) : jamMulai;
    final selesai = jamSelesai.length > 5 ? jamSelesai.substring(0, 5) : jamSelesai;
    return '$mulai - $selesai';
  }
}

