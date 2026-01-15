import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:vocality_ai/core/config/app_config.dart';
import 'package:vocality_ai/models/image_analysis_response.dart';
import 'package:vocality_ai/screen/home/image_analysis_screen/services/audio.dart';

class ImageAnalysisService {
  static const String _analyzeEndpoint =
      '/core/image-analysis-options/analyze/';
  static String get _baseUrl => '${AppConfig.httpBase}$_analyzeEndpoint';
  final AudioPlayerBridge _audioPlayer = AudioPlayerBridge();

  Future<ImageAnalysisResponse> analyzeImage({
    File? imageFile,
    Uint8List? imageBytes,
    required String userRequest,
    required String authToken,
  }) async {
    try {
      var headers = {'Authorization': authToken};

      var request = http.MultipartRequest('POST', Uri.parse(_baseUrl));

      request.fields.addAll({'user_request': userRequest});

      // Add image from file or bytes
      if (imageFile != null) {
        request.files.add(
          await http.MultipartFile.fromPath('image', imageFile.path),
        );
      } else if (imageBytes != null) {
        request.files.add(
          http.MultipartFile.fromBytes(
            'image',
            imageBytes,
            filename: 'image.jpg',
          ),
        );
      }

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        final jsonResponse = json.decode(responseBody);
        return ImageAnalysisResponse.fromJson(jsonResponse);
      } else {
        return ImageAnalysisResponse.error(
          'Failed to analyze image: ${response.reasonPhrase}',
        );
      }
    } catch (e) {
      return ImageAnalysisResponse.error('Error: ${e.toString()}');
    }
  }

  /// Play audio from voice_url
  Future<void> playVoiceUrl(String voiceUrl) async {
    try {
      // Resolve the full URL
      final fullUrl = AppConfig.resolveAudioUrl(voiceUrl);
      debugPrint('🎧 Playing audio from resolved URL: $fullUrl');
      await _audioPlayer.play(fullUrl);
      debugPrint('✅ Audio playback initiated successfully');
    } catch (e) {
      debugPrint('❌ Error playing audio: $e');
      rethrow;
    }
  }

  Future<void> stopAudio() async {
    await _audioPlayer.stop();
  }

  void dispose() {
    _audioPlayer.dispose();
  }
}

enum ImageAnalysisState {
  idle,
  uploading,
  analyzing,
  speaking,
  completed,
  error,
}

class ImageAnalysisController extends ChangeNotifier {
  final ImageAnalysisService _service = ImageAnalysisService();

  ImageAnalysisState _state = ImageAnalysisState.idle;
  String? _analysisResult;
  String? _voiceUrl;
  String? _errorMessage;
  double _uploadProgress = 0.0;

  ImageAnalysisState get state => _state;
  String? get analysisResult => _analysisResult;
  String? get voiceUrl => _voiceUrl;
  String? get errorMessage => _errorMessage;
  double get uploadProgress => _uploadProgress;
  bool get isLoading =>
      _state == ImageAnalysisState.uploading ||
      _state == ImageAnalysisState.analyzing;

  Future<void> analyzeAndSpeak({
    File? imageFile,
    Uint8List? imageBytes,
    required String userRequest,
    required String authToken,
  }) async {
    try {
      // Set uploading state
      _state = ImageAnalysisState.uploading;
      _errorMessage = null;
      _analysisResult = null;
      _voiceUrl = null;
      notifyListeners();

      // Simulate upload progress
      for (int i = 0; i <= 100; i += 10) {
        await Future.delayed(const Duration(milliseconds: 100));
        _uploadProgress = i / 100;
        notifyListeners();
      }

      // Set analyzing state
      _state = ImageAnalysisState.analyzing;
      notifyListeners();

      // Call the API
      final response = await _service.analyzeImage(
        imageFile: imageFile,
        imageBytes: imageBytes,
        userRequest: userRequest,
        authToken: authToken,
      );

      if (response.success) {
        _analysisResult = response.analysisText;
        _voiceUrl = response.voiceUrl;

        debugPrint('📊 Analysis successful');
        debugPrint('📝 Analysis text: $_analysisResult');
        debugPrint('🔊 Voice URL: $_voiceUrl');

        // If voice_url is available, play the audio
        if (response.voiceUrl != null && response.voiceUrl!.isNotEmpty) {
          _state = ImageAnalysisState.speaking;
          notifyListeners();

          try {
            // Play the audio from voice_url
            await _service.playVoiceUrl(response.voiceUrl!);
            debugPrint('✅ Audio playback completed');
          } catch (audioError) {
            debugPrint('❌ Audio playback error: $audioError');
            // Continue to completed state even if audio fails
          }
        } else {
          debugPrint('⚠️ No voice URL provided in response');
        }

        _state = ImageAnalysisState.completed;
        notifyListeners();
      } else {
        _errorMessage = response.errorMessage ?? 'Unknown error occurred';
        _state = ImageAnalysisState.error;
        debugPrint('❌ Analysis failed: $_errorMessage');
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = e.toString();
      _state = ImageAnalysisState.error;
      notifyListeners();
    }
  }

  void reset() {
    _state = ImageAnalysisState.idle;
    _analysisResult = null;
    _voiceUrl = null;
    _errorMessage = null;
    _uploadProgress = 0.0;
    _service.stopAudio();
    notifyListeners();
  }

  @override
  void dispose() {
    _service.dispose();
    super.dispose();
  }
}
