import 'package:absensi_app/api/user_api.dart';
import 'package:absensi_app/models/profile_response.dart';
import 'package:absensi_app/view/main_layout.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService _apiService = ApiService();
  late Future<ProfileResponse?> _userFuture;

  // --- Data Dummy (Akan diganti dengan data asli dari backend/Firebase) ---
  String userName = "John Doe";
  String userPosition = "Software Engineer";
  String? profileImageUrl =
      "https://placehold.co/100x100/007bff/ffffff?text=JD";
  // Status kehadiran saat ini
  String _currentAttendanceStatus = "Belum Check In";
  DateTime? _lastCheckInTime;
  DateTime? _lastCheckOutTime;
  @override
  void initState() {
    super.initState();
    _userFuture = _apiService.getProfile();
  }

  // Contoh data riwayat kehadiran
  // Ini akan diisi dari database (misalnya Firestore)
  final List<Map<String, String>> _attendanceHistory = [
    {
      "date": "05 Juli 2025",
      "checkIn": "08:00",
      "checkOut": "17:00",
      "status": "Tepat Waktu",
    },
    {
      "date": "04 Juli 2025",
      "checkIn": "08:15",
      "checkOut": "17:00",
      "status": "Terlambat",
    },
    {
      "date": "03 Juli 2025",
      "checkIn": "07:55",
      "checkOut": "16:45",
      "status": "Tepat Waktu",
    },
    {
      "date": "02 Juli 2025",
      "checkIn": "08:00",
      "checkOut": "17:05",
      "status": "Tepat Waktu",
    },
    {
      "date": "01 Juli 2025",
      "checkIn": "08:20",
      "checkOut": "-",
      "status": "Belum Check-out",
    },
  ];

  // handle Check In
  void _checkIn() {
    setState(() {
      _lastCheckInTime = DateTime.now();
      _currentAttendanceStatus =
          "Anda sudah Check In pada ${DateFormat('HH:mm').format(_lastCheckInTime!)}";

      _attendanceHistory.insert(0, {
        "date": DateFormat('dd MMMMyyyy').format(_lastCheckInTime!),
        "checkIn": DateFormat('HH:mm').format(_lastCheckInTime!),
        "checkOut": "-",
        "status": "Check In Hari Ini",
      });
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Anda telah berhasil Check In!')),
    );
  }

  // handle Check Out
  void _checkOut() {
    if (_lastCheckInTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Anda belum Check In hari ini!')),
      );
      return;
    }

    setState(() {
      _lastCheckOutTime = DateTime.now();
      _currentAttendanceStatus =
          "Anda sudah Check Out pada ${DateFormat('HH:mm').format(_lastCheckOutTime!)}";

      // Perbarui entri terakhir di riwayat (ini hanya untuk demo)
      if (_attendanceHistory.isNotEmpty &&
          _attendanceHistory[0]["status"] == "Check In Hari Ini") {
        _attendanceHistory[0]["checkOut"] = DateFormat(
          'HH:mm',
        ).format(_lastCheckOutTime!);
        _attendanceHistory[0]["status"] = "Selesai";
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Anda telah berhasil Check Out!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColor.gradientLightStart, AppColor.gradientLightEnd],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),

      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 50),
              Row(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.blueAccent,
                    backgroundImage: profileImageUrl != null
                        ? NetworkImage(profileImageUrl!)
                        : null,
                    child: profileImageUrl == null
                        ? const Icon(
                            Icons.person,
                            size: 50,
                            color: Colors.white,
                          )
                        : null,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: FutureBuilder<ProfileResponse?>(
                      future: _userFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else if (snapshot.hasData && snapshot.data != null) {
                          final user = snapshot.data!;
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Halo, ${user.data?.name ?? "-"}!',
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                user.data?.training?.title ??
                                    "Belum ada pelatihan",
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          );
                        } else {
                          return const Text(
                            "Gagal memuat data",
                            style: TextStyle(color: Colors.white),
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),

              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Status Kehadiran Hari Ini',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Icon(
                            _currentAttendanceStatus.contains("Check In")
                                ? Icons.check_circle
                                : Icons.info_outline,
                            color: _currentAttendanceStatus.contains("Check In")
                                ? Colors.green
                                : Colors.orange,
                            size: 28,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              _currentAttendanceStatus,
                              style: TextStyle(
                                fontSize: 18,
                                color:
                                    _currentAttendanceStatus.contains(
                                      "Check In",
                                    )
                                    ? Colors.green.shade800
                                    : Colors.orange.shade800,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (_lastCheckInTime != null) ...[
                        const SizedBox(height: 10),
                        Text(
                          'Waktu Check In: ${DateFormat('HH:mm').format(_lastCheckInTime!)}',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                      if (_lastCheckOutTime != null) ...[
                        Text(
                          'Waktu Check Out: ${DateFormat('HH:mm').format(_lastCheckOutTime!)}',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),

              const Text(
                'Aksi Cepat',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _checkIn,
                      icon: const Icon(Icons.login),
                      label: const Text('Check In'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 5,
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _checkOut,
                      icon: const Icon(Icons.logout),
                      label: const Text('Check Out'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 5,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),

              const Text(
                'Riwayat Kehadiran',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _attendanceHistory.length,
                itemBuilder: (context, index) {
                  final entry = _attendanceHistory[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 10),
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            entry['date']!,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Check In: ${entry['checkIn']}'),
                              Text('Check Out: ${entry['checkOut']}'),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Text(
                            'Status: ${entry['status']}',
                            style: TextStyle(
                              color:
                                  entry['status'] == 'Tepat Waktu' ||
                                      entry['status'] == 'Selesai'
                                  ? Colors.green
                                  : entry['status'] == 'Terlambat'
                                  ? Colors.orange
                                  : Colors.blue,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// --- Dummy Screen Files untuk Navigation Bar ---

// lib/screens/map_screen.dart
class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Halaman Map (Belum Diimplementasi)',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }
}

// lib/screens/history_screen.dart
class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Halaman Riwayat Kehadiran (Detail)',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }
}
