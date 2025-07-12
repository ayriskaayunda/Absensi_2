import 'package:absensi_app/api/user_api.dart';
import 'package:absensi_app/models/profile_response.dart';
import 'package:absensi_app/view/custom_navbar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ApiService _apiService = ApiService();
  late Future<ProfileResponse?> _userFuture;

  String _currentAttendanceStatus = "Belum Check In";
  DateTime? _lastCheckInTime;
  DateTime? _lastCheckOutTime;

  String? profileImageUrl =
      "https://placehold.co/100x100/007bff/ffffff?text=JD";

  final List<Map<String, String>> _attendanceHistory = [];

  @override
  void initState() {
    super.initState();
    _userFuture = _apiService.getProfile();
  }

  void _checkIn() {
    setState(() {
      _lastCheckInTime = DateTime.now();
      _currentAttendanceStatus =
          "Anda sudah Check In pada ${DateFormat('HH:mm').format(_lastCheckInTime!)}";

      _attendanceHistory.insert(0, {
        "date": DateFormat('dd MMMM yyyy').format(_lastCheckInTime!),
        "checkIn": DateFormat('HH:mm').format(_lastCheckInTime!),
        "checkOut": "-",
        "status": "Check In Hari Ini",
      });
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Anda telah berhasil Check In!')),
    );
  }

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
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FutureBuilder<ProfileResponse?>(
                future: _userFuture,
                builder: (context, snapshot) {
                  print("Profile fetch status: ${snapshot.connectionState}");
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    print("Profile fetch error: ${snapshot.error}");
                    return const Text(
                      "Terjadi kesalahan saat memuat profil.",
                      style: TextStyle(color: Colors.white),
                    );
                  } else if (snapshot.hasData && snapshot.data != null) {
                    final user = snapshot.data!;
                    return Row(
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundImage: user.data?.profilePhoto != null
                              ? NetworkImage(user.data!.profilePhoto!)
                              : NetworkImage(profileImageUrl!),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
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
                          ),
                        ),
                      ],
                    );
                  } else {
                    return const Text(
                      "Gagal memuat data.",
                      style: TextStyle(color: Colors.white),
                    );
                  }
                },
              ),
              const SizedBox(height: 30),

              /// Status Kehadiran
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
                      if (_lastCheckInTime != null)
                        Text(
                          'Waktu Check In: ${DateFormat('HH:mm').format(_lastCheckInTime!)}',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                        ),
                      if (_lastCheckOutTime != null)
                        Text(
                          'Waktu Check Out: ${DateFormat('HH:mm').format(_lastCheckOutTime!)}',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),

              /// Tombol Aksi
              const Text(
                'Aksi Cepat',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),
              Row(
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
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),

              /// Riwayat Kehadiran
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
                    child: Padding(
                      padding: const EdgeInsets.all(12),
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
