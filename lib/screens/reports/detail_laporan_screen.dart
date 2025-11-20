import 'package:flutter/material.dart';
import 'package:kons/core/navigation/page_transitions.dart';
import 'package:kons/screens/reports/edit_laporan_screen.dart';
import 'package:kons/screens/reports/models/report.dart';
import 'package:kons/screens/reports/widgets/report_bottom_nav.dart';
import 'package:kons/screens/reports/widgets/report_header.dart';

class DetailLaporanScreen extends StatefulWidget {
  final Report report;

  const DetailLaporanScreen({super.key, required this.report});

  @override
  State<DetailLaporanScreen> createState() => _DetailLaporanScreenState();
}

class _DetailLaporanScreenState extends State<DetailLaporanScreen> {
  late Report _report;

  @override
  void initState() {
    super.initState();
    _report = widget.report;
  }

  Future<void> _openEdit() async {
    final updated = await Navigator.of(context).push<Report>(
      SlidePageRoute(
        page: EditLaporanScreen(report: _report),
      ),
    );

    if (updated != null) {
      setState(() => _report = updated);
    }
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
                title: 'Buka Laporan',
                subtitle: 'Ini adalah detail laporan yang sudah anda buat.',
                onBack: () => Navigator.of(context).pop(_report),
                trailing: IconButton(
                  onPressed: _openEdit,
                  icon: const Icon(Icons.edit, color: Colors.white),
                  tooltip: 'Edit laporan',
                ),
              ),
              Expanded(
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                  child: Container(
                    color: Colors.white,
                    padding: const EdgeInsets.all(20),
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          _DetailTile(
                            label: 'Judul',
                            icon: Icons.edit,
                            value: _report.title,
                          ),
                          const SizedBox(height: 16),
                          _DetailTile(
                            label: 'Tanggal',
                            icon: Icons.calendar_today,
                            value: _report.date,
                          ),
                          const SizedBox(height: 16),
                          _ContentTile(
                            label: 'Isi Laporan',
                            icon: Icons.description,
                            value: _report.content,
                          ),
                        ],
                      ),
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

class _DetailTile extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _DetailTile({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 22, color: Colors.black87),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ContentTile extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _ContentTile({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 22, color: Colors.black87),
              const SizedBox(width: 12),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              height: 1.5,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}


