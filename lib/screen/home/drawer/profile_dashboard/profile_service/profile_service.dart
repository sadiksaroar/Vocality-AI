import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:vocality_ai/screen/home/drawer/profile_dashboard/profile_model/profile_model.dart';

class ProfileService {
  static const String baseUrl = 'http://10.10.7.24:8000';

  Future<ProfileModel?> fetchUserProfile(String authToken) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/accounts/user/profile/'),
        headers: {
          'Authorization': 'Bearer $authToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return ProfileModel.fromJson(data);
      }
      return null;
    } catch (e) {
      print('Error fetching profile: $e');
      rethrow;
    }
  }
}
