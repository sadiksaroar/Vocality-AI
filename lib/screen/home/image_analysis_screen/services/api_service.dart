import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:vocality_ai/core/config/app_config.dart';
import 'dart:convert';

import 'package:vocality_ai/models/image_analysis_response.dart';
import 'package:vocality_ai/screen/home/image_analysis_screen/model/model.dart'
    hide ImageAnalysisResponse;

class ImageAnalysisService {
  // static const String baseUrl = 'http://10.10.7.24:8000'
  static const String baseUrl = AppConfig.httpBase;

  static const String apiEndpoint = '/core/image-analysis-options/analyze/';

  Future<ApiResponse<ImageAnalysisResponse>> analyzeImage({
    required String imagePath,
    required String userRequest,
    String? authToken,
  }) async {
    try {
      var uri = Uri.parse('$baseUrl$apiEndpoint');
      var request = http.MultipartRequest('POST', uri);

      // Add fields
      request.fields['user_request'] = userRequest;

      // Add image file
      var imageFile = await http.MultipartFile.fromPath('image', imagePath);
      request.files.add(imageFile);

      // Add headers
      if (authToken != null && authToken.isNotEmpty) {
        request.headers['Authorization'] = authToken;
      }

      // Send request
      http.StreamedResponse streamedResponse = await request.send();

      // Get response
      String responseBody = await streamedResponse.stream.bytesToString();

      if (streamedResponse.statusCode == 200) {
        Map<String, dynamic> jsonResponse = json.decode(responseBody);
        ImageAnalysisResponse response = ImageAnalysisResponse.fromJson(
          jsonResponse,
        );
        return ApiResponse.success(response);
      } else {
        return ApiResponse.error(
          'Failed to analyze image. Status: ${streamedResponse.statusCode}',
        );
      }
    } catch (e) {
      return ApiResponse.error('Error: ${e.toString()}');
    }
  }

  String getFullAudioUrl(String voiceUrl) {
    if (voiceUrl.startsWith('http')) {
      return voiceUrl;
    }
    // Remove leading slash if present
    String cleanUrl = voiceUrl.startsWith('/')
        ? voiceUrl.substring(1)
        : voiceUrl;
    return '$baseUrl/$cleanUrl';
  }
}
