// class AppConfig {
//   static const String httpBase = 'http://10.10.7.74:8000';
//   // static const httpBase = 'http://api.thekaren.ai';

//   static const String audioBase = 'http://10.10.7.118:8000';
//   // static const String audioBase = 'http://thekaren.ai';
//   // static const String wsBase = 'ws://10.10.7.118:8000';
//   static const String wsBase = 'ws://10.10.7.118:8000';
//   static const String sendMessagePath = '/core/conversations/send_message/';
//   static const String endActivePath = '/core/conversations/end-active/';
//   static const String logoPath = '/core/logos/';

//   static String get sendMessageUrl => '$httpBase$sendMessagePath';
//   static String get endActiveUrl => '$httpBase$endActivePath';
//   static String get logoUrl => '$httpBase$logoPath';

//   static String resolveAudioUrl(String audioUrl) {
//     if (audioUrl.startsWith('http')) {
//       // Replace .24 with .118 for audio URLs
//       // return audioUrl.replaceAll('10.10.7.74:8000', '10.10.7.118:8000');
//       return audioUrl.replaceAll('api.thekaren.ai', 'thekaren.ai');
//     }
//     return '$audioBase$audioUrl';
//   }
// }

// // ws://10.10.7.118:8000/ws/voice/
/*
class AppConfig {
  static const String httpBase = 'https://api.thekaren.ai';
  static const String audioBase = 'http://10.10.7.118:8000';
  static const String wsBase = 'ws://10.10.7.118:8000';

  static const String sendMessagePath = '/core/conversations/send_message/';
  static const String endActivePath = '/core/conversations/end-active/';
  static const String logoPath = '/core/logos/';

  static String get sendMessageUrl => '$httpBase$sendMessagePath';
  static String get endActiveUrl => '$httpBase$endActivePath';
  static String get logoUrl => '$httpBase$logoPath';

  // static String resolveAudioUrl(String audioUrl) {
  //   if (audioUrl.startsWith('http')) {
  //     final uri = Uri.parse(audioUrl);
  //     return uri.replace(host: 'thekaren.ai').toString();
  //   }
  //   return '$audioBase$audioUrl';
  // }
  static String resolveAudioUrl(String audioUrl) {
    if (audioUrl.startsWith('http')) {
      // Replace .24 with .118 for audio URLs
      return audioUrl.replaceAll('api.thekaren.ai', '10.10.7.118:8000');
    }
    return '$audioBase$audioUrl';
  }
}
*/

class AppConfig {
  static const String httpBase = 'https://api.thekaren.ai';
  static const String audioBase = 'https://thekaren.ai';
  static const String wsBase = 'wss://thekaren.ai';

  static const String sendMessagePath = '/core/conversations/send_message/';
  static const String endActivePath = '/core/conversations/end-active/';
  static const String logoPath = '/core/logos/';

  static String get sendMessageUrl => '$httpBase$sendMessagePath';
  static String get endActiveUrl => '$httpBase$endActivePath';
  static String get logoUrl => '$httpBase$logoPath';

  // static String resolveAudioUrl(String audioUrl) {
  //   if (audioUrl.startsWith('http')) {
  //     final uri = Uri.parse(audioUrl);
  //     return uri.replace(host: 'thekaren.ai').toString();
  //   }
  //   return '$audioBase$audioUrl';
  // }
  static String resolveAudioUrl(String audioUrl) {
    if (audioUrl.startsWith('http')) {
      // Replace .24 with .118 for audio URLs
      return audioUrl.replaceAll('api.thekaren.ai', 'thekaren.ai');
    }
    return '$audioBase$audioUrl';
  }
}
