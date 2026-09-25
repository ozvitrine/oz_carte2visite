import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

import '../models/business_card.dart';

class CardImportService {
  Future<BusinessCard> importFromFile(String filePath) async {
    final file = File(filePath);

    if (!await file.exists()) {
      throw const FormatException('Le fichier sélectionné est introuvable.');
    }

    final content = await file.readAsString();
    final decoded = jsonDecode(content);

    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Le fichier .ozcard est invalide.');
    }

    if (decoded['format'] != 'oz_carte2visite_card') {
      throw const FormatException(
        'Ce fichier ne correspond pas à une carte oz_carte2visite.',
      );
    }

    final rawCard = decoded['card'];

    if (rawCard is! Map) {
      throw const FormatException('Les données de la carte sont manquantes.');
    }

    final cardData = Map<String, dynamic>.from(rawCard);

    final frontImage = cardData.remove('frontImageBase64');
    final backImage = cardData.remove('backImageBase64');

    cardData['frontImagePath'] = await _restoreImage(
      encodedImage: frontImage,
      side: 'recto',
    );

    cardData['backImagePath'] = await _restoreImage(
      encodedImage: backImage,
      side: 'verso',
    );

    final card = BusinessCard.fromJson(cardData);

    if (card.id.isEmpty) {
      throw const FormatException(
          'La carte reçue ne possède pas d’identifiant.');
    }

    return card;
  }

  Future<String?> _restoreImage({
    required dynamic encodedImage,
    required String side,
  }) async {
    if (encodedImage is! String || encodedImage.isEmpty) {
      return null;
    }

    try {
      final imageBytes = base64Decode(encodedImage);
      final directory = await getApplicationDocumentsDirectory();

      final fileName =
          'ozcard_${DateTime.now().microsecondsSinceEpoch}_$side.jpg';

      final imageFile = File('${directory.path}/$fileName');

      await imageFile.writeAsBytes(
        imageBytes,
        flush: true,
      );

      return imageFile.path;
    } on FormatException {
      return null;
    }
  }
}
