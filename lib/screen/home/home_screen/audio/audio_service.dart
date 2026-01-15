import 'dart:async';
import 'package:audioplayers/audioplayers.dart';

class AudioService {
  final AudioPlayer _player = AudioPlayer();
  StreamSubscription<PlayerState>? _stateSubscription;
  Completer<void>? _playbackCompleter;

  AudioService() {
    // Set audio mode for better Android compatibility
    _player.setReleaseMode(ReleaseMode.stop);

    // Listen to player state changes
    _stateSubscription = _player.onPlayerStateChanged.listen((state) {
      print('🎵 Audio state changed: $state');
      if (state == PlayerState.completed || state == PlayerState.stopped) {
        _playbackCompleter?.complete();
        _playbackCompleter = null;
      }
    });
  }

  Future<void> playUrl(String url) async {
    try {
      // Ensure previous playback is stopped
      await _player.stop();
      await Future.delayed(const Duration(milliseconds: 200));

      // Create new completer for this playback
      _playbackCompleter = Completer<void>();

      // Set player context for Android
      await _player.setSourceUrl(url);
      await _player.resume();

      print('✅ Started playing: $url');

      // Wait for playback to complete
      await _playbackCompleter!.future;
      print('✅ Playback completed');
    } catch (e) {
      print('❌ Error in playUrl: $e');
      _playbackCompleter?.complete();
      _playbackCompleter = null;
      rethrow;
    }
  }

  Future<void> stop() async {
    try {
      await _player.stop();
      _playbackCompleter?.complete();
      _playbackCompleter = null;
      await Future.delayed(const Duration(milliseconds: 100));
    } catch (e) {
      print('❌ Error stopping audio: $e');
    }
  }

  bool get isPlaying => _player.state == PlayerState.playing;

  void dispose() {
    _stateSubscription?.cancel();
    _player.dispose();
  }
}
