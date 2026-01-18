import 'package:speech_to_text/speech_to_text.dart' as stt;

class SpeechService {
  final stt.SpeechToText _speech = stt.SpeechToText();
  String lastText = '';
  bool _isInitialized = false;
  String? _lastError;

  bool get isListening => _speech.isListening;

  Future<bool> _ensureInitialized() async {
    if (_isInitialized) return true;
    try {
      _isInitialized = await _speech.initialize(
        onError: (error) {
          print('Speech recognition error: $error');
          _lastError = error.errorMsg;
        },
        onStatus: (status) => print('Speech status: $status'),
        debugLogging: true,
      );
      return _isInitialized;
    } catch (e) {
      print('Failed to initialize speech recognition: $e');
      return false;
    }
  }

  Future<bool> start(void Function(String text) onText) async {
    _lastError = null;
    try {
      final initialized = await _ensureInitialized();
      if (!initialized) return false;

      lastText = '';
      await _speech.listen(
        onResult: (r) {
          lastText = r.recognizedWords;
          onText(lastText);
        },
        listenMode: stt.ListenMode.dictation,
        partialResults: true,
        cancelOnError: true,
      );

      // Brief check if error occurred immediately
      if (_lastError != null) return false;

      return true;
    } catch (e) {
      print('Failed to start speech recognition: $e');
      return false;
    }
  }

  Future<String> stop() async {
    try {
      await _speech.stop();
      return lastText.trim();
    } catch (e) {
      print('Failed to stop speech recognition: $e');
      return lastText.trim();
    }
  }
}
