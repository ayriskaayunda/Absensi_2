// lib/models/attendance_model.dart

// Kelas model untuk data absen individual
// class AttendanceData {
//   final int id;
//   final String attendanceDate;
//   final String? checkInTime;
//   final double? checkInLat;
//   final double? checkInLng;
//   final String? checkInLocation;
//   final String? checkInAddress;
//   final String status;
//   final String? alasanIzin;

//   // Constructor untuk inisialisasi properti
//   AttendanceData({
//     required this.id,
//     required this.attendanceDate,
//     this.checkInTime,
//     this.checkInLat,
//     this.checkInLng,
//     this.checkInLocation,
//     this.checkInAddress,
//     required this.status,
//     this.alasanIzin,
//   });

//   // Factory constructor untuk membuat instance dari Map JSON
//   factory AttendanceData.fromJson(Map<String, dynamic> json) {
//     return AttendanceData(
//       id: json['id'] as int,
//       attendanceDate: json['attendance_date'] as String,
//       // Menggunakan operator null-aware (?.) dan as String? untuk properti yang bisa null
//       checkInTime: json['check_in_time'] as String?,
//       checkInLat: (json['check_in_lat'] as num?)
//           ?.toDouble(), // Konversi num ke double
//       checkInLng: (json['check_in_lng'] as num?)
//           ?.toDouble(), // Konversi num ke double
//       checkInLocation: json['check_in_location'] as String?,
//       checkInAddress: json['check_in_address'] as String?,
//       status: json['status'] as String,
//       alasanIzin: json['alasan_izin'] as String?,
//     );
//   }
// }

// // Kelas model untuk respons API secara keseluruhan
// class AttendanceResponse {
//   final String message;
//   final AttendanceData data;

//   // Constructor untuk inisialisasi properti
//   AttendanceResponse({required this.message, required this.data});

//   // Factory constructor untuk membuat instance dari Map JSON
//   factory AttendanceResponse.fromJson(Map<String, dynamic> json) {
//     return AttendanceResponse(
//       message: json['message'] as String,
//       // Memanggil factory constructor AttendanceData.fromJson untuk bagian 'data'
//       data: AttendanceData.fromJson(json['data'] as Map<String, dynamic>),
//     );
//   }
// }

// ini di perpus
// // To parse this JSON data, do
// //
// //     final absenResponse = absenResponseFromJson(jsonString);

// import 'dart:convert';

// AbsenResponse absenResponseFromJson(String str) =>
//     AbsenResponse.fromJson(json.decode(str));

// String absenResponseToJson(AbsenResponse data) => json.encode(data.toJson());

// class AbsenResponse {
//   String? message;
//   Data? data;

//   AbsenResponse({this.message, this.data});

//   factory AbsenResponse.fromJson(Map<String, dynamic> json) => AbsenResponse(
//     message: json["message"],
//     data: json["data"] == null ? null : Data.fromJson(json["data"]),
//   );

//   Map<String, dynamic> toJson() => {"message": message, "data": data?.toJson()};
// }

// class Data {
//   DateTime? tanggal;
//   dynamic jamMasuk;
//   dynamic jamKeluar;
//   dynamic alamatMasuk;
//   dynamic alamatKeluar;
//   String? status;
//   String? alasanIzin;

//   Data({
//     this.tanggal,
//     this.jamMasuk,
//     this.jamKeluar,
//     this.alamatMasuk,
//     this.alamatKeluar,
//     this.status,
//     this.alasanIzin,
//   });

//   factory Data.fromJson(Map<String, dynamic> json) => Data(
//     tanggal: json["tanggal"] == null ? null : DateTime.parse(json["tanggal"]),
//     jamMasuk: json["jam_masuk"],
//     jamKeluar: json["jam_keluar"],
//     alamatMasuk: json["alamat_masuk"],
//     alamatKeluar: json["alamat_keluar"],
//     status: json["status"],
//     alasanIzin: json["alasan_izin"],
//   );

//   Map<String, dynamic> toJson() => {
//     "tanggal":
//         "${tanggal!.year.toString().padLeft(4, '0')}-${tanggal!.month.toString().padLeft(2, '0')}-${tanggal!.day.toString().padLeft(2, '0')}",
//     "jam_masuk": jamMasuk,
//     "jam_keluar": jamKeluar,
//     "alamat_masuk": alamatMasuk,
//     "alamat_keluar": alamatKeluar,
//     "status": status,
//     "alasan_izin": alasanIzin,
//   };
// }
