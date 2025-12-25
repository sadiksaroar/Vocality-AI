import 'dart:io';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';

class RecorderService {
  final _recorder = AudioRecorder();

  Future<bool> start() async {
    try {
      if (!await _recorder.hasPermission()) {
        return false;
      }

      final dir = Platform.isAndroid || Platform.isIOS
          ? await getApplicationDocumentsDirectory()
          : await getTemporaryDirectory();

      final path =
          '${dir.path}/rec_${DateTime.now().millisecondsSinceEpoch}.m4a';

      await _recorder.start(
        const RecordConfig(
          encoder: AudioEncoder.aacLc,
          bitRate: 128000,
          sampleRate: 44100,
        ),
        path: path,
      );

      return true;
    } catch (e) {
      print('Error starting recording: $e');
      return false;
    }
  }

  Future<String?> stop() async {
    try {
      return await _recorder.stop();
    } catch (e) {
      print('Error stopping recording: $e');
      return null;
    }
  }

  Future<void> dispose() async {
    await _recorder.dispose();
  }

  Future<bool> isRecording() async {
    return await _recorder.isRecording();
  }
}
