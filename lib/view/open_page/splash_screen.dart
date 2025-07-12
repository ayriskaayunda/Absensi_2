import 'package:absensi_app/helper/preference.dart';
import 'package:absensi_app/view/auth_page/login_page.dart';
import 'package:absensi_app/view/custom_navbar.dart';
import 'package:absensi_app/view/open_page/welcome_page.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _animationController.forward();
    changePage();
  }

  Future<void> changePage() async {
    await Future.delayed(const Duration(seconds: 3));

    final token = await Preferences.getToken();

    if (token != null && token.isNotEmpty) {
      // ✅ Ganti ke BottomNav dengan index 0 (Home)
      Navigator.pushNamedAndRemoveUntil(
        context,
        CustomButtonNavBar.id,
        (route) => false,
        arguments: 0,
      );
    } else {
      Navigator.pushNamedAndRemoveUntil(
        context,
        WelcomePage.id,
        (route) => false,
      );
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Image.asset('assets/images/logo.png', width: size.width * 1),
        ),
      ),
    );
  }
}
