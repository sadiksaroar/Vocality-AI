// lib/models/user_model.dart

class RegisterRequest {
  final String email;
  final String name;
  final String password;
  final String password2;

  RegisterRequest({
    required this.email,
    required this.name,
    required this.password,
    required this.password2,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'name': name,
      'password': password,
      'password2': password2,
    };
  }
}

class RegisterResponse {
  final bool success;
  final String? message;
  final String? token;
  final Map<String, dynamic>? data;

  RegisterResponse({
    required this.success,
    this.message,
    this.token,
    this.data,
  });

  factory RegisterResponse.fromJson(Map<String, dynamic> json) {
    return RegisterResponse(
      success: json['success'] ?? true,
      message: json['message'] ?? json['detail'],
      token: json['access_token'] ?? json['token'],
      data: json,
    );
  }
}
