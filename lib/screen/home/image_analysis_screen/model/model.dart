class ImageAnalysisResponse {
  final bool success;
  final String? analysisResult;
  final String? errorMessage;

  ImageAnalysisResponse({
    required this.success,
    this.analysisResult,
    this.errorMessage,
  });

  factory ImageAnalysisResponse.fromJson(Map<String, dynamic> json) {
    return ImageAnalysisResponse(
      success: true,
      analysisResult:
          json['analysis'] ?? json['result'] ?? json['response'] ?? '',
    );
  }

  factory ImageAnalysisResponse.error(String message) {
    return ImageAnalysisResponse(success: false, errorMessage: message);
  }
}

/// Generic API Response wrapper
class ApiResponse<T> {
  final bool success;
  final T? data;
  final String? errorMessage;

  ApiResponse._({required this.success, this.data, this.errorMessage});

  factory ApiResponse.success(T data) {
    return ApiResponse._(success: true, data: data);
  }

  factory ApiResponse.error(String message) {
    return ApiResponse._(success: false, errorMessage: message);
  }
}
