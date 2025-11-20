import 'package:flutter/material.dart';
import 'package:kons/core/navigation/page_transitions.dart';
import 'package:kons/screens/home/home_screen.dart';
import 'package:kons/screens/attendance/presensi_screen.dart';
import 'package:kons/screens/activities/isi_kegiatan_screen.dart';
import 'package:kons/screens/messages/pesan_screen.dart';

Widget buildReportBottomNav(BuildContext context, {int currentIndex = 2}) {
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
      currentIndex: currentIndex,
      onTap: (index) {
        if (index == currentIndex) return;

        switch (index) {
          case 0:
            Navigator.of(context).pushAndRemoveUntil(
              SlidePageRoute(page: const HomeScreen()),
              (route) => false,
            );
            break;
          case 1:
            Navigator.of(context).push(
              SlidePageRoute(page: const PresensiScreen()),
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
      selectedItemColor: const Color(0xFF6A5AE0),
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


