import 'dart:async';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:vocality_ai/core/config/app_config.dart';

class WebSocketService {
  WebSocketChannel? _channel;
  final _controller = StreamController<String>.broadcast();
  StreamSubscription? _subscription;

  Stream<String> get messages => _controller.stream;
  bool get isConnected => _channel != null;

  Future<void> connect() async {
    try {
      // Close existing connection if any
      await disconnect();

      _channel = WebSocketChannel.connect(
        Uri.parse('${AppConfig.wsBase}/ws/voice/'),
      );

      _subscription = _channel!.stream.listen(
        (msg) {
          if (!_controller.isClosed) {
            _controller.add(msg.toString());
          }
        },
        onError: (e) {
          print('WebSocket error: $e');
          if (!_controller.isClosed) {
            _controller.addError(e);
          }
        },
        onDone: () {
          print('WebSocket connection closed');
          _cleanup();
        },
        cancelOnError: false,
      );
    } catch (e) {
      print('Error connecting to WebSocket: $e');
      _controller.addError(e);
    }
  }

  void send(String text) {
    if (_channel != null && isConnected) {
      _channel!.sink.add(text);
    } else {
      print('WebSocket not connected');
    }
  }

  Future<void> disconnect() async {
    await _subscription?.cancel();
    await _channel?.sink.close();
    _cleanup();
  }

  void _cleanup() {
    _subscription = null;
    _channel = null;
  }

  Future<void> dispose() async {
    await disconnect();
    await _controller.close();
  }
}
