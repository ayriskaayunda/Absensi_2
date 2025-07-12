import 'package:absensi_app/view/history_page.dart';
import 'package:absensi_app/view/auth_page/login_page.dart';
import 'package:absensi_app/view/custom_navbar.dart';
import 'package:absensi_app/view/map_page.dart';
import 'package:absensi_app/view/profile_page/profile_page.dart';
import 'package:absensi_app/view/auth_page/register_page.dart';
import 'package:absensi_app/view/open_page/splash_screen.dart';
import 'package:absensi_app/view/open_page/welcome_page.dart';
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
      initialRoute: "/",
      routes: {
        "/": (context) => SplashScreen(),
        WelcomePage.id: (context) => WelcomePage(),
        LoginPage.id: (context) => LoginPage(),
        RegisterPage.id: (context) => RegisterPage(),
        CustomButtonNavBar.id: (context) => CustomButtonNavBar(),
        ProfilePage.id: (context) => ProfilePage(),
        HistoryPage.id: (context) => HistoryPage(),
        BelajarMaps.id: (context) => BelajarMaps(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == CustomButtonNavBar.id) {
          final index = settings.arguments as int? ?? 0;
          return MaterialPageRoute(
            builder: (_) => CustomButtonNavBar(currentIndex: index),
          );
        }
        return null;
      },

      // home: MainLayout(),
      debugShowCheckedModeBanner: false,
    );
  }
}
