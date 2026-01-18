// Stub file for web platform - these functions are not used on web
import 'dart:async';
import 'dart:typed_data';

/// Stub function for web - returns empty string
Future<String> getMobileRecordingPath() async {
  throw UnsupportedError('getMobileRecordingPath is not supported on web');
}

/// Stub function for reading file bytes on web
Future<Uint8List> readFileBytes(String path) async {
  throw UnsupportedError('readFileBytes is not supported on web');
}

/// Stub function for fetching blob - not used on mobile
Future<Uint8List?> fetchBlobAsBytes(String blobUrl) async {
  throw UnsupportedError('fetchBlobAsBytes is not supported on mobile');
}
