class Schedule {
  final String id;
  final String profileId;
  final String tanggal;
  final String? jam;
  final String judul;
  final String? deskripsi;
  final DateTime createdAt;

  Schedule({
    required this.id,
    required this.profileId,
    required this.tanggal,
    this.jam,
    required this.judul,
    this.deskripsi,
    required this.createdAt,
  });

  factory Schedule.fromJson(Map<String, dynamic> json) {
    return Schedule(
      id: json['id'] as String,
      profileId: json['profile_id'] as String,
      tanggal: json['tanggal'] as String,
      jam: json['jam'] as String?,
      judul: json['judul'] as String,
      deskripsi: json['deskripsi'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'profile_id': profileId,
      'tanggal': tanggal,
      'jam': jam,
      'judul': judul,
      'deskripsi': deskripsi,
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
}

