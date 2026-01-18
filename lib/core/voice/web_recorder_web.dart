// Web-specific implementation using dart:html
import 'dart:async';
import 'dart:typed_data';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

/// Stub function for web - throws error (not used on web)
Future<String> getMobileRecordingPath() async {
  throw UnsupportedError('getMobileRecordingPath is not supported on web');
}

/// Stub function for reading file bytes on web - not used
Future<Uint8List> readFileBytes(String path) async {
  throw UnsupportedError('readFileBytes is not supported on web');
}

/// Fetch blob URL and convert to bytes using JavaScript fetch API
Future<Uint8List?> fetchBlobAsBytes(String blobUrl) async {
  print('🔄 [WEB] fetchBlobAsBytes called with: $blobUrl');

  try {
    // Use XMLHttpRequest to fetch blob data
    final completer = Completer<Uint8List?>();

    final xhr = html.HttpRequest();
    xhr.open('GET', blobUrl);
    xhr.responseType = 'arraybuffer';

    print('📡 [WEB] XHR opened for blob URL');

    xhr.onLoad.listen((event) {
      print('📥 [WEB] XHR onLoad - status: ${xhr.status}');
      if (xhr.status == 200 || xhr.status == 0) {
        // status 0 is OK for blob URLs
        try {
          final response = xhr.response;
          if (response == null) {
            print('❌ [WEB] XHR response is null');
            completer.complete(null);
            return;
          }
          final arrayBuffer = response as ByteBuffer;
          final bytes = Uint8List.view(arrayBuffer);
          print('✅ [WEB] Blob fetched successfully: ${bytes.length} bytes');
          completer.complete(bytes);
        } catch (e) {
          print('❌ [WEB] Error processing response: $e');
          completer.complete(null);
        }
      } else {
        print('❌ [WEB] Failed to fetch blob: ${xhr.status}');
        completer.complete(null);
      }
    });

    xhr.onError.listen((event) {
      print('❌ [WEB] XHR error fetching blob: $event');
      if (!completer.isCompleted) {
        completer.complete(null);
      }
    });

    xhr.onTimeout.listen((event) {
      print('❌ [WEB] XHR timeout');
      if (!completer.isCompleted) {
        completer.complete(null);
      }
    });

    xhr.send();
    print('📤 [WEB] XHR request sent');

    // Add timeout
    return await completer.future.timeout(
      const Duration(seconds: 10),
      onTimeout: () {
        print('❌ [WEB] Blob fetch timed out');
        return null;
      },
    );
  } catch (e) {
    print('❌ [WEB] Error in fetchBlobAsBytes: $e');
    return null;
  }
}
