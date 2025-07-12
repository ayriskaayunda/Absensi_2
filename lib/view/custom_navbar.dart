import 'package:absensi_app/view/history_page.dart';
import 'package:absensi_app/view/home_page.dart';
import 'package:absensi_app/view/profile_page/profile_page.dart';
import 'package:flutter/material.dart';

class AppColor {
  static const Color beige3 = Color(0xFFF5F5DC);
  static const Color gradientStart = Color(0xFF8E2DE2);
  static const Color gradientEnd = Color(0xFF4A00E0);
  static const Color gradientLightStart = Color(0xFFADD8E6);
  static const Color gradientLightEnd = Color(0xFF9370DB);
}

class CustomButtonNavBar extends StatefulWidget {
  static const String id = '/custom_navbar';

  final int currentIndex;

  const CustomButtonNavBar({super.key, this.currentIndex = 0});

  @override
  State<CustomButtonNavBar> createState() => _CustomButtonNavBarState();
}

class _CustomButtonNavBarState extends State<CustomButtonNavBar> {
  late int _selectedIndex;

  final List<Widget> _screens = const [
    HomePage(), // Ganti dengan nama file kamu jika berbeda
    HistoryPage(),
    ProfilePage(),
  ];

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.currentIndex;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.deepPurple,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Riwayat'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }
}
