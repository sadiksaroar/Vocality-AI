class ProfileModel {
  final int id;
  final String email;
  final String name;
  final bool isAdmin;
  final String image;
  final double remainingMinutes;
  final List<Personality> ownedPersonalities;
  final int purchasedPersonalitiesCount;
  final double dailyMinutesUsed;
  final double dailyRemainingMinutes;
  final double totalAvailableMinutes;
  final String couponId;

  ProfileModel({
    required this.id,
    required this.email,
    required this.name,
    required this.isAdmin,
    required this.image,
    required this.remainingMinutes,
    required this.ownedPersonalities,
    required this.purchasedPersonalitiesCount,
    required this.dailyMinutesUsed,
    required this.dailyRemainingMinutes,
    required this.totalAvailableMinutes,
    required this.couponId,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'] ?? 0,
      email: json['email'] ?? '',
      name: json['name'] ?? '',
      isAdmin: json['is_admin'] ?? false,
      image: json['image'] ?? '',
      remainingMinutes: (json['remaining_minutes'] ?? 0).toDouble(),
      ownedPersonalities:
          (json['owned_personalities'] as List<dynamic>?)
              ?.map((e) => Personality.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      purchasedPersonalitiesCount: json['purchased_personalities_count'] ?? 0,
      dailyMinutesUsed: (json['daily_minutes_used'] ?? 0).toDouble(),
      dailyRemainingMinutes: (json['daily_remaining_minutes'] ?? 0).toDouble(),
      totalAvailableMinutes: (json['total_available_minutes'] ?? 0).toDouble(),
      couponId: json['coupon_id'] ?? '',
    );
  }
}

class Personality {
  final int id;
  final String name;

  Personality({required this.id, required this.name});

  factory Personality.fromJson(Map<String, dynamic> json) {
    return Personality(id: json['id'] ?? 0, name: json['name'] ?? '');
  }
}
