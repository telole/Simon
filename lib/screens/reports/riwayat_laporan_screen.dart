import 'package:flutter/material.dart';
import 'package:kons/core/navigation/page_transitions.dart';
import 'package:kons/screens/reports/detail_laporan_screen.dart';
import 'package:kons/screens/reports/edit_laporan_screen.dart';
import 'package:kons/screens/reports/isi_laporan_screen.dart';
import 'package:kons/screens/reports/widgets/report_bottom_nav.dart';
import 'package:kons/screens/reports/widgets/report_header.dart';
import 'package:kons/core/services/api_service.dart';
import 'package:kons/core/models/report_model.dart';

class RiwayatLaporanScreen extends StatefulWidget {
  const RiwayatLaporanScreen({super.key});

  @override
  State<RiwayatLaporanScreen> createState() => _RiwayatLaporanScreenState();
}

class _RiwayatLaporanScreenState extends State<RiwayatLaporanScreen> {
  final ApiService _apiService = ApiService();
  List<ReportModel> _reports = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadReports();
  }

  Future<void> _loadReports() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final response = await _apiService.getReports();
      if (response['ok'] == true && response['reports'] != null) {
        setState(() {
          _reports = (response['reports'] as List)
              .map((e) => ReportModel.fromJson(e))
              .toList();
        });
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _openForm() async {
    await Navigator.of(context).push(
      SlidePageRoute(page: const IsiLaporanScreen()),
    );
    _loadReports();
  }

  Future<void> _openDetail(ReportModel report, int index) async {
    await Navigator.of(context).push(
      SlidePageRoute(page: DetailLaporanScreen(report: report.toReport())),
    );
    _loadReports();
  }

  Future<void> _openEdit(ReportModel report, int index) async {
    await Navigator.of(context).push(
      SlidePageRoute(
        page: EditLaporanScreen(
          report: report.toReport(),
          reportId: report.id, // Pass the report ID for API update
        ),
      ),
    );
    _loadReports();
  }

  Future<void> _deleteReport(int index) async {
    final report = _reports[index];
    if (!mounted) return;
    final navigatorContext = context;
    showDialog(
      context: navigatorContext,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Hapus laporan'),
        content: const Text('Apakah anda yakin ingin menghapus laporan ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            onPressed: () async {
              Navigator.of(dialogContext).pop();
              final scaffoldMessenger = ScaffoldMessenger.of(navigatorContext);
              try {
                await _apiService.deleteReport(report.id);
                if (mounted) {
                  _loadReports();
                }
              } catch (e) {
                if (mounted) {
                  scaffoldMessenger.showSnackBar(
                    SnackBar(
                      content: Text('Gagal menghapus laporan: ${e.toString()}'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  String _contentPreview(String text) {
    if (text.length <= 60) {
      return text;
    }
    return '${text.substring(0, 60)}...';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF6A5AE0), Color(0xFF8C9EFF)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              ReportHeader(
                title: 'Riwayat Laporan',
                subtitle: 'Ini catatan semua laporan kegiatan selama PKL anda.',
                onBack: () => Navigator.of(context).pop(),
              ),
              Expanded(
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                  child: Container(
                    color: Colors.white,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF6A5AE0), Color(0xFF8C9EFF)],
                              ),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                padding: const EdgeInsets.symmetric(vertical: 16),
                              ),
                              onPressed: _openForm,
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.add, color: Colors.white),
                                  SizedBox(width: 8),
                                  Text(
                                    'Tambah Laporan',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: _isLoading
                              ? const Center(child: CircularProgressIndicator())
                              : _error != null
                                  ? Center(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text('Error: $_error', style: const TextStyle(color: Colors.red)),
                                          const SizedBox(height: 16),
                                          ElevatedButton(
                                            onPressed: _loadReports,
                                            child: const Text('Retry'),
                                          ),
                                        ],
                                      ),
                                    )
                                  : _reports.isEmpty
                                      ? const Center(
                                          child: Text('Belum ada laporan', style: TextStyle(color: Colors.grey)),
                                        )
                                      : ListView.builder(
                                          physics: const BouncingScrollPhysics(),
                                          padding: const EdgeInsets.symmetric(horizontal: 20),
                                          itemCount: _reports.length,
                                          itemBuilder: (context, index) {
                                            final report = _reports[index];
                                    return Container(
                                      margin: const EdgeInsets.only(bottom: 16),
                                      padding: const EdgeInsets.all(18),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(20),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.08),
                                            spreadRadius: 1,
                                            blurRadius: 10,
                                            offset: const Offset(0, 4),
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFE3F2FD),
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            child: const Text(
                                              'Laporan',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black87,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 16),
                                          Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    _InfoRow(
                                                      icon: Icons.edit,
                                                      label: 'Judul',
                                                      value: report.judul,
                                                    ),
                                                    const SizedBox(height: 10),
                                                    _InfoRow(
                                                      icon: Icons.calendar_today,
                                                      label: 'Tanggal',
                                                      value: report.formattedTanggal,
                                                    ),
                                                    const SizedBox(height: 10),
                                                    _InfoRow(
                                                      icon: Icons.description,
                                                      label: 'Isi',
                                                      value: _contentPreview(report.isi),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(width: 12),
                                              Image.asset(
                                                'assets/illustration.png',
                                                width: 70,
                                                height: 70,
                                                fit: BoxFit.contain,
                                                errorBuilder: (context, error, stackTrace) {
                                                  return const Icon(Icons.description, size: 60, color: Colors.grey);
                                                },
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 18),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: _ActionButton(
                                                  label: 'Buka',
                                                  color: const Color(0xFF6A5AE0),
                                                  onPressed: () => _openDetail(report, index),
                                                ),
                                              ),
                                              const SizedBox(width: 10),
                                              Expanded(
                                                child: _ActionButton(
                                                  label: 'Edit',
                                                  color: Colors.orange,
                                                  onPressed: () => _openEdit(report, index),
                                                ),
                                              ),
                                              const SizedBox(width: 10),
                                              Expanded(
                                                child: _ActionButton(
                                                  label: 'Hapus',
                                                  color: Colors.red,
                                                  onPressed: () => _deleteReport(index),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: buildReportBottomNav(context, currentIndex: 2),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: Colors.black54),
        const SizedBox(width: 6),
        Text(
          '$label : ',
          style: const TextStyle(fontSize: 14, color: Colors.black87),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onPressed;

  const _ActionButton({
    required this.label,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 42,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}


