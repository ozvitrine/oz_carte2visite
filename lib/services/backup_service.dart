import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:archive/archive_io.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../models/business_card.dart';
import '../models/card_folder.dart';

class BackupData {
  const BackupData({
    required this.cards,
    required this.folders,
  });

  final List<BusinessCard> cards;
  final List<CardFolder> folders;
}

class BackupService {
  static const _manifestFileName = 'backup.json';
  static const _formatName = 'oz_carte2visite_backup';
  static const _formatVersion = 1;

  Future<void> exportBackup({
    required List<BusinessCard> cards,
    required List<CardFolder> folders,
    String filePrefix = 'oz_carte2visite_sauvegarde',
    String shareSubject = 'Sauvegarde oz_carte2visite',
    String shareText = 'Sauvegarde complète des cartes de visite.',
  }) async {
    final archive = Archive();

    final encodedCards = <Map<String, dynamic>>[];

    for (final card in cards) {
      encodedCards.add(
        await _cardToBackupData(
          card,
          archive,
        ),
      );
    }

    final manifest = {
      'format': _formatName,
      'version': _formatVersion,
      'createdAt': DateTime.now().toIso8601String(),
      'folders': folders.map((folder) => folder.toJson()).toList(),
      'cards': encodedCards,
    };

    final manifestBytes = utf8.encode(
      const JsonEncoder.withIndent('  ').convert(manifest),
    );

    archive.addFile(
      ArchiveFile(
        _manifestFileName,
        manifestBytes.length,
        manifestBytes,
      ),
    );

    final zipBytes = ZipEncoder().encode(archive);

    if (zipBytes == null) {
      throw const FileSystemException(
        'Impossible de compresser la sauvegarde.',
      );
    }

    final directory = await getTemporaryDirectory();
    final file = File(
      '${directory.path}/${filePrefix}_${_timestamp()}.ozbackup',
    );

    await file.writeAsBytes(
      zipBytes,
      flush: true,
    );

    await Share.shareXFiles(
      [XFile(file.path)],
      subject: shareSubject,
      text: shareText,
    );
  }

  Future<BackupData> pickAndRestoreBackup() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.any,
      allowMultiple: false,
      withData: true,
    );

    if (result == null) {
      throw const BackupCancelledException();
    }

    final pickedFile = result.files.single;
    final bytes = pickedFile.bytes;

    if (bytes != null) {
      return restoreFromBytes(bytes);
    }

    final path = pickedFile.path;

    if (path == null || path.isEmpty) {
      throw const FormatException(
        'Impossible de lire le fichier de sauvegarde.',
      );
    }

    return restoreFromBytes(await File(path).readAsBytes());
  }

  Future<BackupData> restoreFromBytes(Uint8List bytes) async {
    final archive = ZipDecoder().decodeBytes(bytes);

    final manifestFile = archive.findFile(_manifestFileName);

    if (manifestFile == null) {
      throw const FormatException(
        'Le fichier ne contient pas de sauvegarde oz_carte2visite valide.',
      );
    }

    final manifestText = utf8.decode(
      manifestFile.content as List<int>,
    );

    final decoded = jsonDecode(manifestText);

    if (decoded is! Map<String, dynamic> ||
        decoded['format'] != _formatName ||
        decoded['version'] != _formatVersion) {
      throw const FormatException(
        'Le format de sauvegarde est invalide ou non compatible.',
      );
    }

    final rawFolders = decoded['folders'];
    final rawCards = decoded['cards'];

    if (rawFolders is! List || rawCards is! List) {
      throw const FormatException(
        'La sauvegarde ne contient pas les données attendues.',
      );
    }

    final folders = rawFolders
        .whereType<Map>()
        .map(
          (item) => CardFolder.fromJson(
            Map<String, dynamic>.from(item),
          ),
        )
        .where((folder) => folder.id.isNotEmpty)
        .toList();

    final cards = <BusinessCard>[];

    for (final rawCard in rawCards.whereType<Map>()) {
      final cardData = Map<String, dynamic>.from(rawCard);

      final frontImageName = cardData.remove('frontImageFile');
      final backImageName = cardData.remove('backImageFile');

      cardData['frontImagePath'] = await _restoreImage(
        archive: archive,
        imageFileName: frontImageName,
      );

      cardData['backImagePath'] = await _restoreImage(
        archive: archive,
        imageFileName: backImageName,
      );

      final card = BusinessCard.fromJson(cardData);

      if (card.id.isNotEmpty) {
        cards.add(card);
      }
    }

    return BackupData(
      cards: cards,
      folders: folders,
    );
  }

  Future<Map<String, dynamic>> _cardToBackupData(
    BusinessCard card,
    Archive archive,
  ) async {
    final data = card.toJson();

    data.remove('frontImagePath');
    data.remove('backImagePath');

    final frontImageName = await _addImageToArchive(
      archive: archive,
      imagePath: card.frontImagePath,
      cardId: card.id,
      side: 'front',
    );

    final backImageName = await _addImageToArchive(
      archive: archive,
      imagePath: card.backImagePath,
      cardId: card.id,
      side: 'back',
    );

    return {
      ...data,
      'frontImageFile': frontImageName,
      'backImageFile': backImageName,
    };
  }

  Future<String?> _addImageToArchive({
    required Archive archive,
    required String? imagePath,
    required String cardId,
    required String side,
  }) async {
    if (imagePath == null || imagePath.isEmpty) {
      return null;
    }

    final imageFile = File(imagePath);

    if (!await imageFile.exists()) {
      return null;
    }

    final extension = _extension(imagePath);
    final archiveName = 'images/${cardId}_$side$extension';
    final bytes = await imageFile.readAsBytes();

    archive.addFile(
      ArchiveFile(
        archiveName,
        bytes.length,
        bytes,
      ),
    );

    return archiveName;
  }

  Future<String?> _restoreImage({
    required Archive archive,
    required dynamic imageFileName,
  }) async {
    if (imageFileName is! String || imageFileName.isEmpty) {
      return null;
    }

    final archiveFile = archive.findFile(imageFileName);

    if (archiveFile == null) {
      return null;
    }

    final content = archiveFile.content;

    if (content is! List<int>) {
      return null;
    }

    final directory = await getApplicationDocumentsDirectory();
    final extension = _extension(imageFileName);

    final destination = File(
      '${directory.path}/ozbackup_${DateTime.now().microsecondsSinceEpoch}$extension',
    );

    await destination.writeAsBytes(
      content,
      flush: true,
    );

    return destination.path;
  }

  String _extension(String path) {
    final dotPosition = path.lastIndexOf('.');

    if (dotPosition == -1) {
      return '.jpg';
    }

    final extension = path.substring(dotPosition).toLowerCase();

    if (extension.length > 5) {
      return '.jpg';
    }

    return extension;
  }

  String _timestamp() {
    return DateTime.now()
        .toIso8601String()
        .replaceAll(':', '-')
        .replaceAll('.', '-');
  }
}

class BackupCancelledException implements Exception {
  const BackupCancelledException();
}
