import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:vocality_ai/core/config/app_config.dart';
import 'package:vocality_ai/core/storage_helper.dart';

class ApiService {
  // Helper method to get headers with authentication token
  Future<Map<String, String>> _getHeaders() async {
    final token = await StorageHelper.getToken();
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  // Get available personalities
  Future<List<Map<String, dynamic>>> getAvailablePersonalities() async {
    final headers = await _getHeaders();
    final response = await http.get(
      Uri.parse(
        '${AppConfig.httpBase}/subscription/subscription/available_personalities/',
      ),
      headers: headers,
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
    final headers = await _getHeaders();
    final response = await http.get(
      Uri.parse(
        '${AppConfig.httpBase}/subscription/subscription/available_time_packages/',
      ),
      headers: headers,
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
    final headers = await _getHeaders();
    final response = await http.get(
      Uri.parse(
        '${AppConfig.httpBase}/subscription/subscription/available_plans/',
      ),
      headers: headers,
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

  // Purchase time package with payment details
  Future<void> purchaseTimePackage(
    int packageId, {
    required String paymentId,
    required String amountPaid,
    required String currency,
  }) async {
    print('🔵 Purchasing time package...');
    print('   Package ID: $packageId');
    print('   Payment ID: $paymentId');
    print('   Amount: $amountPaid $currency');

    final headers = await _getHeaders();
    final body = {
      'time_management_id': packageId,
      'payment_id': paymentId,
      'amount_paid': amountPaid,
      'currency': currency,
    };

    print('   Request Body: ${json.encode(body)}');

    final response = await http.post(
      Uri.parse(
        '${AppConfig.httpBase}/subscription/subscription/purchase_time/',
      ),
      headers: headers,
      body: json.encode(body),
    );

    print('   Response Status: ${response.statusCode}');
    print('   Response Body: ${response.body}');

    if (response.statusCode == 200) {
      print('✅ Time package purchased successfully!');
    } else {
      print('❌ Failed to purchase time package');
      throw Exception('Failed to purchase time package: ${response.body}');
    }
  }

  // Purchase personality with payment details
  Future<void> purchasePersonality(
    int personalityId, {
    required String paymentId,
    required String amountPaid,
    required String currency,
  }) async {
    print('🔵 Purchasing personality...');
    print('   Personality ID: $personalityId');
    print('   Payment ID: $paymentId');
    print('   Amount: $amountPaid $currency');

    final headers = await _getHeaders();
    final body = {
      'personality_id': personalityId,
      'payment_id': paymentId,
      'amount_paid': amountPaid,
      'currency': currency,
    };

    print('   Request Body: ${json.encode(body)}');

    final response = await http.post(
      Uri.parse(
        '${AppConfig.httpBase}/subscription/subscription/purchase_personality/',
      ),
      headers: headers,
      body: json.encode(body),
    );

    print('   Response Status: ${response.statusCode}');
    print('   Response Body: ${response.body}');

    if (response.statusCode == 200) {
      print('✅ Personality purchased successfully!');
    } else {
      print('❌ Failed to purchase personality');
      throw Exception('Failed to purchase personality: ${response.body}');
    }
  }

  // Subscribe to plan with payment details
  Future<void> subscribeToPlan(
    int planId, {
    required String paymentId,
    required String amountPaid,
    required String currency,
  }) async {
    print('🔵 Subscribing to plan...');
    print('   Plan ID: $planId');
    print('   Payment ID: $paymentId');
    print('   Amount: $amountPaid $currency');

    final headers = await _getHeaders();
    final body = {
      'plan_id': planId,
      'payment_id': paymentId,
      'amount_paid': amountPaid,
      'currency': currency,
    };

    print('   Request Body: ${json.encode(body)}');

    final response = await http.post(
      Uri.parse(
        '${AppConfig.httpBase}/subscription/subscription/purchase_plan/',
      ),
      headers: headers,
      body: json.encode(body),
    );

    print('   Response Status: ${response.statusCode}');
    print('   Response Body: ${response.body}');

    if (response.statusCode == 200) {
      print('✅ Plan subscription successful!');
    } else {
      print('❌ Failed to subscribe to plan');
      throw Exception('Failed to subscribe to plan: ${response.body}');
    }
  }
}
