class Personality {
  final int id;
  final String name;

  Personality({required this.id, required this.name});

  factory Personality.fromJson(Map<String, dynamic> json) =>
      Personality(id: json['id'] as int, name: json['name'] as String);
}

class UserModel {
  final int id;
  final String email;
  final String name;
  final String? image;
  final double? remainingMinutes;

  UserModel({
    required this.id,
    required this.email,
    required this.name,
    this.image,
    this.remainingMinutes,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json['id'] as int,
    email: json['email'] as String,
    name: json['name'] as String,
    image: json['image'] as String?,
    remainingMinutes: (json['remaining_minutes'] != null)
        ? (json['remaining_minutes'] as num).toDouble()
        : null,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'email': email,
    'name': name,
    'image': image,
    'remaining_minutes': remainingMinutes,
  };
}
