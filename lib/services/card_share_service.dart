import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../models/business_card.dart';

class CardShareService {
  Future<void> shareCard(BusinessCard card) async {
    final payload = {
      'format': 'oz_carte2visite_card',
      'version': 1,
      'card': {
        ...card.toJson(),
        'frontImageBase64': await _imageToBase64(card.frontImagePath),
        'backImageBase64': await _imageToBase64(card.backImagePath),
      },
    };

    final directory = await getTemporaryDirectory();
    final file = File('${directory.path}/${_fileName(card)}');

    await file.writeAsString(
      const JsonEncoder.withIndent('  ').convert(payload),
      flush: true,
    );

    await Share.shareXFiles(
      [XFile(file.path)],
      subject: 'Carte de visite ${card.title}',
      text: 'Carte de visite partagée depuis oz_carte2visite.',
    );
  }

  Future<String?> _imageToBase64(String? imagePath) async {
    if (imagePath == null || imagePath.isEmpty) return null;

    final imageFile = File(imagePath);

    if (!await imageFile.exists()) return null;

    try {
      return base64Encode(await imageFile.readAsBytes());
    } on FileSystemException {
      return null;
    }
  }

  String _fileName(BusinessCard card) {
    final rawName = card.title.isEmpty ? 'carte' : card.title;

    final safeName =
        rawName.replaceAll(RegExp(r'[^a-zA-Z0-9_-]'), '_').toLowerCase();

    return 'oz_carte2visite_$safeName.ozcard';
  }
}
