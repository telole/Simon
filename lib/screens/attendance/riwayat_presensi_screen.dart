import 'package:flutter/material.dart';
import 'package:kons/core/services/api_service.dart';
import 'package:kons/core/models/attendance.dart';

class RiwayatPresensiScreen extends StatefulWidget {
  const RiwayatPresensiScreen({super.key});

  @override
  State<RiwayatPresensiScreen> createState() => _RiwayatPresensiScreenState();
}

class _RiwayatPresensiScreenState extends State<RiwayatPresensiScreen> {
  final ApiService _apiService = ApiService();
  List<Attendance> _presensiList = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadAttendance();
  }

  Future<void> _loadAttendance() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final response = await _apiService.getAttendance();
      if (response['ok'] == true && response['attendance'] != null) {
        setState(() {
          _presensiList = (response['attendance'] as List)
              .map((e) => Attendance.fromJson(e))
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
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Riwayat Presensi',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            'Ini adalah semua riwayat presensi anda selama PKL.',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
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
                                      onPressed: _loadAttendance,
                                      child: const Text('Retry'),
                                    ),
                                  ],
                                ),
                              )
                            : _presensiList.isEmpty
                                ? const Center(
                                    child: Text('Belum ada presensi', style: TextStyle(color: Colors.grey)),
                                  )
                                : ListView.builder(
                                    physics: const BouncingScrollPhysics(),
                                    padding: const EdgeInsets.all(20),
                                    itemCount: _presensiList.length,
                                    itemBuilder: (context, index) {
                                      final presensi = _presensiList[index];
                                      return Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          padding: const EdgeInsets.all(18),
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
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildInfoRow(Icons.person, 'Nama', '-'),
                                    const SizedBox(height: 10),
                                    _buildInfoRow(Icons.calendar_today, 'Tanggal', presensi.formattedTanggal),
                                    const SizedBox(height: 10),
                                    _buildInfoRow(Icons.access_time, 'Masuk', presensi.formattedMasuk),
                                    const SizedBox(height: 10),
                                    _buildInfoRow(Icons.access_time, 'Pulang', presensi.formattedPulang),
                                    const SizedBox(height: 10),
                                    Row(
                                      children: [
                                        const Icon(Icons.help_outline, size: 18, color: Colors.black87),
                                        const SizedBox(width: 6),
                                        const Text(
                                          'Status : ',
                                          style: TextStyle(fontSize: 14, color: Colors.black87),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: presensi.status == 'masuk' 
                                                ? Colors.green[50] 
                                                : Colors.orange[50],
                                            borderRadius: BorderRadius.circular(6),
                                          ),
                                          child: Text(
                                            presensi.status.toUpperCase(),
                                            style: TextStyle(
                                              color: presensi.status == 'masuk' 
                                                  ? Colors.green 
                                                  : Colors.orange,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 12),
                              const Icon(Icons.checklist, size: 60, color: Colors.grey),
                            ],
                          ),
                        );
                      },
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

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.black87),
        const SizedBox(width: 6),
        Text(
          '$label : ',
          style: const TextStyle(fontSize: 14, color: Colors.black87),
        ),
        Text(
          value,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black87),
        ),
      ],
    );
  }
}

