import 'package:flutter/material.dart';
import 'package:kons/screens/activities/riwayat_kegiatan_screen.dart';
import 'package:kons/core/widgets/success_popup.dart';
import 'package:kons/core/navigation/page_transitions.dart';
import 'package:kons/core/services/api_service.dart';
import 'package:kons/core/models/activity.dart';

class EditKegiatanScreen extends StatefulWidget {
  final Activity kegiatan;
  
  const EditKegiatanScreen({super.key, required this.kegiatan});

  @override
  State<EditKegiatanScreen> createState() => _EditKegiatanScreenState();
}

class _EditKegiatanScreenState extends State<EditKegiatanScreen> {
  final _formKey = GlobalKey<FormState>();
  final ApiService _apiService = ApiService();
  late TextEditingController _tanggalController;
  late TextEditingController _jamMulaiController;
  late TextEditingController _jamSelesaiController;
  late TextEditingController _kegiatanController;
  late TextEditingController _catatanController;
  late String _selectedKegiatan;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _tanggalController = TextEditingController(text: widget.kegiatan.tanggal);
    _jamMulaiController = TextEditingController(text: widget.kegiatan.jamMulai.length > 5 ? widget.kegiatan.jamMulai.substring(0, 5) : widget.kegiatan.jamMulai);
    _jamSelesaiController = TextEditingController(text: widget.kegiatan.jamSelesai.length > 5 ? widget.kegiatan.jamSelesai.substring(0, 5) : widget.kegiatan.jamSelesai);
    _selectedKegiatan = widget.kegiatan.kegiatan;
    _kegiatanController = TextEditingController(text: widget.kegiatan.kegiatan);
    _catatanController = TextEditingController(text: widget.kegiatan.catatan ?? '');
  }

  @override
  void dispose() {
    _tanggalController.dispose();
    _jamMulaiController.dispose();
    _jamSelesaiController.dispose();
    _kegiatanController.dispose();
    _catatanController.dispose();
    super.dispose();
  }

  Future<void> _submitUpdate() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      await _apiService.updateActivity(widget.kegiatan.id, {
        'tanggal': _tanggalController.text.trim(),
        'jam_mulai': _jamMulaiController.text.trim(),
        'jam_selesai': _jamSelesaiController.text.trim(),
        'kegiatan': _kegiatanController.text.trim(),
        'catatan': _catatanController.text.trim().isEmpty ? null : _catatanController.text.trim(),
      });

      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          barrierColor: Colors.black.withOpacity(0.5),
          builder: (context) => SuccessPopup(
            title: 'Kegiatan berhasil Di edit',
            onContinue: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacement(
                SlidePageRoute(page: const RiwayatKegiatanScreen()),
              );
            },
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal mengupdate kegiatan: ${e.toString()}'),
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
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 22),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Edit Kegiatan',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Content
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
                            // Form Kegiatan Card
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
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
                                  ShaderMask(
                                    shaderCallback: (bounds) => const LinearGradient(
                                      colors: [Color(0xFF6A5AE0), Color(0xFF8C9EFF)],
                                    ).createShader(bounds),
                                    child: const Text(
                                      'Form Kegiatan',
                                      style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 24),
                                  
                                  // Tanggal Field
                                  TextFormField(
                                    controller: _tanggalController,
                                    decoration: InputDecoration(
                                      labelText: 'Tanggal',
                                      prefixIcon: const Icon(Icons.calendar_today),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      filled: true,
                                      fillColor: Colors.grey[50],
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter tanggal';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 16),
                                  
                                  // Jam Mulai Field
                                  TextFormField(
                                    controller: _jamMulaiController,
                                    decoration: InputDecoration(
                                      labelText: 'Jam Mulai (HH:mm)',
                                      prefixIcon: const Icon(Icons.access_time),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      filled: true,
                                      fillColor: Colors.grey[50],
                                      hintText: '08:00',
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter jam mulai';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 16),
                                  
                                  // Jam Selesai Field
                                  TextFormField(
                                    controller: _jamSelesaiController,
                                      decoration: InputDecoration(
                                      labelText: 'Jam Selesai (HH:mm)',
                                      prefixIcon: const Icon(Icons.access_time),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      filled: true,
                                      fillColor: Colors.grey[50],
                                      hintText: '16:00',
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter jam selesai';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 16),
                                  
                                  // Catatan Field
                                  TextFormField(
                                    controller: _catatanController,
                                    maxLines: 3,
                                    decoration: InputDecoration(
                                      labelText: 'Catatan (Optional)',
                                      prefixIcon: const Icon(Icons.note),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      filled: true,
                                      fillColor: Colors.grey[50],
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  
                                  // Kegiatan Field
                                  TextFormField(
                                    controller: _kegiatanController,
                                    decoration: InputDecoration(
                                      labelText: 'Kegiatan',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      filled: true,
                                      fillColor: Colors.grey[50],
                                      suffixIcon: Container(
                                        margin: const EdgeInsets.all(8),
                                        padding: const EdgeInsets.symmetric(horizontal: 12),
                                        decoration: BoxDecoration(
                                          color: Colors.green[50],
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: DropdownButton<String>(
                                          value: _selectedKegiatan,
                                          underline: Container(),
                                          isDense: true,
                                          items: ['UI/UX Design', 'Setting AP', 'Desain grafis', 'Maintenance server', 'Pasang Wifi'].map((String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(
                                                value,
                                                style: const TextStyle(fontSize: 12, color: Colors.green),
                                              ),
                                            );
                                          }).toList(),
                                          onChanged: (String? newValue) {
                                            if (newValue != null) {
                                              setState(() {
                                                _selectedKegiatan = newValue;
                                                _kegiatanController.text = newValue;
                                              });
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter kegiatan';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 24),
                                  
                                  // Edit Button
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
                                      onPressed: _isLoading ? null : _submitUpdate,
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
                                        'Edit',
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
    );
  }
}

