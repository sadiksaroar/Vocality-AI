import 'package:flutter/foundation.dart';
import 'package:vocality_ai/screen/home/drawer/personalty/personalty_model.dart';
import 'package:vocality_ai/screen/home/drawer/profile_dashboard/profile_service/profile_service.dart';

class ProfileController with ChangeNotifier {
  final ProfileService _service;
  UserModel? user;
  bool loading = false;
  String? error;

  ProfileController([ProfileService? service])
    : _service = service ?? ProfileService();

  Future<void> loadProfile() async {
    loading = true;
    error = null;
    notifyListeners();
    try {
      user = await _service.fetchProfile();
    } catch (e) {
      error = e.toString();
      user = null;
    } finally {
      loading = false;
      notifyListeners();
    }
  }
}
