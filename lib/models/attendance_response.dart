// Kelas model untuk bagian 'data' dari respons check-in
class AttendanceData {
  final int id;
  final String attendanceDate;
  final String? checkInTime; // Bisa null
  final double? checkInLat; // Bisa null
  final double? checkInLng; // Bisa null
  final String? checkInLocation; // Bisa null
  final String? checkInAddress; // Bisa null
  final String status;
  final String? alasanIzin; // Bisa null, hanya ada jika status 'izin'

  AttendanceData({
    required this.id,
    required this.attendanceDate,
    this.checkInTime,
    this.checkInLat,
    this.checkInLng,
    this.checkInLocation,
    this.checkInAddress,
    required this.status,
    this.alasanIzin,
  });

  // Factory constructor untuk membuat instance AttendanceData dari Map JSON
  factory AttendanceData.fromJson(Map<String, dynamic> json) {
    return AttendanceData(
      id: json['id'] as int,
      attendanceDate: json['attendance_date'] as String,
      checkInTime: json['check_in_time'] as String?,
      checkInLat: (json['check_in_lat'] as num?)
          ?.toDouble(), // Konversi num ke double, bisa null
      checkInLng: (json['check_in_lng'] as num?)
          ?.toDouble(), // Konversi num ke double, bisa null
      checkInLocation: json['check_in_location'] as String?,
      checkInAddress: json['check_in_address'] as String?,
      status: json['status'] as String,
      alasanIzin: json['alasan_izin'] as String?,
    );
  }

  // Metode untuk mengonversi instance AttendanceData menjadi Map JSON (opsional, untuk request body)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'attendance_date': attendanceDate,
      'check_in_time': checkInTime,
      'check_in_lat': checkInLat,
      'check_in_lng': checkInLng,
      'check_in_location': checkInLocation,
      'check_in_address': checkInAddress,
      'status': status,
      'alasan_izin': alasanIzin,
    };
  }
}

// Kelas model untuk respons API check-in secara keseluruhan
class AttendanceResponse {
  final String message;
  final AttendanceData data;

  AttendanceResponse({required this.message, required this.data});

  // Factory constructor untuk membuat instance AttendanceResponse dari Map JSON
  factory AttendanceResponse.fromJson(Map<String, dynamic> json) {
    return AttendanceResponse(
      message: json['message'] as String,
      data: AttendanceData.fromJson(json['data'] as Map<String, dynamic>),
    );
  }

  // Metode untuk mengonversi instance AttendanceResponse menjadi Map JSON (opsional)
  Map<String, dynamic> toJson() {
    return {'message': message, 'data': data.toJson()};
  }
}
