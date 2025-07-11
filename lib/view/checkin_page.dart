// lib/pages/check_in_page.dart
import 'package:absensi_app/api/api_absen.dart';
import 'package:absensi_app/models/attendance_response.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart'; // Untuk format tanggal dan waktu

// import 'package:absensi_app/view/home_page.dart'; // Jika ingin kembali ke halaman home setelah check-in

class CheckInPage extends StatefulWidget {
  const CheckInPage({super.key});
  static const String id = "/check_in_page";

  @override
  State<CheckInPage> createState() => _CheckInPageState();
}

class _CheckInPageState extends State<CheckInPage> {
  final AttendanceApiService _apiService = AttendanceApiService();
  final TextEditingController _alasanIzinController = TextEditingController();

  String _currentDate = '';
  String _currentTime = '';
  Position? _currentPosition;
  String _currentAddress = 'Mencari lokasi...';
  bool _isLoadingLocation = true;
  bool _isCheckingIn = false;
  String? _selectedStatus; // 'masuk' atau 'izin'

  @override
  void initState() {
    super.initState();
    _updateDateTime();
    _getCurrentLocation();
    // Memperbarui waktu setiap detik
    // Timer.periodic(const Duration(seconds: 1), (timer) {
    //   _updateDateTime();
    // });
  }

  @override
  void dispose() {
    _alasanIzinController.dispose();
    super.dispose();
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

  // Fungsi untuk menangani proses check-in atau izin
  Future<void> _handleCheckIn({required String status}) async {
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

    if (status == 'izin' && _alasanIzinController.text.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Harap masukkan alasan izin Anda.')),
        );
      }
      return;
    }

    setState(() {
      _isCheckingIn = true;
    });

    try {
      final String attendanceDate = DateFormat(
        'yyyy-MM-dd',
      ).format(DateTime.now());
      final String checkInTime = DateFormat(
        'HH:mm',
      ).format(DateTime.now()); // Hanya jam dan menit

      final AttendanceResponse? response = await _apiService.checkIn(
        attendanceDate: attendanceDate,
        checkInTime: checkInTime,
        latitude: _currentPosition!.latitude,
        longitude: _currentPosition!.longitude,
        address: _currentAddress, // Gunakan alamat yang ditemukan atau default
        status: status,
        alasanIzin: status == 'izin' ? _alasanIzinController.text : null,
      );

      if (mounted) {
        if (response != null) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(response.message)));
          // Opsional: Navigasi ke halaman lain setelah sukses
          // Navigator.pushReplacementNamed(context, HomePage.id);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Check-in gagal. Silakan coba lagi.')),
          );
        }
      }
    } catch (e) {
      print('Error during check-in process: $e');
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Terjadi kesalahan: $e')));
      }
    } finally {
      setState(() {
        _isCheckingIn = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Check-in Absensi'),
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

            // Bagian Pilihan Status Absen
            const Text(
              'Pilih Status Absen:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: RadioListTile<String>(
                    title: const Text(
                      'Masuk',
                      style: TextStyle(color: Colors.white),
                    ),
                    value: 'masuk',
                    groupValue: _selectedStatus,
                    onChanged: (String? value) {
                      setState(() {
                        _selectedStatus = value;
                        _alasanIzinController
                            .clear(); // Bersihkan alasan jika memilih masuk
                      });
                    },
                    activeColor: Colors.white,
                    tileColor: Colors.white.withOpacity(0.2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: RadioListTile<String>(
                    title: const Text(
                      'Izin',
                      style: TextStyle(color: Colors.white),
                    ),
                    value: 'izin',
                    groupValue: _selectedStatus,
                    onChanged: (String? value) {
                      setState(() {
                        _selectedStatus = value;
                      });
                    },
                    activeColor: Colors.white,
                    tileColor: Colors.white.withOpacity(0.2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Input Alasan Izin (hanya jika status 'izin' dipilih)
            if (_selectedStatus == 'izin')
              TextFormField(
                controller: _alasanIzinController,
                decoration: InputDecoration(
                  labelText: 'Alasan Izin',
                  labelStyle: const TextStyle(color: Colors.white70),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.2),
                  prefixIcon: const Icon(Icons.notes, color: Colors.white70),
                ),
                style: const TextStyle(color: Colors.white),
                maxLines: 3,
              ),
            const SizedBox(height: 20),

            // Tombol Check-in
            ElevatedButton(
              onPressed: _isCheckingIn || _selectedStatus == null
                  ? null // Nonaktifkan tombol jika sedang loading atau status belum dipilih
                  : () => _handleCheckIn(status: _selectedStatus!),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF624F82),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 5,
              ),
              child: _isCheckingIn
                  ? const CircularProgressIndicator(color: Colors.white)
                  : Text(
                      _selectedStatus == 'izin'
                          ? 'Ajukan Izin'
                          : 'Check-in Sekarang',
                      style: const TextStyle(fontSize: 18),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
