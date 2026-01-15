import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:record/record.dart';
import 'package:vocality_ai/screen/home/image_analysis_screen/services/voice_chat_service.dart';
import 'dart:typed_data';

class VoiceChatController extends GetxController {
  late VoiceChatService voiceChatService;
  late AudioRecorder audioRecorder;

  var isListening = false.obs;
  var isConnected = false.obs;
  var sessionId = ''.obs;
  var aiResponse = ''.obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  late String authToken;
  int selectedPersonalityId = 1;

  @override
  void onInit() {
    super.onInit();
    audioRecorder = AudioRecorder();
  }

  void initializeService(String token) {
    voiceChatService = VoiceChatService(token: token);
    authToken = token;
    _setupResponseListener();
  }

  void _setupResponseListener() {
    voiceChatService.responses.listen(
      (response) {
        final type = response.type;

        switch (type) {
          case 'connected':
            isConnected.value = true;
            errorMessage.value = '';
            // print('WebSocket connected');
            debugPrint("Connected to server");

            break;

          case 'session_started':
            sessionId.value = response.data['session_id'] ?? '';
            isLoading.value = false;
            print('Session started: ${sessionId.value}');
            break;

          case 'ai_response':
            _handleAiResponse(response.data);
            break;

          case 'error':
            errorMessage.value = response.error ?? 'Unknown error';
            isLoading.value = false;
            print('Error: ${errorMessage.value}');
            break;

          default:
            print('Unknown response type: $type');
        }
      },
      onError: (error) {
        errorMessage.value = 'Connection error: $error';
        isConnected.value = false;
      },
    );

    voiceChatService.sessionEvents.listen((event) {
      if (event.type == 'connected') {
        isConnected.value = true;
      } else if (event.type == 'disconnected') {
        isConnected.value = false;
      }
    });
  }

  void _handleAiResponse(Map<String, dynamic> data) {
    if (data.isNotEmpty) {
      aiResponse.value = data['text_response'] ?? '';
      isLoading.value = false;
    }
  }

  Future<void> initializeConnection() async {
    try {
      isLoading.value = true;
      await voiceChatService.connect();
      isConnected.value = true;
    } catch (e) {
      errorMessage.value = 'Failed to connect: $e';
      isConnected.value = false;
    } finally {
      isLoading.value = false;
    }
  }

  void startSession(int personalityId) {
    if (!isConnected.value) {
      errorMessage.value = 'Not connected to server';
      return;
    }

    selectedPersonalityId = personalityId;
    isLoading.value = true;
    errorMessage.value = '';
    voiceChatService.startSession(personalityId);
  }

  void sendAudio(List<int> audioBytes) {
    voiceChatService.sendAudio(Uint8List.fromList(audioBytes));
  }

  void endUtterance() {
    voiceChatService.endUtterance();
  }

  void newSession(int personalityId) {
    voiceChatService.newSession(personalityId);
  }

  void endSession() {
    isListening.value = false;
    voiceChatService.endSession();
    sessionId.value = '';
  }

  @override
  void onClose() {
    audioRecorder.dispose();
    voiceChatService.disconnect();
    super.onClose();
  }
}
