// lib/pages/check_out_page.dart
import 'package:absensi_app/api/api_absen.dart';
import 'package:absensi_app/models/attendance_response.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart'; // Untuk format tanggal dan waktu

// import 'package:absensi_app/view/home_page.dart'; // Jika ingin kembali ke halaman home setelah check-out

class CheckOutPage extends StatefulWidget {
  const CheckOutPage({super.key});
  static const String id = "/check_out_page";

  @override
  State<CheckOutPage> createState() => _CheckOutPageState();
}

class _CheckOutPageState extends State<CheckOutPage> {
  final AttendanceApiService _apiService = AttendanceApiService();

  String _currentDate = '';
  String _currentTime = '';
  Position? _currentPosition;
  String _currentAddress = 'Mencari lokasi...';
  bool _isLoadingLocation = true;
  bool _isCheckingOut = false;

  @override
  void initState() {
    super.initState();
    _updateDateTime();
    _getCurrentLocation();
    // Opsional: Memperbarui waktu setiap detik jika diperlukan
    // Timer.periodic(const Duration(seconds: 1), (timer) {
    //   _updateDateTime();
    // });
  }

  // Fungsi untuk memperbarui tanggal dan waktu
  void _updateDateTime() {
    setState(() {
      _currentDate = DateFormat(
        'EEEE, dd MMMM yyyy',
        'id_ID',
      ).format(DateTime.now());
      _currentTime = DateFormat('HH:mm:ss').format(DateTime.now());
    });
  }

  // Fungsi untuk mendapatkan lokasi saat ini
  Future<void> _getCurrentLocation() async {
    setState(() {
      _isLoadingLocation = true;
      _currentAddress = 'Mencari lokasi...';
    });

    try {
      // Memeriksa apakah layanan lokasi diaktifkan
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Layanan lokasi tidak diaktifkan. Harap aktifkan GPS Anda.',
              ),
            ),
          );
        }
        setState(() {
          _isLoadingLocation = false;
          _currentAddress = 'Layanan lokasi dinonaktifkan.';
        });
        return;
      }

      // Memeriksa izin lokasi
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Izin lokasi ditolak. Tidak dapat mengambil lokasi.',
                ),
              ),
            );
          }
          setState(() {
            _isLoadingLocation = false;
            _currentAddress = 'Izin lokasi ditolak.';
          });
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Izin lokasi ditolak secara permanen. Harap izinkan dari pengaturan aplikasi.',
              ),
            ),
          );
        }
        setState(() {
          _isLoadingLocation = false;
          _currentAddress = 'Izin lokasi ditolak permanen.';
        });
        return;
      }

      // Mendapatkan posisi saat ini
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _currentPosition = position;
        _isLoadingLocation = false;
        _currentAddress =
            'Lokasi ditemukan.'; // Akan diganti dengan alamat sebenarnya jika ada geocoding
      });

      // Anda bisa menambahkan geocoding di sini untuk mendapatkan alamat sebenarnya
      // Misalnya, menggunakan package geocoding:
      // import 'package:geocoding/geocoding.dart';
      // List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
      // if (placemarks.isNotEmpty) {
      //   Placemark place = placemarks[0];
      //   setState(() {
      //     _currentAddress = "${place.street}, ${place.subLocality}, ${place.locality}, ${place.administrativeArea}, ${place.postalCode}, ${place.country}";
      //   });
      // }
    } catch (e) {
      print('Error getting location: $e');
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Gagal mendapatkan lokasi: $e')));
      }
      setState(() {
        _isLoadingLocation = false;
        _currentAddress = 'Gagal mendapatkan lokasi.';
      });
    }
  }

  // Fungsi untuk menangani proses check-out
  Future<void> _handleCheckOut() async {
    if (_currentPosition == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Lokasi belum ditemukan. Harap tunggu atau coba lagi.',
            ),
          ),
        );
      }
      return;
    }

    setState(() {
      _isCheckingOut = true;
    });

    try {
      final String attendanceDate = DateFormat(
        'yyyy-MM-dd',
      ).format(DateTime.now());
      final String checkOutTime = DateFormat(
        'HH:mm',
      ).format(DateTime.now()); // Hanya jam dan menit

      // Panggil metode checkOut dari ApiService
      // Perlu diingat, metode checkOut belum ada di AttendanceApiService yang kita buat sebelumnya.
      // Anda perlu menambahkannya di sana, mirip dengan checkIn.
      // Untuk demo ini, saya akan memanggil checkIn dengan status 'pulang' sebagai simulasi.
      // Di aplikasi nyata, Anda akan memanggil metode checkOut yang sebenarnya.

      // Contoh pemanggilan API checkOut (Anda perlu mengimplementasikannya di AttendanceApiService)
      // final AttendanceResponse? response = await _apiService.checkOut(
      //   attendanceDate: attendanceDate,
      //   checkOutTime: checkOutTime,
      //   latitude: _currentPosition!.latitude,
      //   longitude: _currentPosition!.longitude,
      //   address: _currentAddress,
      // );

      // --- SIMULASI RESPONS CHECK-OUT ---
      // Karena Anda belum memberikan struktur JSON untuk respons check-out,
      // saya akan menggunakan respons check-in yang ada sebagai simulasi.
      // Di aplikasi nyata, Anda akan memiliki model respons terpisah untuk check-out jika berbeda.
      final AttendanceResponse response = await _apiService
          .simulateCheckInResponse(); // Menggunakan simulasi check-in
      // --- AKHIR SIMULASI ---

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(response.message)));
        // Opsional: Navigasi ke halaman lain setelah sukses
        // Navigator.pushReplacementNamed(context, HomePage.id);
      }
    } catch (e) {
      print('Error during check-out process: $e');
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Terjadi kesalahan: $e')));
      }
    } finally {
      setState(() {
        _isCheckingOut = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Check-out Absensi'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        elevation: 0,
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFE0BBE4), Color(0xFFADD8E6), Color(0xFF957DAD)],
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Card Tanggal & Waktu
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              color: Colors.white.withOpacity(0.9),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Text(
                      _currentDate,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF624F82),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _currentTime,
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF957DAD),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Card Informasi Lokasi
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              color: Colors.white.withOpacity(0.9),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Lokasi Anda:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF624F82),
                      ),
                    ),
                    const SizedBox(height: 10),
                    _isLoadingLocation
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: Color(0xFF957DAD),
                            ),
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.location_on,
                                    color: Color(0xFF957DAD),
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      'Lat: ${_currentPosition?.latitude.toStringAsFixed(6) ?? '-'}, Lng: ${_currentPosition?.longitude.toStringAsFixed(6) ?? '-'}',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 5),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.map,
                                    color: Color(0xFF957DAD),
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      _currentAddress,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton.icon(
                        onPressed: _isLoadingLocation
                            ? null
                            : _getCurrentLocation,
                        icon: const Icon(Icons.refresh, color: Colors.white),
                        label: const Text(
                          'Perbarui Lokasi',
                          style: TextStyle(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF957DAD),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Tombol Check-out
            ElevatedButton(
              onPressed:
                  _isCheckingOut ||
                      _isLoadingLocation ||
                      _currentPosition == null
                  ? null // Nonaktifkan tombol jika sedang loading atau lokasi belum ditemukan
                  : _handleCheckOut,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF624F82),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 5,
              ),
              child: _isCheckingOut
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text(
                      'Check-out Sekarang',
                      style: TextStyle(fontSize: 18),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
