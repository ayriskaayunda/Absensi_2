import 'package:absensi_app/models/user_model.dart';

class LoginResponse {
  final String message;
  final Data data;

  LoginResponse({required this.message, required this.data});

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
    message: json["message"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {"message": message, "data": data.toJson()};
}

class Data {
  final String token;
  final UserLogin user;

  Data({required this.token, required this.user});

  factory Data.fromJson(Map<String, dynamic> json) =>
      Data(token: json["token"], user: UserLogin.fromJson(json["user"]));

  Map<String, dynamic> toJson() => {"token": token, "user": user.toJson()};
}
