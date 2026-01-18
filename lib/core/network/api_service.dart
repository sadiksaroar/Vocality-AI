import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:vocality_ai/core/config/app_config.dart';
import 'package:vocality_ai/core/gen/stroge_helper/stroge_helper.dart';
import 'package:vocality_ai/core/voice/web_recorder_service.dart';

class ApiService {
  /// Send audio bytes directly to backend for processing (works on web and mobile)
  Future<Map<String, dynamic>> sendAudioBytes({
    required int personalityId,
    required Uint8List audioBytes,
    String filename = 'audio.opus',
  }) async {
    final token = await StorageHelper.getToken();

    if (audioBytes.isEmpty) {
      throw Exception('Audio bytes are empty');
    }

    final uri = Uri.parse(
      '${AppConfig.httpBase}/core/conversations/send_voice_message/',
    );

    debugPrint('➡️ [API] POST ${uri.toString()}');
    debugPrint(
      '   Authorization present: ${token != null && token.isNotEmpty}',
    );
    debugPrint('   Audio bytes size: ${audioBytes.length}');

    // Retry logic for server errors
    const int maxAttempts = 3;
    int attempt = 0;

    while (true) {
      attempt++;
      try {
        final request = http.MultipartRequest('POST', uri);

        // Add headers
        if (token != null && token.isNotEmpty) {
          request.headers['Authorization'] = 'Bearer $token';
        }

        // Add personality_id as a field
        request.fields['personality_id'] = personalityId.toString();

        // Add the audio bytes as a file
        request.files.add(
          http.MultipartFile.fromBytes('audio', audioBytes, filename: filename),
        );

        debugPrint('📤 Request fields: ${request.fields}');
        debugPrint(
          '📤 Request files: ${request.files.length} file(s), first file size: ${request.files.isNotEmpty ? request.files.first.length : 0} bytes',
        );

        final streamedResponse = await request.send().timeout(
          const Duration(seconds: 30),
        );
        final response = await http.Response.fromStream(streamedResponse);

        debugPrint('📥 Response status: ${response.statusCode}');
        debugPrint('📥 Response body: ${response.body}');

        if (response.statusCode == 200) {
          return json.decode(response.body) as Map<String, dynamic>;
        }

        // Server error — retry
        if (response.statusCode >= 500 && attempt < maxAttempts) {
          final backoff = Duration(milliseconds: 400 * attempt);
          debugPrint(
            '⏳ Backend 5xx detected (attempt $attempt). Backing off ${backoff.inMilliseconds}ms and retrying.',
          );
          await Future.delayed(backoff);
          continue;
        }

        debugPrint('⛔ [API] ${response.statusCode} ${response.reasonPhrase}');
        throw Exception(
          'HTTP ${response.statusCode}: ${response.reasonPhrase} - ${response.body}',
        );
      } catch (e) {
        if (attempt < maxAttempts) {
          final backoff = Duration(milliseconds: 400 * attempt);
          debugPrint(
            '⚠️ Request failed (attempt $attempt): $e — retrying after ${backoff.inMilliseconds}ms',
          );
          await Future.delayed(backoff);
          continue;
        }
        debugPrint('⛔ [API] sendAudioBytes failed after $attempt attempts: $e');
        rethrow;
      }
    }
  }

  /// Send audio from recording result (handles both file path and bytes)
  Future<Map<String, dynamic>> sendAudioRecording({
    required int personalityId,
    required AudioRecordingResult recording,
  }) async {
    if (recording.isEmpty) {
      throw Exception('Recording is empty');
    }

    // Get audio bytes from recording result
    final bytes = await recording.getBytes();
    if (bytes == null || bytes.isEmpty) {
      throw Exception('Could not get audio bytes from recording');
    }

    // Determine filename based on recording type
    String filename;
    if (recording.hasFilePath) {
      filename = recording.filePath!.split('/').last;
    } else {
      // Web recording uses webm format (opus codec wrapped in webm container)
      // Backend supports: flac, m4a, mp3, mp4, mpeg, mpga, oga, ogg, wav, webm
      filename = 'audio_${DateTime.now().millisecondsSinceEpoch}.webm';
    }

    return sendAudioBytes(
      personalityId: personalityId,
      audioBytes: bytes,
      filename: filename,
    );
  }

