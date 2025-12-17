class OtpRequestModel {
  final String email;
  final String otp;

  OtpRequestModel({required this.email, required this.otp});

  Map<String, dynamic> toJson() => {'email': email, 'otp': otp};
}

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
      success: json['success'] ?? true,
      message: json['message'] ?? 'Success',
      accessToken:
          json['access_token'] ?? json['access'] ?? json['accessToken'],
      refreshToken:
          json['refresh_token'] ?? json['refresh'] ?? json['refreshToken'],
    );
  }
}
