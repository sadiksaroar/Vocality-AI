// lib/features/auth/data/models/otp_model.dart

class OtpVerificationRequest {
  final String email;
  final String otp;

  OtpVerificationRequest({required this.email, required this.otp});

  Map<String, dynamic> toJson() {
    return {'email': email, 'otp': otp};
  }
}

class OtpVerificationResponse {
  final bool success;
  final String message;
  final String? token;
  final Map<String, dynamic>? data;

  OtpVerificationResponse({
    required this.success,
    required this.message,
    this.token,
    this.data,
  });

  factory OtpVerificationResponse.fromJson(Map<String, dynamic> json) {
    return OtpVerificationResponse(
      success: json['success'] ?? true,
      message: json['message'] ?? 'OTP verified successfully',
      token: json['token'],
      data: json['data'],
    );
  }
}

class ResendOtpRequest {
  final String email;

  ResendOtpRequest({required this.email});

  Map<String, dynamic> toJson() {
    return {'email': email};
  }
}

class ResendOtpResponse {
  final bool success;
  final String message;

  ResendOtpResponse({required this.success, required this.message});

  factory ResendOtpResponse.fromJson(Map<String, dynamic> json) {
    return ResendOtpResponse(
      success: json['success'] ?? true,
      message: json['message'] ?? 'OTP sent successfully',
    );
  }
}
