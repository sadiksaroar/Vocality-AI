import 'dart:io';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';

class RecorderService {
  final AudioRecorder _recorder = AudioRecorder();
  late String _currentPath;

  Future<bool> start() async {
    if (!await _recorder.hasPermission()) return false;
    final dir = Platform.isAndroid || Platform.isIOS
        ? await getApplicationDocumentsDirectory()
        : await getTemporaryDirectory();
    _currentPath =
        '${dir.path}/rec_${DateTime.now().millisecondsSinceEpoch}.m4a';

    try {
      await _recorder.start(
        RecordConfig(
          encoder: AudioEncoder.aacLc,
          bitRate: 128000,
          sampleRate: 44100,
        ),
        path: _currentPath,
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<String?> stop() async {
    final path = await _recorder.stop();
    return path ?? _currentPath;
  }
}
