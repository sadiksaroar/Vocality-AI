import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

class AudioPlayerBridge {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isInitialized = false;

  AudioPlayerBridge() {
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    try {
      // Set audio player mode for better mobile compatibility
      await _audioPlayer.setReleaseMode(ReleaseMode.stop);

      // Listen to player state changes for debugging
      _audioPlayer.onPlayerStateChanged.listen((PlayerState state) {
        debugPrint('AudioPlayer state changed: $state');
      });

      // Listen to errors
      _audioPlayer.onPlayerComplete.listen((event) {
        debugPrint('Audio playback completed');
      });

      _isInitialized = true;
    } catch (e) {
      debugPrint('Error initializing audio player: $e');
    }
  }

  Future<void> play(String url) async {
    try {
      debugPrint('🎵 Attempting to play audio from URL: $url');

      if (!_isInitialized) {
        await _initializePlayer();
      }

      // Stop any currently playing audio
      await _audioPlayer.stop();

      // Play the audio from URL
      await _audioPlayer.play(UrlSource(url));
      debugPrint('✅ Audio playback started successfully');
    } catch (e) {
      debugPrint('❌ Error playing audio: $e');
      rethrow;
    }
  }

  Future<void> stop() async {
    try {
      await _audioPlayer.stop();
      debugPrint('Audio stopped');
    } catch (e) {
      debugPrint('Error stopping audio: $e');
    }
  }

  void dispose() {
    _audioPlayer.dispose();
  }
}
