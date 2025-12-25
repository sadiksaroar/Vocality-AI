class AppConfig {
  static const String httpBase = 'http://10.10.7.24:8000';
  static const String audioBase = 'http://10.10.7.118:8000';
  static const String wsBase = 'ws://10.10.7.118:8000';
  static const String sendMessagePath = '/core/conversations/send_message/';

  static String get sendMessageUrl => '$httpBase$sendMessagePath';

  static String resolveAudioUrl(String audioUrl) {
    if (audioUrl.startsWith('http')) {
      // Replace .24 with .118 for audio URLs
      return audioUrl.replaceAll('10.10.7.24:8000', '10.10.7.118:8000');
    }
    return '$audioBase$audioUrl';
  }
}


// ws://10.10.7.118:8000/ws/voice/