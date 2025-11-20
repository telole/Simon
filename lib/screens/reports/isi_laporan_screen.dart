import 'package:flutter/material.dart';
import 'package:kons/core/widgets/success_popup.dart';
import 'package:kons/screens/reports/widgets/report_bottom_nav.dart';
import 'package:kons/screens/reports/widgets/report_header.dart';
import 'package:kons/screens/reports/widgets/report_input_field.dart';
import 'package:kons/core/services/api_service.dart';
import 'package:intl/intl.dart';

class IsiLaporanScreen extends StatefulWidget {
  const IsiLaporanScreen({super.key});

  @override
  State<IsiLaporanScreen> createState() => _IsiLaporanScreenState();
}

class _IsiLaporanScreenState extends State<IsiLaporanScreen> {
  final _formKey = GlobalKey<FormState>();
  final _judulController = TextEditingController();
  final _tanggalController = TextEditingController();
  final _isiController = TextEditingController();
  final ApiService _apiService = ApiService();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _tanggalController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
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

    setState(() {
      _isLoading = true;
    });

    try {
      await _apiService.createReport({
        'judul': _judulController.text.trim(),
        'tanggal': _tanggalController.text.trim(),
        'isi': _isiController.text.trim(),
        'status': 'draft',
      });

      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          barrierColor: Colors.black.withOpacity(0.5),
          builder: (context) => SuccessPopup(
            title: 'Laporan berhasil tersimpan',
            onContinue: () {
              Navigator.of(context).pop(); // close dialog
              Navigator.of(context).pop(); // go back
            },
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal menyimpan laporan: ${e.toString()}'),
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
                title: 'Laporan',
                subtitle: 'Silahkan buat laporan aktivitas PKL anda dengan baik.',
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
                              hintText: '19/09/2025',
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
                                        'Simpan',
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


