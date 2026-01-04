class PersonalityModel {
  final int id;
  final String name;
  final String originalPrice;
  final String convertedPrice;
  final String currency;
  final bool isOwned;
  final bool isFree;

  PersonalityModel({
    required this.id,
    required this.name,
    required this.originalPrice,
    required this.convertedPrice,
    required this.currency,
    required this.isOwned,
    required this.isFree,
  });

  factory PersonalityModel.fromJson(Map<String, dynamic> json) {
    return PersonalityModel(
      id: json['id'] as int,
      name: json['name'] as String,
      originalPrice: json['original_price'] as String? ?? '0.00',
      convertedPrice: json['converted_price'] as String? ?? '0.00',
      currency: json['currency'] as String? ?? 'USD',
      isOwned: json['is_owned'] as bool? ?? false,
      isFree: json['is_free'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'original_price': originalPrice,
      'converted_price': convertedPrice,
      'currency': currency,
      'is_owned': isOwned,
      'is_free': isFree,
    };
  }
}
