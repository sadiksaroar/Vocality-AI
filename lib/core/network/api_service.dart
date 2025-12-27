import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:vocality_ai/core/config/app_config.dart';
import 'package:vocality_ai/core/gen/stroge_helper/stroge_helper.dart';

class ApiService {
  Future<Map<String, dynamic>> sendMessage({
    required int personalityId,
    required String message,
  }) async {
    final token = await StorageHelper.getToken();
    final headers = {
      'Content-Type': 'application/json',
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    };

    final resp = await http.post(
      Uri.parse(AppConfig.sendMessageUrl),
      headers: headers,
      body: json.encode({'personality_id': personalityId, 'message': message}),
    );

    if (resp.statusCode == 200) {
      return json.decode(resp.body) as Map<String, dynamic>;
    } else {
      throw Exception('HTTP ${resp.statusCode}: ${resp.reasonPhrase}');
    }
  }

  Future<void> endActiveConversation({required int personalityId}) async {
    final token = await StorageHelper.getToken();
    final headers = {
      'Content-Type': 'application/json',
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    };

    final resp = await http.post(
      Uri.parse(AppConfig.endActiveUrl),
      headers: headers,
      body: json.encode({'personality_id': personalityId}),
    );

    if (resp.statusCode == 200) {
      print('✅ Conversation ended: ${await resp.body}');
    } else {
      throw Exception('HTTP ${resp.statusCode}: ${resp.reasonPhrase}');
    }
  }
}
