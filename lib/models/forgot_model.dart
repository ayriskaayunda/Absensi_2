// To parse this JSON data, do
//
//     final forgotPasswordResponse = forgotPasswordResponseFromJson(jsonString);

import 'dart:convert';

ForgotPasswordResponse forgotPasswordResponseFromJson(String str) =>
    ForgotPasswordResponse.fromJson(json.decode(str));

String forgotPasswordResponseToJson(ForgotPasswordResponse data) =>
    json.encode(data.toJson());

class ForgotPasswordResponse {
  String? message;

  ForgotPasswordResponse({this.message});

  factory ForgotPasswordResponse.fromJson(Map<String, dynamic> json) =>
      ForgotPasswordResponse(message: json["message"]);

  Map<String, dynamic> toJson() => {"message": message};
}
