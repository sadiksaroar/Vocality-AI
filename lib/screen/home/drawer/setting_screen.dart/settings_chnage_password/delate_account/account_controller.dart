// lib/controllers/account_controller.dart

import 'package:get/get.dart';
import 'package:vocality_ai/screen/home/drawer/setting_screen.dart/settings_chnage_password/delate_account/account_service.dart';

class AccountController extends GetxController {
  final AccountService _accountService = AccountService();

  var isLoading = false.obs;
  var errorMessage = ''.obs;

  Future<bool> deleteAccount() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // Get auth token
      final token = await _accountService.getAuthToken();

      if (token == null || token.isEmpty) {
        errorMessage.value = 'Authentication token not found';
        isLoading.value = false;
        return false;
      }

      // Call delete API
      final response = await _accountService.deleteAccount(token);

      if (response.success) {
        // success; UI will handle notifications/navigation
        isLoading.value = false;
        return true;
      } else {
        errorMessage.value = response.message;
        isLoading.value = false;
        return false;
      }
    } catch (e) {
      errorMessage.value = 'An unexpected error occurred';
      isLoading.value = false;
      return false;
    }
  }

  @override
  void onClose() {
    // Clean up
    super.onClose();
  }
}
