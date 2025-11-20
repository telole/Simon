import 'package:kons/screens/reports/models/report.dart' as old_report;

class ReportModel {
  final String id;
  final String profileId;
  final String judul;
  final String tanggal;
  final String isi;
  final String status;
  final DateTime? approvedAt;
  final String? approverId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<dynamic>? reportHistory;

  ReportModel({
    required this.id,
    required this.profileId,
    required this.judul,
    required this.tanggal,
    required this.isi,
    required this.status,
    this.approvedAt,
    this.approverId,
    required this.createdAt,
    required this.updatedAt,
    this.reportHistory,
  });

  factory ReportModel.fromJson(Map<String, dynamic> json) {
    return ReportModel(
      id: json['id'] as String,
      profileId: json['profile_id'] as String,
      judul: json['judul'] as String,
      tanggal: json['tanggal'] as String,
      isi: json['isi'] as String,
      status: json['status'] as String,
      approvedAt: json['approved_at'] != null 
          ? DateTime.parse(json['approved_at'] as String) 
          : null,
      approverId: json['approver_id'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      reportHistory: json['report_history'] as List<dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'profile_id': profileId,
      'judul': judul,
      'tanggal': tanggal,
      'isi': isi,
      'status': status,
      'approved_at': approvedAt?.toIso8601String(),
      'approver_id': approverId,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
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

  // Convert to old Report model for compatibility
  old_report.Report toReport() {
    return old_report.Report(
      title: judul,
      date: formattedTanggal,
      content: isi,
    );
  }
}

