// models/login_model.dart

class LoginRequest {
  final String email;
  final String password;

  LoginRequest({required this.email, required this.password});

  Map<String, dynamic> toJson() {
    return {'email': email, 'password': password};
  }
}

class LoginResponse {
  final String? token;
  final String? refreshToken;
  final User? user;
  final String? message;

  LoginResponse({this.token, this.refreshToken, this.user, this.message});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      token: json['token'] ?? json['access_token'] ?? json['access'],
      refreshToken: json['refresh_token'] ?? json['refresh'],
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      message: json['message'],
    );
  }
}

class User {
  final int? id;
  final String? email;
  final String? name;
  final String? firstName;
  final String? lastName;

  User({this.id, this.email, this.name, this.firstName, this.lastName});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      name: json['name'] ?? json['username'],
      firstName: json['first_name'],
      lastName: json['last_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'first_name': firstName,
      'last_name': lastName,
    };
  }
}
