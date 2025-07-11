import 'dart:convert';

import 'package:absensi_app/api/endpoint.dart';
import 'package:absensi_app/helper/preference.dart';
import 'package:absensi_app/models/list_batch.dart';
import 'package:absensi_app/models/list_training.dart';
import 'package:absensi_app/models/profile_response.dart';
import 'package:absensi_app/models/user_model.dart';
import 'package:http/http.dart' as http;

class ApiService {
  // Public method logout
  Future<void> logout() async {
    await Preferences.clearSession();
  }

  // Header dengan atau tanpa token
  static Future<Map<String, String>> _getHeaders({
    bool includeAuth = true,
  }) async {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (includeAuth) {
      final token = await Preferences.getToken();
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }
    }

    return headers;
  }

  /// Register user
  Future<ProfileResponse?> register({
    String? name,
    String? email,
    String? password,
    String? jenisKelamin,
    String? profilePhotoBase64,
    String? batchId,
    String? trainingId,
  }) async {
    final url = Uri.parse(Endpoint.register);
    try {
      final response = await http.post(
        url,
        headers: await _getHeaders(includeAuth: false),
        body: jsonEncode({
          'name': name,
          'email': email,
          'password': password,
          'jenis_kelamin': jenisKelamin,
          'profile_photo': profilePhotoBase64,
          'batch_id': batchId,
          'training_id': trainingId,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final String? token = data['token'];
        if (token != null) {
          await Preferences.saveToken(token);
        }
        return ProfileResponse.fromJson(data);
      } else {
        return ProfileResponse.fromJson(data);
      }
    } catch (e) {
      print('Error during registration: $e');
      return null;
    }
  }

  /// Login user
  Future<LoginResponse?> login(String email, String password) async {
    final url = Uri.parse(Endpoint.login);
    try {
      final response = await http.post(
        url,
        headers: await _getHeaders(includeAuth: false),
        body: jsonEncode({'email': email, 'password': password}),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final String? token = data['token'];
        if (token != null) {
          await Preferences.saveToken(token);
        }
        return LoginResponse.fromJson(data);
      } else {
        print('Login failed: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error during login: $e');
      return null;
    }
  }

  /// Get profile data
  Future<ProfileResponse?> getProfile() async {
    final url = Uri.parse(Endpoint.profile);

    try {
      final token = await Preferences.getToken();

      // Jika token tidak ada, artinya sesi sudah habis.
      if (token == null || token.isEmpty) {
        await Preferences.clearSession();
        return ProfileResponse(
          message: 'Token tidak tersedia. Mohon login kembali.',
        );
      }

      final headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };

      final response = await http.get(url, headers: headers);

      print('Response Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return ProfileResponse.fromJson(data);
      } else if (response.statusCode == 401) {
        await Preferences.clearSession();
        return ProfileResponse(message: 'Sesi berakhir. Mohon login kembali.');
      } else {
        return ProfileResponse(
          message: data['message'] ?? 'Gagal memuat profil',
          data: null,
        );
      }
    } catch (e) {
      print('Terjadi kesalahan saat memuat profil: $e');
      return ProfileResponse(message: 'Terjadi kesalahan jaringan: $e');
    }
  }

  /// Get batch list
  Future<ListBatchResponse> getBatches() async {
    final url = Uri.parse(Endpoint.getBatch);
    try {
      final response = await http.get(url, headers: await _getHeaders());
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return ListBatchResponse.fromJson(data);
      } else {
        print('Failed to load batches: ${response.statusCode}');
        return ListBatchResponse();
      }
    } catch (e) {
      print('Error getting batches: $e');
      return ListBatchResponse();
    }
  }

  /// Get training list
  Future<ListTrainingResponse> getTrainings() async {
    final url = Uri.parse(Endpoint.getTraining);
    try {
      final response = await http.get(url, headers: await _getHeaders());
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return ListTrainingResponse.fromJson(data);
      } else {
        print('Failed to load trainings: ${response.statusCode}');
        return ListTrainingResponse();
      }
    } catch (e) {
      print('Error getting trainings: $e');
      return ListTrainingResponse();
    }
  }

  Future<bool> updateProfile({
    required String name,
    required String email,
    required String phone,
  }) async {
    final token = await Preferences.getToken();

    final response = await http.put(
      Uri.parse('https://appabsensi.mobileprojp.com/api/profile'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'name': name,
        'email': email,
        'no_telepon': phone, // pastikan key ini sesuai dengan backend
      }),
    );

    print('UPDATE RESPONSE STATUS: ${response.statusCode}');
    print('UPDATE RESPONSE BODY: ${response.body}');

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return json['message'] == 'Profil berhasil diperbarui';
    }

    return false;
  }
}
