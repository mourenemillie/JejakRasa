import 'package:flutter/foundation.dart';
import '../services/api_service.dart';

class SplashViewModel extends ChangeNotifier {
  /// Mengecek status login user.
  /// Mengembalikan '/home' jika token valid, atau '/login' jika belum/kadaluarsa.
  Future<String> checkAuthStatus() async {
    // Jeda 2 detik agar tampilan splash screen terlihat smooth
    await Future.delayed(const Duration(seconds: 2));

    final token = await ApiService.getToken();
    if (token == null || token.isEmpty) {
      return '/login';
    }

    // Opsional tapi aman: cek apakah token masih aktif di server
    try {
      final user = await ApiService.getProfile();
      if (user != null) {
        return '/home';
      } else {
        await ApiService.clearToken();
        return '/login';
      }
    } catch (_) {
      // Jika koneksi bermasalah tapi token lokal ada, tetap lanjut ke home
      return '/home';
    }
  }
}