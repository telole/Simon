import 'package:flutter/material.dart';
import 'package:kons/core/widgets/success_popup.dart';
import 'package:kons/screens/reports/models/report.dart';
import 'package:kons/screens/reports/widgets/report_bottom_nav.dart';
import 'package:kons/screens/reports/widgets/report_header.dart';
import 'package:kons/screens/reports/widgets/report_input_field.dart';
import 'package:kons/core/services/api_service.dart';
import 'package:kons/core/models/report_model.dart';
import 'package:intl/intl.dart';

class EditLaporanScreen extends StatefulWidget {
  final Report report;
  final String? reportId; // Optional: report ID for API update

  const EditLaporanScreen({super.key, required this.report, this.reportId});

  @override
  State<EditLaporanScreen> createState() => _EditLaporanScreenState();
}

class _EditLaporanScreenState extends State<EditLaporanScreen> {
  final _formKey = GlobalKey<FormState>();
  final ApiService _apiService = ApiService();
  late TextEditingController _judulController;
  late TextEditingController _tanggalController;
  late TextEditingController _isiController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Convert date from DD/MM/YYYY to YYYY-MM-DD if needed
    String tanggal = widget.report.date;
    try {
      // Try to parse DD/MM/YYYY format
      final parts = tanggal.split('/');
      if (parts.length == 3) {
        tanggal = '${parts[2]}-${parts[1]}-${parts[0]}';
      }
    } catch (e) {
      // If parsing fails, use as is
    }
    
    _judulController = TextEditingController(text: widget.report.title);
    _tanggalController = TextEditingController(text: tanggal);
    _isiController = TextEditingController(text: widget.report.content);
  }

  @override
  void dispose() {
    _judulController.dispose();
    _tanggalController.dispose();
    _isiController.dispose();
    super.dispose();
  }

  Future<void> _submitReport() async {
    if (!_formKey.currentState!.validate()) return;

    // Check if report ID is available for API update
    if (widget.reportId == null) {
      // If no ID, just update local state (fallback)
      final updatedReport = widget.report.copyWith(
        title: _judulController.text.trim(),
        date: _tanggalController.text.trim(),
        content: _isiController.text.trim(),
      );
      _showSuccessDialog(updatedReport);
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Convert date to YYYY-MM-DD format
      String tanggal = _tanggalController.text.trim();
      try {
        // Try to parse DD/MM/YYYY format
        final parts = tanggal.split('/');
        if (parts.length == 3) {
          tanggal = '${parts[2]}-${parts[1]}-${parts[0]}';
        }
      } catch (e) {
        // If parsing fails, use as is
      }

      await _apiService.updateReport(widget.reportId!, {
        'judul': _judulController.text.trim(),
        'tanggal': tanggal,
        'isi': _isiController.text.trim(),
      });

      if (mounted) {
        final updatedReport = widget.report.copyWith(
          title: _judulController.text.trim(),
          date: _tanggalController.text.trim(),
          content: _isiController.text.trim(),
        );
        
        showDialog(
          context: context,
          barrierDismissible: false,
          barrierColor: Colors.black.withOpacity(0.5),
          builder: (context) => SuccessPopup(
            title: 'Laporan berhasil di edit',
            onContinue: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop(updatedReport);
            },
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal mengupdate laporan: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showSuccessDialog(Report report) {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (context) => SuccessPopup(
        title: 'Laporan berhasil di edit',
        onContinue: () {
          Navigator.of(context).pop();
          Navigator.of(context).pop(report);
        },
      ),
    );
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
                title: 'Edit Laporan',
                subtitle: 'Perbaharui detail laporan anda dengan teliti.',
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
                    padding: const EdgeInsets.all(20),
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ReportInputField(
                              label: 'Judul',
                              icon: Icons.edit,
                              controller: _judulController,
                              hintText: 'UI/UX Design',
                            ),
                            const SizedBox(height: 16),
                            ReportInputField(
                              label: 'Tanggal',
                              icon: Icons.calendar_today,
                              controller: _tanggalController,
                              hintText: '13/09/2025',
                            ),
                            const SizedBox(height: 16),
                            ReportInputField(
                              label: 'Isi Laporan',
                              icon: Icons.description,
                              controller: _isiController,
                              hintText: 'Tuliskan aktivitas secara lengkap...',
                              maxLines: 8,
                            ),
                            const SizedBox(height: 24),
                            Container(
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
                                onPressed: _isLoading ? null : _submitReport,
                                child: _isLoading
                                    ? const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                        ),
                                      )
                                    : const Text(
                                        'Simpan Perubahan',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                              ),
                            ),
                          ],
                        ),
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


