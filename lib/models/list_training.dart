// To parse this JSON data, do
//
//     final listTrainingResponse = listTrainingResponseFromJson(jsonString);

import 'dart:convert';

ListTrainingResponse listTrainingResponseFromJson(String str) =>
    ListTrainingResponse.fromJson(json.decode(str));

String listTrainingResponseToJson(ListTrainingResponse data) =>
    json.encode(data.toJson());

class ListTrainingResponse {
  final String? message;
  final List<Datum>? data;

  ListTrainingResponse({this.message, this.data});

  factory ListTrainingResponse.fromJson(Map<String, dynamic> json) =>
      ListTrainingResponse(
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
    "message": message,
    "data": data == null
        ? []
        : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class Datum {
  final int? id;
  final String? title;

  Datum({this.id, this.title});

  factory Datum.fromJson(Map<String, dynamic> json) =>
      Datum(id: json["id"], title: json["title"]);

  Map<String, dynamic> toJson() => {"id": id, "title": title};
}
