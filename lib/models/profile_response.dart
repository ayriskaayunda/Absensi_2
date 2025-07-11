class ProfileResponse {
  final String? message;
  final UserData? data;

  ProfileResponse({this.message, this.data});

  factory ProfileResponse.fromJson(Map<String, dynamic> json) {
    return ProfileResponse(
      message: json['message'],
      data: json['data'] != null ? UserData.fromJson(json['data']) : null,
    );
  }
}

class UserData {
  final String? name;
  final String? email;
  final String? jenisKelamin;
  final String? profilePhoto;
  final String? noTelp;
  final Batch? batch;
  final Training? training;

  UserData({
    this.name,
    this.email,
    this.jenisKelamin,
    this.profilePhoto,
    this.noTelp,
    this.batch,
    this.training,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      name: json['name'],
      email: json['email'],
      jenisKelamin: json['jenis_kelamin'],
      profilePhoto: json['profile_photo'],
      noTelp: json['no_telepon'], // ✅ sesuaikan dengan key dari backend
      batch: json['batch'] != null ? Batch.fromJson(json['batch']) : null,
      training: json['training'] != null
          ? Training.fromJson(json['training'])
          : null,
    );
  }
}

class Batch {
  final String? batchKe;
  final DateTime? startDate;
  final DateTime? endDate;

  Batch({this.batchKe, this.startDate, this.endDate});

  factory Batch.fromJson(Map<String, dynamic> json) {
    return Batch(
      batchKe: json['batch_ke'],
      startDate: json['start_date'] != null
          ? DateTime.parse(json['start_date'])
          : null,
      endDate: json['end_date'] != null
          ? DateTime.parse(json['end_date'])
          : null,
    );
  }
}

class Training {
  final String? title;
  final String? description;
  final int? participantCount;
  final int? duration;

  Training({
    this.title,
    this.description,
    this.participantCount,
    this.duration,
  });

  factory Training.fromJson(Map<String, dynamic> json) {
    return Training(
      title: json['title'],
      description: json['description'],
      participantCount: json['participant_count'],
      duration: json['duration'],
    );
  }
}
