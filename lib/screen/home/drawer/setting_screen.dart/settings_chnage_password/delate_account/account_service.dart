import 'package:http/http.dart' as http;
import 'package:vocality_ai/core/config/app_config.dart';
import 'package:vocality_ai/core/gen/stroge_helper/stroge_helper.dart';
import 'package:vocality_ai/screen/home/drawer/setting_screen.dart/settings_chnage_password/delate_account/model.dart';

class AccountService {
  // Replace with your actual base URL
  static const String baseUrl = AppConfig.httpBase;

  Future<String?> getAuthToken() async {
    try {
      return await StorageHelper.getToken();
    } catch (e) {
      print('Error getting auth token: $e');
      return null;
    }
  }

  Future<DeleteAccountResponse> deleteAccount(String token) async {
    try {
      var headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      };

      var request = http.Request(
        'DELETE',
        Uri.parse('$baseUrl/accounts/user/delete-account/'),
      );

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        print('Account deleted successfully: $responseBody');

        // Clear stored token
        await StorageHelper.clearAll();

        return DeleteAccountResponse(
          success: true,
          message: 'Account deleted successfully',
        );
      } else {
        final responseBody = await response.stream.bytesToString();
        print('Failed to delete account: ${response.reasonPhrase}');
        print('Response body: $responseBody');

        return DeleteAccountResponse(
          success: false,
          message: response.reasonPhrase ?? 'Failed to delete account',
        );
      }
    } catch (e) {
      print('Error deleting account: $e');
      return DeleteAccountResponse(
        success: false,
        message: 'Error: ${e.toString()}',
      );
    }
  }
}
