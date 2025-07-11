import 'package:absensi_app/view/login_page.dart';
import 'package:flutter/material.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});
  static const String id = "/welcome_page";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            // Mengubah warna gradient menjadi lilac dengan sedikit biru muda
            colors: [
              Color(0xFFE0BBE4), // Lilac lembut
              Color(0xFFADD8E6), // Biru muda
              Color(0xFF957DAD), // Ungu keabu-abuan untuk transisi yang halus
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Untuk logo
              // Pastikan path 'assets/logo_absensi.png' sudah benar di pubspec.yaml
              Image.asset(
                'assets/logo_absensi.png',
                height: 150,
                width: 150,
                // Anda mungkin perlu menyesuaikan warna logo atau menambahkan filter jika tidak terlihat jelas
                // color: Colors.white, // Contoh: jika logo berwarna gelap dan perlu diubah menjadi putih
                // colorBlendMode: BlendMode.modulate,
              ),
              const SizedBox(height: 30),
              const Text(
                'Selamat Datang di Aplikasi Absensi',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white, // Tetap putih agar kontras dengan lilac
                  shadows: [
                    Shadow(
                      blurRadius: 10.0,
                      color: Colors.black38,
                      offset: Offset(3.0, 3.0),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Kelola kehadiran Anda dengan mudah dan efisien.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                ), // Tetap putih transparan
              ),
              const SizedBox(height: 50),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Tombol "Mulai Sekarang" ditekan!'),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white, // Warna tombol putih
                  foregroundColor: const Color(
                    0xFF624F82,
                  ), // Warna teks tombol disesuaikan dengan lilac gelap
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 15,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 5,
                ),
                child: const Text(
                  'Mulai Sekarang',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
