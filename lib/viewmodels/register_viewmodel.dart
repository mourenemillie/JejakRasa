import 'package:flutter/foundation.dart';
import '../services/api_service.dart';

enum RegisterState { idle, loading, success, error }

class RegisterViewModel extends ChangeNotifier {
  RegisterState _state = RegisterState.idle;
  String _errorMessage = '';
  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  RegisterState get state => _state;
  String get errorMessage => _errorMessage;
  bool get obscurePassword => _obscurePassword;
  bool get obscureConfirm => _obscureConfirm;
  bool get isLoading => _state == RegisterState.loading;

  void togglePasswordVisibility() {
    _obscurePassword = !_obscurePassword;
    notifyListeners();
  }

  void toggleConfirmVisibility() {
    _obscureConfirm = !_obscureConfirm;
    notifyListeners();
  }

  Future<void> register({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String passwordConfirmation,
  }) async {
    _state = RegisterState.loading;
    _errorMessage = '';
    notifyListeners();

    try {
      final String? errorMessage = await ApiService.register(
        name: name,
        email: email,
        phone: phone,
        password: password,
        passwordConfirmation: passwordConfirmation,
      );

      if (errorMessage == null) {
        _state = RegisterState.success;
      } else {
        _state = RegisterState.error;
        _errorMessage = errorMessage;
      }
    } catch (e) {
      _state = RegisterState.error;
      _errorMessage = 'Error koneksi: $e';
    }

    notifyListeners();
  }

  void reset() {
    _state = RegisterState.idle;
    _errorMessage = '';
    notifyListeners();
  }
}
