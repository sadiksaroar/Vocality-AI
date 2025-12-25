import 'package:speech_to_text/speech_to_text.dart' as stt;

class SpeechService {
  final stt.SpeechToText _speech = stt.SpeechToText();
  String lastText = '';

  bool get isListening => _speech.isListening;

  Future<bool> start(void Function(String text) onText) async {
    final ok = await _speech.initialize();
    if (!ok) return false;
    lastText = '';
    await _speech.listen(
      onResult: (r) {
        lastText = r.recognizedWords;
        onText(lastText);
      },
    );
    return true;
  }

  Future<String> stop() async {
    await _speech.stop();
    return lastText.trim();
  }
}
