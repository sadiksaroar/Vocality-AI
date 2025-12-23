class LoginRequest {
  final String email;
  final String password;

  LoginRequest({required this.email, required this.password});

  Map<String, dynamic> toJson() {
    return {'email': email, 'password': password};
  }
}

class LoginResponse {
  final String accessToken;
  final String refreshToken;
  final String email;
  final String message;

  LoginResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.email,
    required this.message,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      accessToken: json['access'] ?? '',
      refreshToken: json['refresh'] ?? '',
      email: json['email'] ?? '',
      message: json['message'] ?? 'Login successful',
    );
  }
}

class LoginError {
  final String message;
  final int statusCode;

  LoginError({required this.message, required this.statusCode});

  factory LoginError.fromJson(Map<String, dynamic> json) {
    return LoginError(
      message: json['detail'] ?? 'An error occurred',
      statusCode: 0,
    );
  }
}
