import 'package:flutter/foundation.dart';
import '../services/api_service.dart';

enum LoginState { idle, loading, success, error }

class LoginViewModel extends ChangeNotifier {
  LoginState _state = LoginState.idle;
  String _errorMessage = '';
  bool _obscurePassword = true;

  LoginState get state => _state;
  String get errorMessage => _errorMessage;
  bool get obscurePassword => _obscurePassword;
  bool get isLoading => _state == LoginState.loading;

  void togglePasswordVisibility() {
    _obscurePassword = !_obscurePassword;
    notifyListeners();
  }

  Future<void> login(String email, String password) async {
    _state = LoginState.loading;
    _errorMessage = '';
    notifyListeners();

    try {
      final bool success = await ApiService.login(email, password);

      if (success) {
        _state = LoginState.success;
      } else {
        _state = LoginState.error;
        _errorMessage = 'Email atau password salah';
      }
    } catch (e) {
      _state = LoginState.error;
      _errorMessage = 'Error koneksi: $e';
    }

    notifyListeners();
  }

  void reset() {
    _state = LoginState.idle;
    _errorMessage = '';
    notifyListeners();
  }
}
