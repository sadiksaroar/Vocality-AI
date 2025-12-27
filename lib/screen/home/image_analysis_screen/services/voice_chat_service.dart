import 'dart:async';
import 'dart:typed_data';
import 'package:vocality_ai/models/voice_chat_models.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:convert';

class VoiceChatService {
  late WebSocketChannel _channel;
  final String _baseUrl = 'ws://10.10.7.118:8000/ws/voice/';
  final String _token;

  final StreamController<AIResponse> _responseController =
      StreamController.broadcast();
  Stream<AIResponse> get responses => _responseController.stream;

  final StreamController<VoiceSessionEvent> _sessionController =
      StreamController.broadcast();
  Stream<VoiceSessionEvent> get sessionEvents => _sessionController.stream;

  VoiceSession? _currentSession;
  bool _isConnected = false;

  VoiceChatService({required String token}) : _token = token;

  bool get isConnected => _isConnected;
  VoiceSession? get currentSession => _currentSession;

  Future<void> connect() async {
    try {
      _channel = WebSocketChannel.connect(Uri.parse('$_baseUrl?token=$_token'));

      _isConnected = true;
      _sessionController.add(VoiceSessionEvent(type: 'connected'));

      _channel.stream.listen(
        (message) {
          _handleMessage(message);
        },
        onError: (error) {
          print('WebSocket error: $error');
          _responseController.addError(error);
          _isConnected = false;
        },
        onDone: () {
          print('WebSocket disconnected');
          _isConnected = false;
          _sessionController.add(VoiceSessionEvent(type: 'disconnected'));
        },
      );
    } catch (e) {
      print('WebSocket connection error: $e');
      _isConnected = false;
      rethrow;
    }
  }

  void _handleMessage(dynamic message) {
    try {
      if (message is String) {
        final json = jsonDecode(message) as Map<String, dynamic>;
        final type = json['type'] as String?;

        switch (type) {
          case 'connected':
            _sessionController.add(VoiceSessionEvent(type: 'connected'));
            break;

          case 'session_started':
            _currentSession = VoiceSession(
              sessionId: json['session_id'] ?? '',
              personalityId: json['personality_id'] ?? 0,
              personalityName: json['personality_name'] ?? '',
              createdAt: DateTime.now(),
            );
            _sessionController.add(
              VoiceSessionEvent(
                type: 'session_started',
                session: _currentSession,
              ),
            );
            break;

          case 'ai_response':
            final aiResponse = AIResponse.fromJson(json);
            _responseController.add(aiResponse);
            break;

          case 'error':
            final aiResponse = AIResponse(
              type: 'error',
              error: json['message'],
            );
            _responseController.add(aiResponse);
            break;

          case 'ack':
            print('Audio received: ${json['bytes_received']} bytes');
            break;

          case 'session_ended':
            _currentSession = null;
            _sessionController.add(VoiceSessionEvent(type: 'session_ended'));
            break;
        }
      }
    } catch (e) {
      print('Error handling message: $e');
      _responseController.addError(e);
    }
  }

  void startSession(int personalityId) {
    if (!_isConnected) {
      print('WebSocket not connected');
      return;
    }
    _channel.sink.add(
      jsonEncode({'type': 'start_session', 'personality_id': personalityId}),
    );
  }

  void sendAudio(Uint8List audioBytes) {
    if (!_isConnected) {
      print('WebSocket not connected');
      return;
    }
    _channel.sink.add(audioBytes);
  }

  void endUtterance() {
    if (!_isConnected) {
      print('WebSocket not connected');
      return;
    }
    _channel.sink.add(jsonEncode({'type': 'end_utterance'}));
  }

  void newSession(int personalityId) {
    if (!_isConnected) {
      print('WebSocket not connected');
      return;
    }
    _channel.sink.add(
      jsonEncode({'type': 'new_session', 'personality_id': personalityId}),
    );
  }

  void endSession() {
    if (!_isConnected) {
      print('WebSocket not connected');
      return;
    }
    _channel.sink.add(jsonEncode({'type': 'end_session'}));
  }

  void disconnect() {
    if (_isConnected) {
      _channel.sink.close();
      _isConnected = false;
    }
    _responseController.close();
    _sessionController.close();
  }
}

// Voice Session Event Model
class VoiceSessionEvent {
  final String type;
  final VoiceSession? session;

  VoiceSessionEvent({required this.type, this.session});
}
