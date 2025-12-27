// Base URLs and endpoints
class AppConfig {
  static const httpBase = 'http://10.10.7.24:8000';
  static const audioBase = 'http://10.10.7.118:8000';
  static const aiWsBase = 'ws://10.10.7.118:8000';
  static const sendMessagePath = '/core/conversations/send_message/';
  static String get sendMessageUrl => '$httpBase$sendMessagePath';
  static String resolveAudioUrl(String audioUrl) =>
      audioUrl.startsWith('http') ? audioUrl : '$audioBase$audioUrl';
}
