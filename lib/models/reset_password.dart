// To parse this JSON data, do
//
//     final resetPasswordResponse = resetPasswordResponseFromJson(jsonString);

import 'dart:convert';

ResetPasswordResponse resetPasswordResponseFromJson(String str) =>
    ResetPasswordResponse.fromJson(json.decode(str));

String resetPasswordResponseToJson(ResetPasswordResponse data) =>
    json.encode(data.toJson());

class ResetPasswordResponse {
  String? message;

  ResetPasswordResponse({this.message});

  factory ResetPasswordResponse.fromJson(Map<String, dynamic> json) =>
      ResetPasswordResponse(message: json["message"]);

  Map<String, dynamic> toJson() => {"message": message};
}
