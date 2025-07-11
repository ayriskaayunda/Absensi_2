// To parse this JSON data, do
//
//     final izinResponse = izinResponseFromJson(jsonString);

import 'dart:convert';

IzinResponse izinResponseFromJson(String str) =>
    IzinResponse.fromJson(json.decode(str));

String izinResponseToJson(IzinResponse data) => json.encode(data.toJson());

class IzinResponse {
  String? message;
  Data? data;

  IzinResponse({this.message, this.data});

  factory IzinResponse.fromJson(Map<String, dynamic> json) => IzinResponse(
    message: json["message"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {"message": message, "data": data?.toJson()};
}

class Data {
  int? userId;
  dynamic checkIn;
  dynamic checkInLocation;
  dynamic checkInAddress;
  String? status;
  String? alasanIzin;
  DateTime? updatedAt;
  DateTime? createdAt;
  int? id;

  Data({
    this.userId,
    this.checkIn,
    this.checkInLocation,
    this.checkInAddress,
    this.status,
    this.alasanIzin,
    this.updatedAt,
    this.createdAt,
    this.id,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    userId: json["user_id"],
    checkIn: json["check_in"],
    checkInLocation: json["check_in_location"],
    checkInAddress: json["check_in_address"],
    status: json["status"],
    alasanIzin: json["alasan_izin"],
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.parse(json["updated_at"]),
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
    id: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "user_id": userId,
    "check_in": checkIn,
    "check_in_location": checkInLocation,
    "check_in_address": checkInAddress,
    "status": status,
    "alasan_izin": alasanIzin,
    "updated_at": updatedAt?.toIso8601String(),
    "created_at": createdAt?.toIso8601String(),
    "id": id,
  };
}
