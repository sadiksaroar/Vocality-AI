import 'package:speech_to_text/speech_to_text.dart' as stt;

class SpeechService {
  final stt.SpeechToText _speech = stt.SpeechToText();
  String lastText = '';

  bool get isListening => _speech.isListening;

  Future<bool> start(void Function(String text) onText) async {
    try {
      final ok = await _speech.initialize(
        onError: (error) => print('Speech recognition error: $error'),
        onStatus: (status) => print('Speech status: $status'),
      );
      if (!ok) return false;
      lastText = '';
      await _speech.listen(
        onResult: (r) {
          lastText = r.recognizedWords;
          onText(lastText);
        },
        listenMode: stt.ListenMode.confirmation,
      );
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
