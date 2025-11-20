import 'package:flutter/material.dart';
import 'package:kons/screens/activities/isi_kegiatan_screen.dart';
import 'package:kons/screens/activities/edit_kegiatan_screen.dart';
import 'package:kons/core/navigation/page_transitions.dart';
import 'package:kons/core/widgets/main_bottom_nav.dart';
import 'package:kons/core/services/api_service.dart';
import 'package:kons/core/models/activity.dart';

class RiwayatKegiatanScreen extends StatefulWidget {
  const RiwayatKegiatanScreen({super.key});

  @override
  State<RiwayatKegiatanScreen> createState() => _RiwayatKegiatanScreenState();
}

class _RiwayatKegiatanScreenState extends State<RiwayatKegiatanScreen> {
  final ApiService _apiService = ApiService();
  List<Activity> _kegiatanList = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadActivities();
  }

  Future<void> _loadActivities() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final response = await _apiService.getActivities();
      if (response['ok'] == true && response['activities'] != null) {
        setState(() {
          _kegiatanList = (response['activities'] as List)
              .map((e) => Activity.fromJson(e))
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

  Future<void> _deleteActivity(String id) async {
    try {
      await _apiService.deleteActivity(id);
      _loadActivities();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal menghapus kegiatan: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // <CHANGE> modern gradient with subtle navy and slate colors
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
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
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
                            'Kegiatan',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 32,
                              fontWeight: FontWeight.w600,
                              letterSpacing: -0.5,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Riwayat jurnal kegiatan PKL Anda',
                            style: TextStyle(
                              color: Color(0xFFBDC3C7),
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
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
                    topLeft: Radius.circular(32),
                    topRight: Radius.circular(32),
                  ),
                  child: Container(
                    color: const Color(0xFFF8F9FA),
                    child: Column(
                      children: [
                        // Add Button - <CHANGE> subtle teal accent instead of gradient
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
                          child: SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF1ABC9C),
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: const EdgeInsets.symmetric(vertical: 14),
                              ),
                              onPressed: () {
                                Navigator.of(context).push(
                                  SlidePageRoute(page: const IsiKegiatanScreen()),
                                ).then((_) => _loadActivities());
                              },
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.add_rounded, size: 20),
                                  SizedBox(width: 8),
                                  Text(
                                    'Tambah Kegiatan',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 0.3,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        // List
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
                                            onPressed: _loadActivities,
                                            child: const Text('Retry'),
                                          ),
                                        ],
                                      ),
                                    )
                                  : _kegiatanList.isEmpty
                                      ? const Center(
                                          child: Text('Belum ada kegiatan', style: TextStyle(color: Colors.grey)),
                                        )
                                      : ListView.builder(
                                          physics: const BouncingScrollPhysics(),
                                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                                          itemCount: _kegiatanList.length,
                                          itemBuilder: (context, index) {
                                            final kegiatan = _kegiatanList[index];
                                            return Container(
                                              margin: const EdgeInsets.only(bottom: 12),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.circular(12),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black.withOpacity(0.04),
                                                    spreadRadius: 0,
                                                    blurRadius: 12,
                                                    offset: const Offset(0, 2),
                                                  ),
                                                ],
                                              ),
                                              child: Material(
                                                color: Colors.transparent,
                                                child: InkWell(
                                                  onTap: () {},
                                                  borderRadius: BorderRadius.circular(12),
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(16),
                                                    child: Row(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Container(
                                                          padding: const EdgeInsets.all(10),
                                                          decoration: BoxDecoration(
                                                            color: const Color(0xFFEBF5FB),
                                                            borderRadius: BorderRadius.circular(8),
                                                          ),
                                                          child: const Icon(
                                                            Icons.calendar_today_rounded,
                                                            size: 20,
                                                            color: Color(0xFF1ABC9C),
                                                          ),
                                                        ),
                                                        const SizedBox(width: 14),
                                                        Expanded(
                                                          child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Text(
                                                                kegiatan.kegiatan,
                                                                style: const TextStyle(
                                                                  fontSize: 15,
                                                                  fontWeight: FontWeight.w600,
                                                                  color: Color(0xFF2C3E50),
                                                                  letterSpacing: -0.2,
                                                                ),
                                                              ),
                                                              const SizedBox(height: 6),
                                                              Row(
                                                                children: [
                                                                  _buildDetailChip(
                                                                    Icons.event,
                                                                    kegiatan.formattedTanggal,
                                                                  ),
                                                                  const SizedBox(width: 12),
                                                                  _buildDetailChip(
                                                                    Icons.schedule,
                                                                    kegiatan.jamRange,
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        const SizedBox(width: 8),
                                                        Column(
                                                          children: [
                                                            _buildActionButton(
                                                              Icons.edit_rounded,
                                                              const Color(0xFF1ABC9C),
                                                              () {
                                                                Navigator.of(context).push(
                                                                  SlidePageRoute(
                                                                    page: EditKegiatanScreen(
                                                                      kegiatan: kegiatan,
                                                                    ),
                                                                  ),
                                                                ).then((_) => _loadActivities());
                                                              },
                                                            ),
                                                            const SizedBox(height: 8),
                                                            _buildActionButton(
                                                              Icons.delete_outline_rounded,
                                                              const Color(0xFF95A5A6),
                                                              () {
                                                                showDialog(
                                                                  context: context,
                                                                  builder: (context) => AlertDialog(
                                                                    title: const Text('Hapus Kegiatan'),
                                                                    content: const Text('Apakah anda yakin ingin menghapus kegiatan ini?'),
                                                                    actions: [
                                                                      TextButton(
                                                                        onPressed: () => Navigator.of(context).pop(),
                                                                        child: const Text('Batal'),
                                                                      ),
                                                                      ElevatedButton(
                                                                        style: ElevatedButton.styleFrom(
                                                                          backgroundColor: Colors.red,
                                                                        ),
                                                                        onPressed: () {
                                                                          Navigator.of(context).pop();
                                                                          _deleteActivity(kegiatan.id);
                                                                        },
                                                                        child: const Text('Hapus'),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                );
                                                              },
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
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
      bottomNavigationBar: buildMainBottomNav(context, currentIndex: 3),
    );
  }

  Widget _buildDetailChip(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: const Color(0xFF7F8C8D)),
        const SizedBox(width: 4),
        Text(
          text,
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF7F8C8D),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(
    IconData icon,
    Color color,
    VoidCallback onPressed,
  ) {
    return SizedBox(
      width: 36,
      height: 36,
      child: Material(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(8),
          child: Icon(
            icon,
            size: 16,
            color: color,
          ),
        ),
      ),
    );
  }

}