import 'package:absensi_app/view/history_page.dart';
import 'package:absensi_app/view/login_page.dart';
import 'package:absensi_app/view/main_layout.dart';
import 'package:absensi_app/view/map_page.dart';
import 'package:absensi_app/view/profile_page.dart';
import 'package:absensi_app/view/register_page.dart';
import 'package:absensi_app/view/welcome_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting(
    'id_ID',
    null,
  ); // ganti sesuai locale yang kamu pakai
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      initialRoute: MainLayout.id,
      routes: {
        "/": (context) => WelcomePage(),
        LoginPage.id: (context) => LoginPage(),
        RegisterPage.id: (context) => RegisterPage(),
        MainLayout.id: (context) => MainLayout(),
        ProfilePage.id: (context) => ProfilePage(),
        HistoryPage.id: (context) => HistoryPage(),
        BelajarMaps.id: (context) => BelajarMaps(),
      },
      // home: MainLayout(),
      debugShowCheckedModeBanner: false,
    );
  }
}
