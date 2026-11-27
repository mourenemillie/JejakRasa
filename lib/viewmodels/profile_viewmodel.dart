import 'package:flutter/foundation.dart';
import '../services/api_service.dart';
import '../models/user_model.dart';

enum ProfileState { idle, loading, loaded, updating, success, error }

class ProfileViewModel extends ChangeNotifier {
  ProfileState _state = ProfileState.idle;
  UserModel? _user;
  String _errorMessage = '';

  ProfileState get state => _state;
  UserModel? get user => _user;
  String get errorMessage => _errorMessage;
  bool get isLoading => _state == ProfileState.loading;
  bool get isUpdating => _state == ProfileState.updating;

  Future<void> loadProfile() async {
    _state = ProfileState.loading;
    _errorMessage = '';
    notifyListeners();

    try {
      final user = await ApiService.getProfile();
      if (user != null) {
        _user = user;
        _state = ProfileState.loaded;
      } else {
        _state = ProfileState.error;
        _errorMessage = 'Gagal memuat profil. Silakan coba lagi.';
      }
    } catch (e) {
      _state = ProfileState.error;
      _errorMessage = 'Error koneksi: $e';
    }

    notifyListeners();
  }

  Future<bool> updateProfile({
    required String name,
    required String phone,
  }) async {
    _state = ProfileState.updating;
    _errorMessage = '';
    notifyListeners();

    try {
      final error = await ApiService.updateProfile(name: name, phone: phone);
      if (error == null) {
        // Update local user data
        _user = UserModel(
          name: name,
          email: _user?.email ?? '',
          phone: phone,
          token: _user?.token ?? '',
        );
        _state = ProfileState.loaded;
        notifyListeners();
        return true;
      } else {
        _state = ProfileState.error;
        _errorMessage = error;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _state = ProfileState.error;
      _errorMessage = 'Error koneksi: $e';
      notifyListeners();
      return false;
    }
  }

  Future<bool> logout() async {
    _state = ProfileState.loading;
    notifyListeners();
    final result = await ApiService.logout();
    _user = null;
    _state = ProfileState.idle;
    notifyListeners();
    return result;
  }

  void reset() {
    if (_state == ProfileState.error) {
      _state = _user != null ? ProfileState.loaded : ProfileState.idle;
      _errorMessage = '';
      notifyListeners();
    }
  }
}
