import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:record/record.dart';

// Conditional import for platform-specific functions
import 'web_recorder_stub.dart'
    if (dart.library.html) 'web_recorder_web.dart'
    if (dart.library.io) 'web_recorder_io.dart'
    as platform;

/// A cross-platform audio recorder service that works on web and mobile.
/// On mobile, it records to a file and returns the file path.
/// On web, it records to a blob and fetches the bytes.
class WebRecorderService {
  final AudioRecorder _recorder = AudioRecorder();
  String? _currentPath;
  Uint8List? _recordedBytes;
  bool _isRecording = false;

  /// Check if recorder has permission
  Future<bool> hasPermission() async {
    return await _recorder.hasPermission();
  }

  /// Start recording audio
  /// Returns true if recording started successfully
  Future<bool> start() async {
    if (!await _recorder.hasPermission()) {
      debugPrint('❌ No recording permission');
      return false;
    }

    _recordedBytes = null;
    _currentPath = null;
    _isRecording = true;

    try {
      if (kIsWeb) {
        // Web: Record to blob URL - the record package handles this automatically
        // Using webm format with opus codec for web compatibility
        await _recorder.start(
          const RecordConfig(
            encoder: AudioEncoder.opus,
            bitRate: 128000,
            sampleRate: 16000,
            numChannels: 1,
          ),
          path: '', // Empty path for web - will create blob URL
        );

        debugPrint('🎤 Web recording started (blob mode)');
        return true;
      } else {
        // Mobile: Record to file
        _currentPath = await platform.getMobileRecordingPath();

        await _recorder.start(
          const RecordConfig(
            encoder: AudioEncoder.aacLc,
            bitRate: 128000,
            sampleRate: 44100,
          ),
          path: _currentPath!,
        );

        debugPrint('🎤 Mobile recording started: $_currentPath');
        return true;
      }
    } catch (e) {
      debugPrint('❌ Failed to start recording: $e');
      _isRecording = false;
      return false;
    }
  }

  /// Stop recording and return the audio data
  /// Returns AudioRecordingResult containing either file path (mobile) or bytes (web)
  Future<AudioRecordingResult> stop() async {
    _isRecording = false;

    try {
      // Stop the recorder and get the path/URL
      final path = await _recorder.stop();
      debugPrint('⏹️ Recording stopped. Path: $path');

      if (path == null || path.isEmpty) {
        debugPrint('⚠️ No recording path returned');
        return AudioRecordingResult.empty();
      }

      if (kIsWeb) {
        // Web: path is a blob URL, fetch the bytes using JavaScript interop
        try {
          debugPrint('🔄 Fetching blob URL: $path');
          final bytes = await platform.fetchBlobAsBytes(path);
          if (bytes != null && bytes.isNotEmpty) {
            _recordedBytes = bytes;
            debugPrint(
              '⏹️ Web recording fetched. Bytes: ${_recordedBytes!.length}',
            );
            return AudioRecordingResult.fromBytes(_recordedBytes!);
          } else {
            debugPrint('❌ Failed to fetch blob: bytes is null or empty');
            return AudioRecordingResult.empty();
          }
        } catch (e) {
          debugPrint('❌ Error fetching blob URL: $e');
          return AudioRecordingResult.empty();
        }
      } else {
        // Mobile: Return file path
        _currentPath = path;
        return AudioRecordingResult.fromPath(path);
      }
    } catch (e) {
      debugPrint('❌ Error stopping recording: $e');
      return AudioRecordingResult.empty();
    }
  }

  /// Check if currently recording
  bool get isRecording => _isRecording;

  /// Cancel recording without saving
  Future<void> cancel() async {
    _isRecording = false;
    _recordedBytes = null;

    try {
      await _recorder.stop();
    } catch (e) {
      debugPrint('❌ Error canceling recording: $e');
    }
  }

  /// Dispose resources
  void dispose() {
    _recorder.dispose();
  }
}

/// Result of an audio recording
/// Contains either a file path (mobile) or audio bytes (web)
class AudioRecordingResult {
  final String? filePath;
  final Uint8List? bytes;
  final bool isEmpty;

  AudioRecordingResult._({this.filePath, this.bytes, required this.isEmpty});

  factory AudioRecordingResult.fromPath(String path) {
    return AudioRecordingResult._(filePath: path, bytes: null, isEmpty: false);
  }

  factory AudioRecordingResult.fromBytes(Uint8List bytes) {
    return AudioRecordingResult._(
      filePath: null,
      bytes: bytes,
      isEmpty: bytes.isEmpty,
    );
  }

  factory AudioRecordingResult.empty() {
    return AudioRecordingResult._(filePath: null, bytes: null, isEmpty: true);
  }

  /// Check if result contains a file path
  bool get hasFilePath => filePath != null && filePath!.isNotEmpty;

  /// Check if result contains audio bytes
  bool get hasBytes => bytes != null && bytes!.isNotEmpty;

  /// Get the audio bytes (reads from file on mobile if needed)
  Future<Uint8List?> getBytes() async {
    if (hasBytes) {
      return bytes;
    }
    if (hasFilePath && !kIsWeb) {
      try {
        return await platform.readFileBytes(filePath!);
      } catch (e) {
        debugPrint('❌ Error reading file bytes: $e');
      }
    }
    return null;
  }
}
