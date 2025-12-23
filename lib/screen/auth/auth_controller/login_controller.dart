import 'package:flutter/material.dart';
import 'package:vocality_ai/screen/auth/auth_model/login_model.dart';
import 'package:vocality_ai/screen/auth/auth_service/login_service.dart';

class LoginController extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  bool _isLoading = false;
  String? _errorMessage;
  LoginResponse? _loginResponse;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  LoginResponse? get loginResponse => _loginResponse;
  bool get isLoggedIn => _loginResponse != null;

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Validate email and password
      if (email.isEmpty || password.isEmpty) {
        _errorMessage = 'Email and password are required';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
        _errorMessage = 'Invalid email format';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      if (password.length < 6) {
        _errorMessage = 'Password must be at least 6 characters';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      _loginResponse = await _apiService.login(email, password);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> logout() async {
    _isLoading = true;
    notifyListeners();

    final result = await _apiService.logout();
    _loginResponse = null;
    _errorMessage = null;
    _isLoading = false;
    notifyListeners();

    return result;
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
