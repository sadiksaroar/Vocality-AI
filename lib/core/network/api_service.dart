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

    print('➡️ [API] POST ${AppConfig.sendMessageUrl}');
    print('   Authorization present: ${token != null && token.isNotEmpty}');
    print('   Headers: $headers');

    final resp = await http.post(
      Uri.parse(AppConfig.sendMessageUrl),
      headers: headers,
      body: json.encode({'personality_id': personalityId, 'message': message}),
    );

    if (resp.statusCode == 200) {
      return json.decode(resp.body) as Map<String, dynamic>;
    } else {
      print('⛔ [API] ${resp.statusCode} ${resp.reasonPhrase}');
      print('   Response body: ${resp.body}');
      throw Exception(
        'HTTP ${resp.statusCode}: ${resp.reasonPhrase} - ${resp.body}',
      );
    }
  }

  Future<void> endActiveConversation({required int personalityId}) async {
    final token = await StorageHelper.getToken();
    final headers = {
      'Content-Type': 'application/json',
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    };

    print('➡️ [API] POST ${AppConfig.endActiveUrl}');
    print('   Authorization present: ${token != null && token.isNotEmpty}');

    final resp = await http.post(
      Uri.parse(AppConfig.endActiveUrl),
      headers: headers,
      body: json.encode({'personality_id': personalityId}),
    );

    if (resp.statusCode == 200) {
      print('✅ Conversation ended: ${await resp.body}');
    } else {
      print('⛔ [API] ${resp.statusCode} ${resp.reasonPhrase}');
      print('   Response body: ${resp.body}');
      throw Exception(
        'HTTP ${resp.statusCode}: ${resp.reasonPhrase} - ${resp.body}',
      );
    }
  }

  /// Fetch app logo / branding metadata
  Future<dynamic> getLogo() async {
    final token = await StorageHelper.getToken();
    final headers = {
      'Content-Type': 'application/json',
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    };

    print('➡️ [API] GET ${AppConfig.logoUrl}');
    print('   Authorization present: ${token != null && token.isNotEmpty}');

    final resp = await http.get(Uri.parse(AppConfig.logoUrl), headers: headers);

    if (resp.statusCode == 200) {
      return json.decode(resp.body);
    } else {
      print('⛔ [API] ${resp.statusCode} ${resp.reasonPhrase}');
      print('   Response body: ${resp.body}');
      throw Exception(
        'HTTP ${resp.statusCode}: ${resp.reasonPhrase} - ${resp.body}',
      );
    }
  }

  // Get available personalities
  Future<List<Map<String, dynamic>>> getAvailablePersonalities() async {
    final token = await StorageHelper.getToken();
    final response = await http.get(
      Uri.parse(
        '${AppConfig.httpBase}/subscription/subscription/available_personalities/',
      ),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return List<Map<String, dynamic>>.from(data);
    } else {
      throw Exception('Failed to load personalities: ${response.statusCode}');
    }
  }

  // Get available time packages
  Future<List<Map<String, dynamic>>> getAvailableTimePackages() async {
    final token = await StorageHelper.getToken();
    final response = await http.get(
      Uri.parse(
        '${AppConfig.httpBase}/subscription/subscription/available_time_packages/',
      ),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return List<Map<String, dynamic>>.from(data);
    } else {
      throw Exception('Failed to load time packages: ${response.statusCode}');
    }
  }

  // Get available subscription plans
  Future<List<Map<String, dynamic>>> getAvailablePlans() async {
    final token = await StorageHelper.getToken();
    final response = await http.get(
      Uri.parse(
        '${AppConfig.httpBase}/subscription/subscription/available_plans/',
      ),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return List<Map<String, dynamic>>.from(data);
    } else {
      throw Exception(
        'Failed to load subscription plans: ${response.statusCode}',
      );
    }
  }

  // Purchase time package
  Future<Map<String, dynamic>> purchaseTimePackage(
    int packageId, {
    required String paymentId,
    required String amountPaid,
    required String currency,
  }) async {
    final token = await StorageHelper.getToken();
    final response = await http.post(
      Uri.parse(
        '${AppConfig.httpBase}/subscription/subscription/purchase_time/',
      ),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'time_management_id': packageId,
        'payment_id': paymentId,
        'amount_paid': amountPaid,
        'currency': currency,
      }),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to purchase package: ${response.body}');
    }
  }

  // Purchase personality
  Future<Map<String, dynamic>> purchasePersonality(
    int personalityId, {
    required String paymentId,
    required String amountPaid,
    required String currency,
  }) async {
    final token = await StorageHelper.getToken();
    final response = await http.post(
      Uri.parse(
        '${AppConfig.httpBase}/subscription/subscription/purchase_personality/',
      ),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'personality_id': personalityId,
        'payment_id': paymentId,
        'amount_paid': amountPaid,
        'currency': currency,
      }),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to purchase personality: ${response.body}');
    }
  }

  // Subscribe to plan
  Future<Map<String, dynamic>> subscribeToPlan(
    int planId, {
    required String paymentId,
    required String amountPaid,
    required String currency,
  }) async {
    final token = await StorageHelper.getToken();
    final response = await http.post(
      Uri.parse(
        '${AppConfig.httpBase}/subscription/subscription/purchase_plan/',
      ),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'plan_id': planId,
        'payment_id': paymentId,
        'amount_paid': amountPaid,
        'currency': currency,
      }),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to subscribe: ${response.body}');
    }
  }
}
