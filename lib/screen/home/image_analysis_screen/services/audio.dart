import 'dart:html' as html;

class AudioPlayerBridge {
  html.AudioElement? _audio;

  Future<void> play(String url) async {
    try {
      _audio?.pause();
      _audio = html.AudioElement()
        ..src = url
        ..autoplay = true;
      await _audio!.play();
    } catch (e) {
      // ignore playback errors on web
    }
  }

  Future<void> stop() async {
    _audio?.pause();
    _audio = null;
  }

  void dispose() {
    _audio?.pause();
    _audio = null;
  }
}
