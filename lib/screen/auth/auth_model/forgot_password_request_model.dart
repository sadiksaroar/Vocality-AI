// lib/features/auth/models/forgot_password_model.dart

class ForgotPasswordRequest {
  final String email;

  ForgotPasswordRequest({required this.email});

  Map<String, dynamic> toJson() {
    return {'email': email};
  }
}

class ForgotPasswordResponse {
  final bool success;
  final String message;
  final String? error;

  ForgotPasswordResponse({
    required this.success,
    required this.message,
    this.error,
  });

  factory ForgotPasswordResponse.fromJson(Map<String, dynamic> json) {
    return ForgotPasswordResponse(
      success: json['success'] ?? true,
      message: json['message'] ?? 'OTP sent successfully',
      error: json['error'],
    );
  }
}