  /// Send audio file directly to backend for processing (legacy method for mobile)
  Future<Map<String, dynamic>> sendAudioMessage({
    required int personalityId,
    required String audioFilePath,
  }) async {
    if (kIsWeb) {
      throw Exception(
        'sendAudioMessage is not supported on web. Use sendAudioBytes instead.',
      );
    }

    final token = await StorageHelper.getToken();
    final file = File(audioFilePath);

    if (!await file.exists()) {
      throw Exception('Audio file not found: $audioFilePath');
    }

    final uri = Uri.parse(
      '${AppConfig.httpBase}/core/conversations/send_voice_message/',
    );
    final request = http.MultipartRequest('POST', uri);

    // Add headers
    if (token != null && token.isNotEmpty) {
      request.headers['Authorization'] = 'Bearer $token';
    }

    // Add personality_id as a field
    request.fields['personality_id'] = personalityId.toString();

    // Add the audio file
    final filename = audioFilePath.split('/').last;
    request.files.add(
      await http.MultipartFile.fromPath(
        'audio',
        audioFilePath,
        filename: filename,
      ),
    );

    debugPrint('➡️ [API] POST ${uri.toString()}');
    debugPrint(
      '   Authorization present: ${token != null && token.isNotEmpty}',
    );
    debugPrint('   Audio file: $audioFilePath');

    // Retry logic for server errors
    const int maxAttempts = 3;
    int attempt = 0;

    while (true) {
      attempt++;
      try {
        final streamedResponse = await request.send().timeout(
          const Duration(seconds: 30),
        );
        final response = await http.Response.fromStream(streamedResponse);

        debugPrint('📥 Response status: ${response.statusCode}');
        debugPrint('📥 Response body: ${response.body}');

        if (response.statusCode == 200) {
          return json.decode(response.body) as Map<String, dynamic>;
        }

        // Server error — retry
        if (response.statusCode >= 500 && attempt < maxAttempts) {
          final backoff = Duration(milliseconds: 400 * attempt);
          debugPrint(
            '⏳ Backend 5xx detected (attempt $attempt). Backing off ${backoff.inMilliseconds}ms and retrying.',
          );
          await Future.delayed(backoff);
          // Re-create request for retry
          final retryRequest = http.MultipartRequest('POST', uri);
          if (token != null && token.isNotEmpty) {
            retryRequest.headers['Authorization'] = 'Bearer $token';
          }
          retryRequest.fields['personality_id'] = personalityId.toString();
          retryRequest.files.add(
            await http.MultipartFile.fromPath(
              'audio',
              audioFilePath,
              filename: filename,
            ),
          );
          continue;
        }

        debugPrint('⛔ [API] ${response.statusCode} ${response.reasonPhrase}');
        throw Exception(
          'HTTP ${response.statusCode}: ${response.reasonPhrase} - ${response.body}',
        );
      } catch (e) {
        if (attempt < maxAttempts) {
          final backoff = Duration(milliseconds: 400 * attempt);
          debugPrint(
            '⚠️ Request failed (attempt $attempt): $e — retrying after ${backoff.inMilliseconds}ms',
          );
          await Future.delayed(backoff);
          continue;
        }
        if (kDebugMode) {
          print('⛔ [API] sendAudioMessage failed after $attempt attempts: $e');
        }
        rethrow;
      }
    }
  }

  Future<Map<String, dynamic>> sendMessage({
    required int personalityId,
    required String message,
  }) async {
    final token = await StorageHelper.getToken();
    final headers = {
      'Content-Type': 'application/json',
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    };
    final payload = {'personality_id': personalityId, 'message': message};
    final body = json.encode(payload);

    print('➡️ [API] POST ${AppConfig.sendMessageUrl}');
    print('   Authorization present: ${token != null && token.isNotEmpty}');
    print('   Headers: $headers');
    print('   Body: $body');

    // Guard: don't send extremely short/empty messages which sometimes cause
    // backend failures on noisy/partial speech input from Android.
    if (message.trim().length < 2) {
      print('⚠️ Message too short, skipping API call');
      return {
        'audio_url': '',
        'message': message,
        'error': 'Message too short',
      };
    }

    // Retry on server-side 5xx or known backend error messages.
    const int maxAttempts = 3;
    int attempt = 0;
    while (true) {
      attempt++;
      try {
        final resp = await http
            .post(
              Uri.parse(AppConfig.sendMessageUrl),
              headers: headers,
              body: body,
            )
            .timeout(const Duration(seconds: 10));

        print('📥 Response status: ${resp.statusCode}');
        print('📥 Response body: ${resp.body}');

        if (resp.statusCode == 200) {
          return json.decode(resp.body) as Map<String, dynamic>;
        }

        // Server error — inspect body for AI-specific failure and retry
        if (resp.statusCode >= 500 && attempt < maxAttempts) {
          final bodyStr = resp.body;
          if (bodyStr.contains('AI response failed') ||
              resp.statusCode >= 500) {
            final backoff = Duration(milliseconds: 400 * attempt);
            print(
              '⏳ Backend 5xx detected (attempt $attempt). Backing off ${backoff.inMilliseconds}ms and retrying.',
            );
            await Future.delayed(backoff);
            continue;
          }
        }

        // Non-retriable or max attempts reached
        print('⛔ [API] ${resp.statusCode} ${resp.reasonPhrase}');
        throw Exception(
          'HTTP ${resp.statusCode}: ${resp.reasonPhrase} - ${resp.body}',
        );
      } catch (e) {
        if (attempt < maxAttempts) {
          final backoff = Duration(milliseconds: 400 * attempt);
          print(
            '⚠️ Request failed (attempt $attempt): $e — retrying after ${backoff.inMilliseconds}ms',
          );
          await Future.delayed(backoff);
          continue;
        }
        print('⛔ [API] sendMessage failed after $attempt attempts: $e');
        rethrow;
      }
    }
  }

