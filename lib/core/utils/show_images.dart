import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

class ImageLoader {
  static final Map<String, Uint8List> _cache = {};

  // Load image cross-platform dan compress/resizing otomatis
  static Future<dynamic> loadImage({
    int maxWidth = 1080,
    int quality = 70,
  }) async {
    if (kIsWeb) {
      final result = await FilePicker.platform.pickFiles(type: FileType.image);
      if (result != null && result.files.single.bytes != null) {
        final bytes = result.files.single.bytes!;
        // cache agar tidak decode ulang
        _cache['web_image'] = bytes;
        return bytes;
      }
      return null;
    } else {
      File file = File(
        '/assets/images/app_logo.png',
      ); // ganti path sesuai device
      if (file.existsSync()) {
        final path = file.path;
        if (_cache.containsKey(path)) {
          return _cache[path];
        }

        // compress & resize
        final result = await FlutterImageCompress.compressWithFile(
          path,
          minWidth: maxWidth,
          quality: quality,
        );

        if (result != null) {
          _cache[path] = Uint8List.fromList(result);
          return _cache[path];
        }
      }
      return null;
    }
  }
}
