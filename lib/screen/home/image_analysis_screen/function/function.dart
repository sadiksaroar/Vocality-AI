// import 'dart:io';
// import 'package:http/http.dart' as http;
// import 'package:vocality_ai/screen/home/image_analysis_screen/model/model.dart';
// import 'dart:convert';

// class ImageAnalysisService {
//   static const String baseUrl = 'http://10.10.7.24:8000';

//   Future<ImageAnalysisResponse> analyzeImage({
//     required File imageFile,
//     required String userRequest,
//     required String authToken,
//   }) async {
//     try {
//       var request = http.MultipartRequest(
//         'POST',
//         Uri.parse('$baseUrl/core/image-analysis-options/analyze/'),
//       );

//       request.headers['Authorization'] = authToken;
//       request.fields['user_request'] = userRequest;
//       request.files.add(
//         await http.MultipartFile.fromPath('image', imageFile.path),
//       );

//       http.StreamedResponse response = await request.send();

//       if (response.statusCode == 200) {
//         String responseBody = await response.stream.bytesToString();
//         Map<String, dynamic> jsonResponse = json.decode(responseBody);
//         return ImageAnalysisResponse.fromJson(jsonResponse);
//       } else {
//         throw Exception('Failed to analyze image: ${response.reasonPhrase}');
//       }
//     } catch (e) {
//       throw Exception('Error analyzing image: $e');
//     }
//   }

//   String getFullAudioUrl(String voiceUrl) {
//     return '$baseUrl$voiceUrl';
//   }
// }
