import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Kehadiran {
  final DateTime tanggal;
  final DateTime? checkIn;
  final DateTime? checkOut;

  Kehadiran({required this.tanggal, this.checkIn, this.checkOut});
}

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});
  static const String id = "/history_page";

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  // Dummy data (sesuai kode Anda)
  final List<Kehadiran> riwayatKehadiran = [
    Kehadiran(
      tanggal: DateTime(2025, 7, 8),
      checkIn: DateTime(2025, 7, 8, 8, 30, 0),
      checkOut: null,
    ),
    Kehadiran(
      tanggal: DateTime(2025, 7, 7),
      checkIn: DateTime(2025, 7, 7, 8, 0, 0),
      checkOut: DateTime(2025, 7, 7, 17, 0, 0),
    ),
    Kehadiran(
      tanggal: DateTime(2025, 7, 6),
      checkIn: DateTime(2025, 7, 6, 8, 15, 0),
      checkOut: DateTime(2025, 7, 6, 16, 45, 0),
    ),
    Kehadiran(tanggal: DateTime(2025, 7, 5), checkIn: null, checkOut: null),
    Kehadiran(
      tanggal: DateTime(2025, 7, 4),
      checkIn: DateTime(2025, 7, 4, 7, 55, 0),
      checkOut: DateTime(2025, 7, 4, 17, 10, 0),
    ),
    Kehadiran(
      tanggal: DateTime(2025, 6, 30),
      checkIn: DateTime(2025, 6, 30, 8, 20, 0),
      checkOut: DateTime(2025, 6, 30, 16, 50, 0),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    // Pastikan untuk menginisialisasi locale jika belum
    // Contoh: initializeDateFormatting('id_ID', null); di main() atau sebelum runApp()
    // Atau tambahkan di pubspec.yaml: dependencies: flutter_localizations: sdk: flutter
    // dan di MaterialApp: localizationsDelegates: [GlobalMaterialLocalizations.delegate, GlobalWidgetsLocalizations.delegate], supportedLocales: [const Locale('id', 'ID')]
    riwayatKehadiran.sort((a, b) => b.tanggal.compareTo(a.tanggal));

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Riwayat Kehadiran',
          style: TextStyle(
            color: Color(0xFF624F82),
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent,
        foregroundColor: const Color(0xFF624F82),
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: true,
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
        child: riwayatKehadiran.isEmpty
            ? const Center(
                child: Text(
                  'Belum ada riwayat kehadiran yang tercatat.',
                  style: TextStyle(fontSize: 16, color: Colors.white70),
                ),
              )
            : ListView.builder(
                padding: EdgeInsets.only(
                  top:
                      AppBar().preferredSize.height +
                      MediaQuery.of(context).padding.top +
                      16.0,
                  left: 16.0,
                  right: 16.0,
                  bottom: 16.0,
                ),
                itemCount: riwayatKehadiran.length,
                itemBuilder: (context, index) {
                  final kehadiran = riwayatKehadiran[index];
                  return Card(
                    elevation: 6,
                    margin: const EdgeInsets.only(bottom: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    color: Colors.white.withOpacity(
                      0.85,
                    ), //sedikit transparan supaya terlihat background
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            DateFormat(
                              'EEEE, dd MMMM yyyy',
                              'id_ID',
                            ).format(kehadiran.tanggal),
                            style: const TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF624F82),
                            ),
                          ),
                          const Divider(
                            height: 25,
                            thickness: 1.5,
                            color: Colors.grey,
                          ),
                          _buildTimeRow(
                            icon: Icons.login,
                            label: 'Check-in',
                            time: kehadiran.checkIn,
                            color: Colors.green,
                          ),
                          const SizedBox(height: 12),
                          _buildTimeRow(
                            icon: Icons.logout,
                            label: 'Check-out',
                            time: kehadiran.checkOut,
                            color: Colors.red,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }

  // Helper widget untuk menampilkan baris waktu check-in/out
  Widget _buildTimeRow({
    required IconData icon,
    required String label,
    required DateTime? time,
    required Color color,
  }) {
    return Row(
      children: [
        Icon(icon, color: color, size: 22),
        const SizedBox(width: 12),
        Text(
          '$label: ${time != null ? DateFormat('HH:mm').format(time) : 'Belum Check-out'}',
          style: TextStyle(
            fontSize: 17,
            color: time != null ? Colors.black87 : Colors.orange.shade700,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
