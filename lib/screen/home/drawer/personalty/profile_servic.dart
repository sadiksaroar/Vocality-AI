import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:vocality_ai/core/gen/stroge_helper/stroge_helper.dart';
import 'package:vocality_ai/screen/home/drawer/personalty/personalty_model.dart';

class ProfileService {
  final String _baseUrl = 'http://10.10.7.24:8000';

  Future<UserModel> fetchProfile() async {
    final token = await StorageHelper.getToken();
    if (token == null || token.isEmpty) {
      throw Exception('No access token found');
    }

    final uri = Uri.parse('$_baseUrl/accounts/user/profile/');
    final resp = await http.get(
      uri,
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (resp.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(resp.body);
      return UserModel.fromJson(data);
    } else {
      throw Exception(
        'Failed to fetch profile: ${resp.statusCode} ${resp.reasonPhrase}',
      );
    }
  }
}
