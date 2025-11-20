import 'package:flutter/material.dart';
import 'package:kons/screens/attendance/presensi_screen.dart';
import 'package:kons/core/navigation/page_transitions.dart';
import 'package:kons/screens/auth/login_screen.dart';
import 'package:kons/screens/attendance/riwayat_presensi_screen.dart';
import 'package:kons/screens/activities/riwayat_kegiatan_screen.dart';
import 'package:kons/screens/activities/isi_kegiatan_screen.dart';
import 'package:kons/screens/reports/detail_laporan_screen.dart';
import 'package:kons/screens/reports/riwayat_laporan_screen.dart';
import 'package:kons/screens/messages/pesan_screen.dart';
import 'package:kons/core/services/api_service.dart';
import 'package:kons/core/services/auth_service.dart';
import 'package:kons/core/models/profile.dart';
import 'package:kons/core/models/attendance.dart';
import 'package:kons/core/models/activity.dart';
import 'package:kons/core/models/report_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final ApiService _apiService = ApiService();
  Profile? _profile;
  Attendance? _latestAttendance;
  Activity? _todayActivity;
  ReportModel? _latestReport;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // Load profile
      final profileResponse = await _apiService.getProfile();
      if (profileResponse['ok'] == true) {
        _profile = Profile.fromJson(profileResponse['profile']);
      }

      // Load latest attendance
      final attendanceResponse = await _apiService.getAttendance();
      if (attendanceResponse['ok'] == true && attendanceResponse['attendance'] != null) {
        final attendanceList = (attendanceResponse['attendance'] as List)
            .map((e) => Attendance.fromJson(e))
            .toList();
        if (attendanceList.isNotEmpty) {
          _latestAttendance = attendanceList.first;
        }
      }

      // Load today's activity
      final today = DateTime.now().toIso8601String().split('T')[0];
      final activitiesResponse = await _apiService.getActivities(tanggal: today);
      if (activitiesResponse['ok'] == true && activitiesResponse['activities'] != null) {
        final activitiesList = (activitiesResponse['activities'] as List)
            .map((e) => Activity.fromJson(e))
            .toList();
        if (activitiesList.isNotEmpty) {
          _todayActivity = activitiesList.first;
        }
      }

      // Load latest report
      final reportsResponse = await _apiService.getReports();
      if (reportsResponse['ok'] == true && reportsResponse['reports'] != null) {
        final reportsList = (reportsResponse['reports'] as List)
            .map((e) => ReportModel.fromJson(e))
            .toList();
        if (reportsList.isNotEmpty) {
          _latestReport = reportsList.first;
        }
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

  Future<void> _handleLogout() async {
    await AuthService.logout();
    if (mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        SlidePageRoute(page: const LoginScreen()),
        (route) => false,
      );
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
            colors: [Color(0xFF2C3E50), Color(0xFF34495E)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hi, ${_profile?.fullName ?? 'User'}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Kelola progres PKL anda secara rutin ya!',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.95),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        elevation: 0,
                      ),
                      onPressed: _handleLogout,
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.logout, color: Colors.white, size: 18),
                          SizedBox(width: 6),
                          Text(
                            'Logout',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
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
                                      onPressed: _loadData,
                                      child: const Text('Retry'),
                                    ),
                                  ],
                                ),
                              )
                            : SingleChildScrollView(
                                physics: const BouncingScrollPhysics(),
                                padding: const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Center(
                                      child: Text(
                                        'Home',
                                        style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 24),

                                    // Presensi Card
                                    _buildCard(
                                      title: 'Presensi',
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    _buildInfoRow(Icons.person, 'Nama', _profile?.fullName ?? '-'),
                                                    const SizedBox(height: 10),
                                                    _buildInfoRow(
                                                      Icons.calendar_today,
                                                      'Tanggal',
                                                      _latestAttendance?.formattedTanggal ?? '-',
                                                    ),
                                                    const SizedBox(height: 10),
                                                    _buildInfoRow(
                                                      Icons.access_time,
                                                      'Masuk',
                                                      _latestAttendance?.formattedMasuk ?? '-',
                                                    ),
                                                    const SizedBox(height: 10),
                                                    _buildInfoRow(
                                                      Icons.access_time,
                                                      'Pulang',
                                                      _latestAttendance?.formattedPulang ?? '-',
                                                    ),
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
                                                            color: _latestAttendance?.status == 'masuk'
                                                                ? Colors.green[50]
                                                                : Colors.orange[50],
                                                            borderRadius: BorderRadius.circular(6),
                                                          ),
                                                          child: Text(
                                                            _latestAttendance?.status.toUpperCase() ?? '-',
                                                            style: TextStyle(
                                                              color: _latestAttendance?.status == 'masuk'
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
                                              Image.asset(
                                                'assets/illustration.png',
                                                width: 90,
                                                height: 90,
                                                fit: BoxFit.contain,
                                                errorBuilder: (context, error, stackTrace) {
                                                  return const Icon(Icons.checklist, size: 70, color: Colors.grey);
                                                },
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 16),
                                          Align(
                                            alignment: Alignment.centerRight,
                                            child: GestureDetector(
                                              onTap: () {
                                                Navigator.of(context).push(
                                                  SlidePageRoute(page: const RiwayatPresensiScreen()),
                                                );
                                              },
                                              child: const Text(
                                                'Lihat selengkapnya →',
                                                style: TextStyle(
                                                  color: Color(0xFF1ABC9C),
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    const SizedBox(height: 16),

                                    // Laporan Card
                                    if (_latestReport != null)
                                      _buildCard(
                                        title: 'Laporan',
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      _buildInfoRow(Icons.edit, 'Judul', _latestReport!.judul),
                                                      const SizedBox(height: 10),
                                                      _buildInfoRow(Icons.calendar_today, 'Tanggal', _latestReport!.formattedTanggal),
                                                      const SizedBox(height: 16),
                                                      Container(
                                                        width: double.infinity,
                                                        decoration: BoxDecoration(
                                                          gradient: const LinearGradient(
                                                            colors: [Color(0xFF1ABC9C), Color(0xFF16A085)],
                                                          ),
                                                          borderRadius: BorderRadius.circular(12),
                                                        ),
                                                        child: ElevatedButton(
                                                          style: ElevatedButton.styleFrom(
                                                            backgroundColor: Colors.transparent,
                                                            shadowColor: Colors.transparent,
                                                            shape: RoundedRectangleBorder(
                                                              borderRadius: BorderRadius.circular(12),
                                                            ),
                                                            padding: const EdgeInsets.symmetric(vertical: 12),
                                                          ),
                                                          onPressed: () {
                                                            Navigator.of(context).push(
                                                              SlidePageRoute(
                                                                page: DetailLaporanScreen(report: _latestReport!.toReport()),
                                                              ),
                                                            );
                                                          },
                                                          child: const Text(
                                                            'Buka →',
                                                            style: TextStyle(
                                                              color: Colors.white,
                                                              fontSize: 14,
                                                              fontWeight: FontWeight.bold,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                const SizedBox(width: 12),
                                                const Icon(Icons.description, size: 70, color: Colors.grey),
                                              ],
                                            ),
                                            const SizedBox(height: 16),
                                            Align(
                                              alignment: Alignment.centerRight,
                                              child: GestureDetector(
                                                onTap: () {
                                                  Navigator.of(context).push(
                                                    SlidePageRoute(page: const RiwayatLaporanScreen()),
                                                  );
                                                },
                                                child: const Text(
                                                  'Lihat selengkapnya →',
                                                  style: TextStyle(
                                                    color: Color(0xFF1ABC9C),
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                    if (_latestReport == null) const SizedBox(height: 16),

                                    // Kegiatan hari ini Card
                                    _buildCard(
                                      title: 'Kegiatan hari ini',
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    _buildInfoRow(
                                                      Icons.calendar_today,
                                                      'Tanggal',
                                                      _todayActivity?.formattedTanggal ?? DateTime.now().toIso8601String().split('T')[0],
                                                    ),
                                                    const SizedBox(height: 10),
                                                    _buildInfoRow(
                                                      Icons.access_time,
                                                      'Jam',
                                                      _todayActivity?.jamRange ?? '-',
                                                    ),
                                                    const SizedBox(height: 10),
                                                    _buildInfoRow(
                                                      Icons.edit,
                                                      'Kegiatan',
                                                      _todayActivity?.kegiatan ?? 'Belum ada kegiatan',
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(width: 12),
                                              const Icon(Icons.calendar_today, size: 70, color: Colors.grey),
                                            ],
                                          ),
                                          const SizedBox(height: 16),
                                          Align(
                                            alignment: Alignment.centerRight,
                                            child: GestureDetector(
                                              onTap: () {
                                                Navigator.of(context).push(
                                                  SlidePageRoute(page: const RiwayatKegiatanScreen()),
                                                );
                                              },
                                              child: const Text(
                                                'Lihat selengkapnya →',
                                                style: TextStyle(
                                                  color: Color(0xFF1ABC9C),
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 20),
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
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildCard({required String title, required Widget child}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
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
          // Light blue header tab
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            decoration: const BoxDecoration(
              color: Color(0xFFE0F2F1),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          // White body
          Padding(
            padding: const EdgeInsets.all(18),
            child: child,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: Colors.black87),
        const SizedBox(width: 6),
        Text(
          '$label : ',
          style: const TextStyle(fontSize: 14, color: Colors.black87),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black87),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomNavBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });

          switch (index) {
            case 1:
              Navigator.of(context).push(
                SlidePageRoute(page: const PresensiScreen()),
              );
              break;
          case 2:
            Navigator.of(context).push(
              SlidePageRoute(page: const RiwayatLaporanScreen()),
            );
            break;
            case 3:
              Navigator.of(context).push(
                SlidePageRoute(page: const IsiKegiatanScreen()),
              );
              break;
            case 4:
              Navigator.of(context).push(
                SlidePageRoute(page: const PesanScreen()),
              );
              break;
            default:
              break;
          }
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF1ABC9C),
        unselectedItemColor: Colors.grey[600],
        selectedFontSize: 12,
        unselectedFontSize: 12,
        iconSize: 24,
        elevation: 0,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.checklist_rounded),
            label: 'Presensi',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.description_rounded),
            label: 'Laporan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today_rounded),
            label: 'Kegiatan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message_rounded),
            label: 'Pesan',
          ),
        ],
      ),
    );
  }
}
