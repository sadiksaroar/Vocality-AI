class TimePackageModel {
  final int id;
  final String name;
  final String timeValue;
  final double originalPrice;
  final double convertedPrice;
  final String currency;
  final bool discountApplied;
  final int discountPercentage;

  TimePackageModel({
    required this.id,
    required this.name,
    required this.timeValue,
    required this.originalPrice,
    required this.convertedPrice,
    required this.currency,
    required this.discountApplied,
    required this.discountPercentage,
  });

  factory TimePackageModel.fromJson(Map<String, dynamic> json) {
    return TimePackageModel(
      id: json['id'] as int,
      name: json['name'] as String,
      timeValue: json['time_value'] as String,
      originalPrice: (json['original_price'] as num).toDouble(),
      convertedPrice: (json['converted_price'] as num).toDouble(),
      currency: json['currency'] as String,
      discountApplied: json['discount_applied'] as bool? ?? false,
      discountPercentage: json['discount_percentage'] as int? ?? 0,
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
      'discount_applied': discountApplied,
      'discount_percentage': discountPercentage,
    };
  }
}