  Future<void> endActiveConversation({required int personalityId}) async {
    final token = await StorageHelper.getToken();
    final headers = {
      'Content-Type': 'application/json',
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    };

    print('➡️ [API] POST ${AppConfig.endActiveUrl}');
    print('   Authorization present: ${token != null && token.isNotEmpty}');

    final resp = await http.post(
      Uri.parse(AppConfig.endActiveUrl),
      headers: headers,
      body: json.encode({'personality_id': personalityId}),
    );

    if (resp.statusCode == 200) {
      print('✅ Conversation ended: ${await resp.body}');
    } else {
      print('⛔ [API] ${resp.statusCode} ${resp.reasonPhrase}');
      print('   Response body: ${resp.body}');
      throw Exception(
        'HTTP ${resp.statusCode}: ${resp.reasonPhrase} - ${resp.body}',
      );
    }
  }

  /// Fetch app logo / branding metadata
  Future<dynamic> getLogo() async {
    final token = await StorageHelper.getToken();
    final headers = {
      'Content-Type': 'application/json',
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    };

    print('➡️ [API] GET ${AppConfig.logoUrl}');
    print('   Authorization present: ${token != null && token.isNotEmpty}');

    final resp = await http.get(Uri.parse(AppConfig.logoUrl), headers: headers);

    if (resp.statusCode == 200) {
      return json.decode(resp.body);
    } else {
      print('⛔ [API] ${resp.statusCode} ${resp.reasonPhrase}');
      print('   Response body: ${resp.body}');
      throw Exception(
        'HTTP ${resp.statusCode}: ${resp.reasonPhrase} - ${resp.body}',
      );
    }
  }

  // Get available personalities
  Future<List<Map<String, dynamic>>> getAvailablePersonalities() async {
    final token = await StorageHelper.getToken();
    final response = await http.get(
      Uri.parse(
        '${AppConfig.httpBase}/subscription/subscription/available_personalities/',
      ),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return List<Map<String, dynamic>>.from(data);
    } else {
      throw Exception('Failed to load personalities: ${response.statusCode}');
    }
  }

  // Get available time packages
  Future<List<Map<String, dynamic>>> getAvailableTimePackages() async {
    final token = await StorageHelper.getToken();
    final response = await http.get(
      Uri.parse(
        '${AppConfig.httpBase}/subscription/subscription/available_time_packages/',
      ),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return List<Map<String, dynamic>>.from(data);
    } else {
      throw Exception('Failed to load time packages: ${response.statusCode}');
    }
  }

  // Get available subscription plans
  Future<List<Map<String, dynamic>>> getAvailablePlans() async {
    final token = await StorageHelper.getToken();
    final response = await http.get(
      Uri.parse(
        '${AppConfig.httpBase}/subscription/subscription/available_plans/',
      ),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return List<Map<String, dynamic>>.from(data);
    } else {
      throw Exception(
        'Failed to load subscription plans: ${response.statusCode}',
      );
    }
  }

  // Purchase time package
  Future<Map<String, dynamic>> purchaseTimePackage(
    int packageId, {
    required String paymentId,
    required String amountPaid,
    required String currency,
  }) async {
    final token = await StorageHelper.getToken();
    final response = await http.post(
      Uri.parse(
        '${AppConfig.httpBase}/subscription/subscription/purchase_time/',
      ),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'time_management_id': packageId,
        'payment_id': paymentId,
        'amount_paid': amountPaid,
        'currency': currency,
      }),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to purchase package: ${response.body}');
    }
  }

  // Purchase personality
  Future<Map<String, dynamic>> purchasePersonality(
    int personalityId, {
    required String paymentId,
    required String amountPaid,
    required String currency,
  }) async {
    final token = await StorageHelper.getToken();
    final response = await http.post(
      Uri.parse(
        '${AppConfig.httpBase}/subscription/subscription/purchase_personality/',
      ),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'personality_id': personalityId,
        'payment_id': paymentId,
        'amount_paid': amountPaid,
        'currency': currency,
      }),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to purchase personality: ${response.body}');
    }
  }

  // Subscribe to plan
  Future<Map<String, dynamic>> subscribeToPlan(
    int planId, {
    required String paymentId,
    required String amountPaid,
    required String currency,
  }) async {
    final token = await StorageHelper.getToken();
    final response = await http.post(
      Uri.parse(
        '${AppConfig.httpBase}/subscription/subscription/purchase_plan/',
      ),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'plan_id': planId,
        'payment_id': paymentId,
        'amount_paid': amountPaid,
        'currency': currency,
      }),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to subscribe: ${response.body}');
    }
  }
}
