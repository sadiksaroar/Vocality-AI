import 'personality_model.dart';

class SubscriptionStatusModel {
  final int id;
  final String remainingMinutes;
  final String dailyMinutesUsed;
  final List<PersonalityModel> ownedPersonalities;
  final List<PersonalityModel> accessiblePersonalities;
  final PlanDetails? activePlanDetails;
  final String? planExpiresAt;
  final bool hasActivePlan;
  final int dailyLimit;
  final double discountRate;
  final String countryCode;

  SubscriptionStatusModel({
    required this.id,
    required this.remainingMinutes,
    required this.dailyMinutesUsed,
    required this.ownedPersonalities,
    required this.accessiblePersonalities,
    this.activePlanDetails,
    this.planExpiresAt,
    required this.hasActivePlan,
    required this.dailyLimit,
    required this.discountRate,
    required this.countryCode,
  });

  factory SubscriptionStatusModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionStatusModel(
      id: json['id'] as int,
      remainingMinutes: json['remaining_minutes'] as String? ?? '0.00',
      dailyMinutesUsed: json['daily_minutes_used'] as String? ?? '0.00',
      ownedPersonalities: (json['owned_personalities'] as List? ?? [])
          .map((e) => PersonalityModel.fromJson(e))
          .toList(),
      accessiblePersonalities: (json['accessible_personalities'] as List? ?? [])
          .map((e) => PersonalityModel.fromJson(e))
          .toList(),
      activePlanDetails: json['active_plan_details'] != null
          ? PlanDetails.fromJson(json['active_plan_details'])
          : null,
      planExpiresAt: json['plan_expires_at'] as String?,
      hasActivePlan: json['has_active_plan'] as bool? ?? false,
      dailyLimit: json['daily_limit'] as int? ?? 0,
      discountRate: (json['discount_rate'] as num?)?.toDouble() ?? 0.0,
      countryCode: json['country_code'] as String? ?? 'US',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'remaining_minutes': remainingMinutes,
      'daily_minutes_used': dailyMinutesUsed,
      'owned_personalities': ownedPersonalities.map((e) => e.toJson()).toList(),
      'accessible_personalities': accessiblePersonalities
          .map((e) => e.toJson())
          .toList(),
      'active_plan_details': activePlanDetails?.toJson(),
      'plan_expires_at': planExpiresAt,
      'has_active_plan': hasActivePlan,
      'daily_limit': dailyLimit,
      'discount_rate': discountRate,
      'country_code': countryCode,
    };
  }
}

class PlanDetails {
  final int id;
  final String planName;
  final String planPrice;
  final String planTime;

  PlanDetails({
    required this.id,
    required this.planName,
    required this.planPrice,
    required this.planTime,
  });

  factory PlanDetails.fromJson(Map<String, dynamic> json) {
    return PlanDetails(
      id: json['id'] as int,
      planName: json['plan_name'] as String,
      planPrice: json['plan_price'] as String,
      planTime: json['plan_time'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'plan_name': planName,
      'plan_price': planPrice,
      'plan_time': planTime,
    };
  }
}
