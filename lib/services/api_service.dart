import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class ApiService {
  static const String baseUrl = 'https://mola.forloop.my.id/api';
  static const String apiKey = 'moL@-2026';

  static Map<String, String> _headers({String? token}) {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'api-key': apiKey,
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // Ambil token dari SharedPreferences
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  // Hapus token (logout)
  static Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }

  // 1. LOGIN (POST /api/login)
  static Future<bool> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: _headers(),
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      if (body['success'] == true && body['data'] != null) {
        final String token = body['data']['token'];
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);
        return true;
      }
    }
    return false;
  }

  // 2. REGISTER (POST /api/register)
  // Mengembalikan null jika sukses, atau String pesan error jika gagal
  static Future<String?> register({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String passwordConfirmation,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: _headers(),
      body: jsonEncode({
        'name': name,
        'email': email,
        'phone': phone,
        'password': password,
        'password_confirmation': passwordConfirmation,
      }),
    );

    final body = jsonDecode(response.body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return null; // Sukses
    }
    return body['message'] ?? 'Registrasi gagal. Periksa kembali data Anda.';
  }

  // 3. GET PROFILE (GET /api/profile)
  static Future<UserModel?> getProfile() async {
    final token = await getToken();
    if (token == null) return null;

    final response = await http.get(
      Uri.parse('$baseUrl/profile'),
      headers: _headers(token: token),
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      final rawData = body['data'] ?? body;
      final userData =
          (rawData is Map<String, dynamic> && rawData['user'] != null)
              ? rawData['user']
              : rawData;
      return UserModel.fromJson(userData);
    }
    return null;
  }

  // 4. UPDATE PROFILE (PUT /api/profile)
  static Future<String?> updateProfile({
    required String name,
    required String phone,
  }) async {
    final token = await getToken();
    if (token == null) return 'Sesi tidak ditemukan, silakan login ulang.';

    final response = await http.put(
      Uri.parse('$baseUrl/profile'),
      headers: _headers(token: token),
      body: jsonEncode({
        'name': name,
        'phone': phone,
      }),
    );

    final body = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return null; // Sukses
    }
    return body['message'] ?? 'Gagal memperbarui profil.';
  }

  // 5. LOGOUT (POST /api/logout)
  static Future<bool> logout() async {
    final token = await getToken();
    if (token == null) return true;

    try {
      await http.post(
        Uri.parse('$baseUrl/logout'),
        headers: _headers(token: token),
      );
    } catch (_) {}

    await clearToken();
    return true;
  }
}