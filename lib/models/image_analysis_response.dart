class ImageAnalysisResponse {
  final bool success;
  final String? analysisText;
  final String? analysisResult;
  final String? voiceUrl;
  final String? resultImageUrl;
  final String? errorMessage;

  ImageAnalysisResponse({
    required this.success,
    this.analysisText,
    this.analysisResult,
    this.voiceUrl,
    this.resultImageUrl,
    this.errorMessage,
  });

  factory ImageAnalysisResponse.fromJson(Map<String, dynamic> json) {
    final analysisText =
        json['analysis_text'] ??
        json['analysis'] ??
        json['result'] ??
        json['response'];
    return ImageAnalysisResponse(
      success: json['success'] ?? true,
      analysisText: analysisText,
      analysisResult: analysisText,
      voiceUrl: json['voice_url'],
      resultImageUrl: json['result_image_url'],
    );
  }

  factory ImageAnalysisResponse.error(String message) {
    return ImageAnalysisResponse(success: false, errorMessage: message);
  }
}
