import 'package:shared_preferences/shared_preferences.dart';

class StorageHelper {
  static const String _tokenKey = "access_token";
  static const String _refreshTokenKey = "refresh_token";
  static const String _emailKey = "user_email";
  static const String _isPremiumKey = 'is_premium_user';
  static const String _ownedPersonalitiesKey = 'owned_personalities';

  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token.trim());
    print("✅ Token Saved");
  }

  static Future<void> saveRefreshToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_refreshTokenKey, token.trim());
  }

  static Future<void> saveEmail(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_emailKey, email.trim());
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey)?.trim();
  }

  static Future<String?> getEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_emailKey)?.trim();
  }

  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

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
}
