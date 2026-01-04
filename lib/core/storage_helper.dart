import 'package:shared_preferences/shared_preferences.dart';

class StorageHelper {
  static const String _tokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _emailKey = 'user_email';
  static const String _isPremiumKey = 'is_premium_user';
  static const String _ownedPersonalitiesKey = 'owned_personalities';
  static const String _activeSubscriptionKey = 'active_subscription_id';
  static const String _remainingTimeKey = 'remaining_talk_time';

  // ...existing code...

  // Premium status
  static Future<void> setPremiumStatus(bool isPremium) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isPremiumKey, isPremium);
  }

  static Future<bool> isPremiumUser() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isPremiumKey) ?? false;
  }

  // Owned personalities
  static Future<void> saveOwnedPersonalities(List<int> personalityIds) async {
    final prefs = await SharedPreferences.getInstance();
    final idsString = personalityIds.join(',');
    await prefs.setString(_ownedPersonalitiesKey, idsString);
  }

  static Future<List<int>> getOwnedPersonalities() async {
    final prefs = await SharedPreferences.getInstance();
    final idsString = prefs.getString(_ownedPersonalitiesKey);
    if (idsString == null || idsString.isEmpty) return [];
    return idsString.split(',').map((e) => int.parse(e)).toList();
  }

  static Future<bool> ownsPersonality(int personalityId) async {
    final owned = await getOwnedPersonalities();
    return owned.contains(personalityId);
  }

  // Active subscription
  static Future<void> saveActiveSubscription(int? subscriptionId) async {
    final prefs = await SharedPreferences.getInstance();
    if (subscriptionId == null) {
      await prefs.remove(_activeSubscriptionKey);
    } else {
      await prefs.setInt(_activeSubscriptionKey, subscriptionId);
    }
  }

  static Future<int?> getActiveSubscription() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_activeSubscriptionKey);
  }

  // Remaining talk time
  static Future<void> saveRemainingTime(int minutes) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_remainingTimeKey, minutes);
  }

  static Future<int> getRemainingTime() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_remainingTimeKey) ?? 0;
  }

  static Future<void> saveToken(String? token) async {
    final prefs = await SharedPreferences.getInstance();
    if (token == null || token.trim().isEmpty) {
      await prefs.remove(_tokenKey);
      return;
    }
    await prefs.setString(_tokenKey, token.trim());
  }

  static Future<void> saveRefreshToken(String? token) async {
    final prefs = await SharedPreferences.getInstance();
    if (token == null || token.trim().isEmpty) {
      await prefs.remove(_refreshTokenKey);
      return;
    }
    await prefs.setString(_refreshTokenKey, token.trim());
  }

  static Future<void> saveEmail(String? email) async {
    final prefs = await SharedPreferences.getInstance();
    if (email == null || email.trim().isEmpty) {
      await prefs.remove(_emailKey);
      return;
    }
    await prefs.setString(_emailKey, email.trim());
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey)?.trim();
  }

  static Future<String?> getRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_refreshTokenKey)?.trim();
  }

  static Future<String?> getEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_emailKey)?.trim();
  }

  static Future<bool> hasToken() async {
    final prefs = await SharedPreferences.getInstance();
    final t = prefs.getString(_tokenKey);
    return t != null && t.trim().isNotEmpty;
  }

  static Future<void> removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }

  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
