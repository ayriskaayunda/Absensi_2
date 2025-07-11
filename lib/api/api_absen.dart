import 'dart:convert';

import 'package:absensi_app/api/endpoint.dart';
import 'package:absensi_app/models/attendance_response.dart';
import 'package:http/http.dart' as http;

// import 'package:absensi_app/helper/preference.dart'; // Jika Anda memiliki Preference untuk token

class AttendanceApiService {
  // check-in API
  Future<AttendanceResponse?> checkIn({
    required String attendanceDate,
    required String checkInTime,
    required double latitude,
    required double longitude,
    required String address,
    required String status,
    String? alasanIzin, // Opsional
  }) async {
    final url = Uri.parse(
      Endpoint.checkIn,
    ); // Menggunakan Endpoint dari file terpisah
    try {
      // Jika Anda menggunakan token otorisasi, ambil dari Preferences
      // final token = await Preferences.getToken();

      // Membangun body JSON untuk request
      Map<String, dynamic> requestBody = {
        "attendance_date": attendanceDate,
        "check_in": checkInTime,
        "check_in_lat": latitude,
        "check_in_lng": longitude,
        "check_in_address": address,
        "status": status,
      };

      // Tambahkan alasan_izin jika statusnya "izin" dan alasanIzin tidak null/kosong
      if (status == "izin" && alasanIzin != null && alasanIzin.isNotEmpty) {
        requestBody["alasan_izin"] = alasanIzin;
      }

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          // 'Authorization': 'Bearer $token', // Aktifkan jika menggunakan token
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Jika respons sukses, parse JSON ke model AttendanceResponse
        final data = jsonDecode(response.body);
        return AttendanceResponse.fromJson(data);
      } else {
        // Jika respons gagal, cetak status code dan body respons
        print('Check-in failed: ${response.statusCode} - ${response.body}');
        // Anda bisa menambahkan logika penanganan error yang lebih spesifik di sini,
        // misalnya mengurai pesan error dari body respons.
        return null;
      }
    } catch (e) {
      // Tangani error jaringan atau parsing
      print('Error during check-in: $e');
      return null;
    }
  }

  // --- Metode Simulasi Check-in (untuk tujuan testing/demonstrasi) ---
  Future<AttendanceResponse> simulateCheckInResponse() async {
    // Data respons JSON yang Anda berikan
    const String dummyResponseJson = '''
    {
        "message": "Anda sudah mengajukan izin pada tanggal ini",
        "data": {
            "id": 160,
            "attendance_date": "2025-07-20",
            "check_in_time": null,
            "check_in_lat": null,
            "check_in_lng": null,
            "check_in_location": null,
            "check_in_address": null,
            "status": "izin",
            "alasan_izin": "Alasan tidak bisa hadir karena sakit"
        }
    }
    ''';

    // Mensimulasikan penundaan jaringan
    await Future.delayed(const Duration(seconds: 1));

    // Mengurai string JSON ke dalam Map
    final Map<String, dynamic> jsonMap = json.decode(dummyResponseJson);

    // Mengembalikan objek AttendanceResponse dari Map
    return AttendanceResponse.fromJson(jsonMap);
  }
}
