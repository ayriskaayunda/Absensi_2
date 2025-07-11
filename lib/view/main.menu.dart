// import 'package:flutter/material.dart';

// // void main() {
// //   runApp(const MyApp());
// // }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Navigation Bar Flutter',
//       theme: ThemeData(primarySwatch: Colors.blue),
//       home: const MainScreen(),
//     );
//   }
// //

// class MainScreen extends StatefulWidget {
//   const MainScreen({super.key});

//   @override
//   State<MainScreen> createState() => _MainScreenState();
// }

// class _MainScreenState extends State<MainScreen> {
//   int _selectedIndex = 0; // Indeks item yang sedang aktif

//   // Daftar widget/halaman untuk setiap item navigasi
//   static const List<Widget> _widgetOptions = <Widget>[
//     Text(
//       'Halaman Home',
//       style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
//     ),
//     Text(
//       'Halaman Profile',
//       style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
//     ),
//     Text(
//       'Halaman Scan',
//       style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
//     ),
//     Text(
//       'Halaman Kehadiran',
//       style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
//     ),
//     Text(
//       'Halaman Maps',
//       style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
//     ),
//   ];

//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Aplikasi Navigasi')),
//       body: Center(child: _widgetOptions.elementAt(_selectedIndex)),
//       bottomNavigationBar: BottomNavigationBar(
//         items: const <BottomNavigationBarItem>[
//           BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
//           BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.qr_code_scanner),
//             label: 'Scan',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.check_circle),
//             label: 'Kehadiran',
//           ),
//           BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Maps'),
//         ],
//         currentIndex: _selectedIndex,
//         selectedItemColor: Colors.blue,
//         unselectedItemColor: Colors.grey,
//         onTap: _onItemTapped,
//         type: BottomNavigationBarType.fixed,
//       ),
//     );
//   }
// }
