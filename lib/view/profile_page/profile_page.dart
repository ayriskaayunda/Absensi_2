import 'package:absensi_app/api/user_api.dart';
import 'package:absensi_app/helper/preference.dart';
import 'package:absensi_app/models/profile_response.dart';
import 'package:absensi_app/view/profile_page/edit_profile_page.dart';
import 'package:absensi_app/view/auth_page/login_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});
  static const String id = "/profile_page";

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Future<ProfileResponse?> _userFuture;
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _userFuture = fetchUserProfile();
  }

  // MARK: - Fungsi Konfirmasi dan Logout

  // Fungsi untuk menampilkan dialog konfirmasi logout
  void _confirmLogout() {
    showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: const Text('Konfirmasi Logout'),
          content: const Text('Apakah Anda yakin ingin keluar dari akun ini?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text(
                'Tidak',
                style: GoogleFonts.poppins(color: Colors.redAccent),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF624F82),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text('Ya', style: GoogleFonts.poppins()),
            ),
          ],
        );
      },
    ).then((confirmed) {
      // Setelah dialog ditutup, periksa hasilnya
      if (confirmed != null && confirmed) {
        _performLogout(); // Lanjutkan dengan proses logout jika dikonfirmasi
      }
    });
  }

  // Fungsi yang berisi logika logout sebenarnya
  void _performLogout() async {
    await Preferences.clearSession();
    await _apiService.logout();

    if (!mounted) return;

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const LoginPage()),
      (route) => false, // Hapus semua rute sebelumnya dari stack
    );
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Anda telah logout.')));
  }

  // MARK: - Pengambilan Data Profil

  Future<ProfileResponse?> fetchUserProfile() async {
    final token = await Preferences.getToken();
    if (token == null) {
      // Jika token tidak ditemukan, langsung navigasi ke halaman login
      // Ini penting untuk skenario di mana token hilang atau kadaluarsa
      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const LoginPage()),
          (route) => false,
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Sesi Anda telah berakhir. Silakan login kembali.'),
          ),
        );
      }
      return null;
    }
    return _apiService.getProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profil Saya',
          style: TextStyle(color: Color(0xFF624F82)),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFE0BBE4), Color(0xFFADD8E6), Color(0xFF957DAD)],
          ),
        ),
        child: FutureBuilder<ProfileResponse?>(
          future: _userFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(color: Colors.white),
              );
            } else if (snapshot.hasError) {
              return _buildErrorView('Gagal memuat profil: ${snapshot.error}');
            } else if (!snapshot.hasData || snapshot.data?.data == null) {
              final message =
                  snapshot.data?.message ?? 'Data profil tidak ditemukan.';
              return _buildErrorView(message);
            } else {
              final userData = snapshot.data!.data!;
              return ListView(
                padding: EdgeInsets.only(
                  top:
                      AppBar().preferredSize.height +
                      MediaQuery.of(context).padding.top +
                      20,
                  left: 16,
                  right: 16,
                  bottom: 16,
                ),
                children: [
                  Center(
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 10,
                                offset: Offset(0, 5),
                              ),
                            ],
                          ),
                          child: CircleAvatar(
                            radius: 65,
                            backgroundColor: Colors.white,
                            backgroundImage:
                                userData.profilePhoto != null &&
                                    userData.profilePhoto!.isNotEmpty
                                ? NetworkImage(
                                    'https://appabsensi.mobileprojp.com/${userData.profilePhoto!}',
                                  )
                                : null,
                            child:
                                userData.profilePhoto == null ||
                                    userData.profilePhoto!.isEmpty
                                ? const Icon(
                                    Icons.person,
                                    size: 80,
                                    color: Color(0xB3624F82), // 70% opacity
                                  )
                                : null,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          userData.name ?? 'Nama Tidak Tersedia',
                          style: GoogleFonts.poppins(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          userData.email ?? 'Email Tidak Tersedia',
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            color: Colors.white70,
                          ),
                        ),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                  _buildProfileCard(
                    title: 'Informasi Pribadi',
                    children: [
                      _buildInfoRow(
                        icon: Icons.person_outline,
                        label: 'Jenis Kelamin',
                        value: userData.jenisKelamin == 'L'
                            ? 'Laki-laki'
                            : userData.jenisKelamin == 'P'
                            ? 'Perempuan'
                            : 'N/A',
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _buildProfileCard(
                    title: 'Informasi Akademik/Training',
                    children: [
                      _buildInfoRow(
                        icon: Icons.group,
                        label: 'Batch',
                        value: userData.batch?.batchKe ?? 'N/A',
                      ),
                      _buildInfoRow(
                        icon: Icons.calendar_today,
                        label: 'Mulai Batch',
                        value: userData.batch?.startDate != null
                            ? '${userData.batch!.startDate!.day}/${userData.batch!.startDate!.month}/${userData.batch!.startDate!.year}'
                            : 'N/A',
                      ),
                      _buildInfoRow(
                        icon: Icons.calendar_today,
                        label: 'Akhir Batch',
                        value: userData.batch?.endDate != null
                            ? '${userData.batch!.endDate!.day}/${userData.batch!.endDate!.month}/${userData.batch!.endDate!.year}'
                            : 'N/A',
                      ),
                      _buildInfoRow(
                        icon: Icons.school,
                        label: 'Training',
                        value: userData.training?.title ?? 'N/A',
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditProfilePage(user: userData),
                        ),
                      );
                    },
                    icon: const Icon(Icons.edit, color: Colors.white),
                    label: const Text(
                      'Edit Profil',
                      style: TextStyle(fontSize: 18),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF624F82),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 5,
                    ),
                  ),
                  const SizedBox(height: 15),

                  // Ini adalah bagian di mana Anda memanggil fungsi konfirmasi logout
                  ElevatedButton.icon(
                    onPressed:
                        _confirmLogout, // Panggil fungsi konfirmasi logout di sini
                    icon: const Icon(Icons.logout, color: Color(0xFF624F82)),
                    label: const Text('Logout', style: TextStyle(fontSize: 18)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF624F82),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 5,
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  //  Widget Pembantu

  Widget _buildErrorView(String message) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            message,
            style: const TextStyle(color: Colors.white),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _userFuture =
                    fetchUserProfile(); // Memanggil fetchUserProfile yang sudah diperbarui
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFF624F82),
            ),
            child: const Text("Coba Lagi"),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileCard({
    required String title,
    required List<Widget> children,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 8,
      color: Colors.white.withOpacity(0.95),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF624F82),
              ),
            ),
            const SizedBox(height: 10),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: const Color(0x26957DAD), // 15% opacity
            child: Icon(icon, color: const Color(0xFF957DAD), size: 22),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF333333),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
