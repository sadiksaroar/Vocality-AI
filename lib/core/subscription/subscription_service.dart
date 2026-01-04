import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:vocality_ai/core/gen/stroge_helper/stroge_helper.dart';
import 'models/personality_model.dart';
import 'models/time_package_model.dart';
import 'models/plan_model.dart';
import 'models/subscription_status_model.dart';

class SubscriptionApiService {
  static const String baseUrl = 'http://10.10.7.74:8000';
  final String? authToken;

  SubscriptionApiService({this.authToken});

  Future<Map<String, String>> _getHeaders() async {
    String? token = authToken;
    if (token == null || token.isEmpty) {
      token = await StorageHelper.getToken();
      print(
        '📝 Retrieved token from storage: ${token != null ? "Yes (${token.length} chars)" : "No"}',
      );
    }

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${token ?? ''}',
    };

    print(
      '🔑 Authorization header: Bearer ${token?.substring(0, token.length > 10 ? 10 : token.length)}...',
    );
    return headers;
  }

  // Get subscription status
  Future<SubscriptionStatusModel> getSubscriptionStatus() async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/subscription/subscription/status/'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        return SubscriptionStatusModel.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to get subscription status: ${response.body}');
      }
    } catch (e) {
      print('❌ Error getting subscription status: $e');
      rethrow;
    }
  }

  // Get available personalities
  Future<List<PersonalityModel>> getAvailablePersonalities() async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse(
          '$baseUrl/subscription/subscription/available_personalities/',
        ),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((e) => PersonalityModel.fromJson(e)).toList();
      } else {
        throw Exception('Failed to get personalities: ${response.body}');
      }
    } catch (e) {
      print('❌ Error getting personalities: $e');
      rethrow;
    }
  }

  // Get available time packages
  Future<List<TimePackageModel>> getAvailableTimePackages() async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse(
          '$baseUrl/subscription/subscription/available_time_packages/',
        ),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((e) => TimePackageModel.fromJson(e)).toList();
      } else {
        throw Exception('Failed to get time packages: ${response.body}');
      }
    } catch (e) {
      print('❌ Error getting time packages: $e');
      rethrow;
    }
  }

  // Get available plans
  Future<List<PlanModel>> getAvailablePlans() async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/subscription/subscription/available_plans/'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((e) => PlanModel.fromJson(e)).toList();
      } else {
        throw Exception('Failed to get plans: ${response.body}');
      }
    } catch (e) {
      print('❌ Error getting plans: $e');
      rethrow;
    }
  }

  // Purchase personality
  Future<Map<String, dynamic>> purchasePersonality({
    required int personalityId,
    required String paymentId,
    required String amountPaid,
    required String currency,
  }) async {
    try {
      final headers = await _getHeaders();
      final response = await http.post(
        Uri.parse('$baseUrl/subscription/subscription/purchase_personality/'),
        headers: headers,
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
        throw Exception('Purchase failed: ${response.body}');
      }
    } catch (e) {
      print('❌ Error purchasing personality: $e');
      rethrow;
    }
  }

  // Purchase time package
  Future<Map<String, dynamic>> purchaseTimePackage({
    required int timeManagementId,
    required String paymentId,
    required String amountPaid,
    required String currency,
  }) async {
    try {
      final headers = await _getHeaders();
      final response = await http.post(
        Uri.parse('$baseUrl/subscription/subscription/purchase_time/'),
        headers: headers,
        body: json.encode({
          'time_management_id': timeManagementId,
          'payment_id': paymentId,
          'amount_paid': amountPaid,
          'currency': currency,
        }),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Purchase failed: ${response.body}');
      }
    } catch (e) {
      print('❌ Error purchasing time package: $e');
      rethrow;
    }
  }

  // Purchase subscription plan
  Future<Map<String, dynamic>> purchaseSubscriptionPlan({
    required int planId,
    required String paymentId,
    required String amountPaid,
    required String currency,
  }) async {
    try {
      final headers = await _getHeaders();
      final response = await http.post(
        Uri.parse('$baseUrl/subscription/subscription/purchase_plan/'),
        headers: headers,
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
        throw Exception('Purchase failed: ${response.body}');
      }
    } catch (e) {
      print('❌ Error purchasing plan: $e');
      rethrow;
    }
  }

  // Update country
  Future<void> updateCountry(String countryCode) async {
    try {
      final headers = await _getHeaders();
      final response = await http.post(
        Uri.parse('$baseUrl/subscription/subscription/update_country/'),
        headers: headers,
        body: json.encode({'country_code': countryCode}),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to update country: ${response.body}');
      }
    } catch (e) {
      print('❌ Error updating country: $e');
      rethrow;
    }
  }

  // Get purchase history
  Future<List<Map<String, dynamic>>> getPurchaseHistory() async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/subscription/subscription/purchase_history/'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.cast<Map<String, dynamic>>();
      } else {
        throw Exception('Failed to get purchase history: ${response.body}');
      }
    } catch (e) {
      print('❌ Error getting purchase history: $e');
      rethrow;
    }
  }
}
