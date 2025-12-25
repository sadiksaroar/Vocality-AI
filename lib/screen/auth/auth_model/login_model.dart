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
    // Handle multiple possible error message formats
    String errorMessage = 'An error occurred';

    if (json.containsKey('detail')) {
      errorMessage = json['detail'].toString();
    } else if (json.containsKey('message')) {
      errorMessage = json['message'].toString();
    } else if (json.containsKey('error')) {
      errorMessage = json['error'].toString();
    } else if (json.containsKey('email')) {
      // Sometimes email field contains error message
      final emailError = json['email'];
      if (emailError is List && emailError.isNotEmpty) {
        errorMessage = emailError[0].toString();
      } else {
        errorMessage = emailError.toString();
      }
    } else if (json.containsKey('password')) {
      final passwordError = json['password'];
      if (passwordError is List && passwordError.isNotEmpty) {
        errorMessage = passwordError[0].toString();
      } else {
        errorMessage = passwordError.toString();
      }
    } else if (json.containsKey('non_field_errors')) {
      final nonFieldErrors = json['non_field_errors'];
      if (nonFieldErrors is List && nonFieldErrors.isNotEmpty) {
        errorMessage = nonFieldErrors[0].toString();
      } else {
        errorMessage = nonFieldErrors.toString();
      }
    }

    return LoginError(
      message: errorMessage,
      statusCode: json['status_code'] ?? 0,
    );
  }

  @override
  String toString() => message;
}
