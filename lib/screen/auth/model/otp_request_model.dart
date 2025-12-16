class OtpRequestModel {
  final String email;
  final String otp;

  OtpRequestModel({required this.email, required this.otp});

  Map<String, dynamic> toJson() {
    return {'email': email, 'otp': otp};
  }
}

// lib/features/auth/models/otp_response_model.dart
class OtpResponseModel {
  final bool success;
  final String message;
  final String? accessToken;
  final String? refreshToken;

  OtpResponseModel({
    required this.success,
    required this.message,
    this.accessToken,
    this.refreshToken,
  });

  factory OtpResponseModel.fromJson(Map<String, dynamic> json) {
    return OtpResponseModel(
      success: json['success'] ?? true, // Default to true if not present
      message: json['message'] ?? 'Success',
      accessToken:
          json['access_token'] ?? json['access'] ?? json['accessToken'],
      refreshToken:
          json['refresh_token'] ?? json['refresh'] ?? json['refreshToken'],
    );
  }
}
