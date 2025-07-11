import 'package:absensi_app/view/history_page.dart';
import 'package:absensi_app/view/home.dart';
import 'package:absensi_app/view/profile_page.dart';
import 'package:flutter/material.dart';

class AppColor {
  static const Color beige3 = Color(0xFFF5F5DC);
  static const Color gradientStart = Color(0xFF8E2DE2);
  static const Color gradientEnd = Color(0xFF4A00E0);
  static const Color gradientLightStart = Color(0xFFADD8E6);
  static const Color gradientLightEnd = Color(0xFF9370DB);
}

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});
  static const String id = "/main_layout";

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    // const BelajarMaps(),
    const HistoryPage(),
    const ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Background Scaffold bisa tetap beige atau dihapus jika HomeScreen sudah full gradient
      backgroundColor: AppColor.beige3,

      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          // BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Map'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.blueGrey,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
      ),
    );
  }
}
