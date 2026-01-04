class PlanModel {
  final int id;
  final String name;
  final String timeValue;
  final double originalPrice;
  final double convertedPrice;
  final String currency;
  final bool isActive;

  PlanModel({
    required this.id,
    required this.name,
    required this.timeValue,
    required this.originalPrice,
    required this.convertedPrice,
    required this.currency,
    required this.isActive,
  });

  factory PlanModel.fromJson(Map<String, dynamic> json) {
    return PlanModel(
      id: json['id'] as int,
      name: json['name'] as String,
      timeValue: json['time_value'] as String,
      originalPrice: (json['original_price'] as num).toDouble(),
      convertedPrice: (json['converted_price'] as num).toDouble(),
      currency: json['currency'] as String,
      isActive: json['is_active'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'time_value': timeValue,
      'original_price': originalPrice,
      'converted_price': convertedPrice,
      'currency': currency,
      'is_active': isActive,
    };
  }
}
