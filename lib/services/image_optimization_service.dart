import 'dart:io';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';

class ImageOptimizationService {
  Future<String> optimizeImage(
    String sourcePath, {
    required String imageType,
  }) async {
    final sourceFile = File(sourcePath);

    if (!await sourceFile.exists()) {
      throw const FileSystemException(
        'L’image sélectionnée est introuvable.',
      );
    }

    final destinationDirectory = await getApplicationDocumentsDirectory();

    final destinationPath = '${destinationDirectory.path}/'
        'ozcard_${DateTime.now().microsecondsSinceEpoch}_$imageType.jpg';

    final optimizedFile = await FlutterImageCompress.compressAndGetFile(
      sourcePath,
      destinationPath,
      format: CompressFormat.jpeg,
      quality: 80,
      minWidth: 1600,
      minHeight: 1600,
      keepExif: false,
    );

    if (optimizedFile == null) {
      throw const FileSystemException(
        'Impossible d’optimiser l’image.',
      );
    }

    return optimizedFile.path;
  }
}
