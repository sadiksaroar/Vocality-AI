class AudioPlayerBridge {
  Future<void> play(String url) async {
    // No-op on non-web platforms
  }

  Future<void> stop() async {
    // No-op on non-web platforms
  }

  void dispose() {
    // No-op
  }
}
