// IO-specific implementations for mobile platforms
import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';

/// Get mobile recording path
Future<String> getMobileRecordingPath() async {
  Directory dir;
  if (Platform.isAndroid || Platform.isIOS) {
    dir = await getApplicationDocumentsDirectory();
  } else {
    dir = await getTemporaryDirectory();
  }
  return '${dir.path}/rec_${DateTime.now().millisecondsSinceEpoch}.m4a';
}

/// Read file bytes
Future<Uint8List> readFileBytes(String path) async {
  final file = File(path);
  return await file.readAsBytes();
}

/// Stub function for mobile - not used
Future<Uint8List?> fetchBlobAsBytes(String blobUrl) async {
  throw UnsupportedError('fetchBlobAsBytes is not supported on mobile');
}
