// To parse this JSON data, do
//
//     final izinResponse = izinResponseFromJson(jsonString);

import 'dart:convert';

IzinResponse izinResponseFromJson(String str) =>
    IzinResponse.fromJson(json.decode(str));

String izinResponseToJson(IzinResponse data) => json.encode(data.toJson());

class IzinResponse {
  final String? message;
  final Data? data;

  IzinResponse({this.message, this.data});

  factory IzinResponse.fromJson(Map<String, dynamic> json) => IzinResponse(
    message: json["message"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {"message": message, "data": data?.toJson()};
}

class Data {
  final int? id;
  final DateTime? attendanceDate;
  final dynamic checkInTime;
  final dynamic checkInLat;
  final dynamic checkInLng;
  final dynamic checkInLocation;
  final dynamic checkInAddress;
  final String? status;
  final String? alasanIzin;

  Data({
    this.id,
    this.attendanceDate,
    this.checkInTime,
    this.checkInLat,
    this.checkInLng,
    this.checkInLocation,
    this.checkInAddress,
    this.status,
    this.alasanIzin,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    attendanceDate: json["attendance_date"] == null
        ? null
        : DateTime.parse(json["attendance_date"]),
    checkInTime: json["check_in_time"],
    checkInLat: json["check_in_lat"],
    checkInLng: json["check_in_lng"],
    checkInLocation: json["check_in_location"],
    checkInAddress: json["check_in_address"],
    status: json["status"],
    alasanIzin: json["alasan_izin"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "attendance_date":
        "${attendanceDate!.year.toString().padLeft(4, '0')}-${attendanceDate!.month.toString().padLeft(2, '0')}-${attendanceDate!.day.toString().padLeft(2, '0')}",
    "check_in_time": checkInTime,
    "check_in_lat": checkInLat,
    "check_in_lng": checkInLng,
    "check_in_location": checkInLocation,
    "check_in_address": checkInAddress,
    "status": status,
    "alasan_izin": alasanIzin,
  };
}
