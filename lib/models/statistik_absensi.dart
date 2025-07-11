// To parse this JSON data, do
//
//     final statitistikAbsensiResponse = statitistikAbsensiResponseFromJson(jsonString);

import 'dart:convert';

StatitistikAbsensiResponse statitistikAbsensiResponseFromJson(String str) =>
    StatitistikAbsensiResponse.fromJson(json.decode(str));

String statitistikAbsensiResponseToJson(StatitistikAbsensiResponse data) =>
    json.encode(data.toJson());

class StatitistikAbsensiResponse {
  String? message;
  Data? data;

  StatitistikAbsensiResponse({this.message, this.data});

  factory StatitistikAbsensiResponse.fromJson(Map<String, dynamic> json) =>
      StatitistikAbsensiResponse(
        message: json["message"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {"message": message, "data": data?.toJson()};
}

class Data {
  int? totalAbsen;
  int? totalMasuk;
  int? totalIzin;
  bool? sudahAbsenHariIni;

  Data({
    this.totalAbsen,
    this.totalMasuk,
    this.totalIzin,
    this.sudahAbsenHariIni,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    totalAbsen: json["total_absen"],
    totalMasuk: json["total_masuk"],
    totalIzin: json["total_izin"],
    sudahAbsenHariIni: json["sudah_absen_hari_ini"],
  );

  Map<String, dynamic> toJson() => {
    "total_absen": totalAbsen,
    "total_masuk": totalMasuk,
    "total_izin": totalIzin,
    "sudah_absen_hari_ini": sudahAbsenHariIni,
  };
}
