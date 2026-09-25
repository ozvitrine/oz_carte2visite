import 'dart:convert';
import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/business_card.dart';
import '../models/card_folder.dart';
import 'external_backup_folder_service.dart';

class ExternalBackupStatus {
  const ExternalBackupStatus({
    required this.hasFolder,
    required this.hasBackupForCurrentWeek,
    required this.folderName,
    required this.fileName,
    required this.fileSize,
  });

  final bool hasFolder;
  final bool hasBackupForCurrentWeek;
  final String? folderName;
  final String fileName;
  final int fileSize;
}

class AutomaticBackupService {
  static const _lastExternalBackupWeekKey =
      'external_backup_last_completed_week';
  static const _formatName = 'oz_carte2visite_backup';
  static const _formatVersion = 1;
  static const _manifestFileName = 'backup.json';
  static const _localBackupFileName = 'oz_carte2visite_backup_local.ozbackup';

  Future<bool> saveAfterChange({
    required List<BusinessCard> cards,
    required List<CardFolder> folders,
    required bool externalBackupEnabled,
  }) async {
    final bytes = await _buildBackupBytes(
      cards: cards,
      folders: folders,
    );

    await _writeLocalBackup(bytes);

    if (!externalBackupEnabled) return false;

    return _writeExternalBackupForCurrentWeekIfMissing(
      bytes: bytes,
    );
  }

  Future<void> activateExternalBackup({
    required List<BusinessCard> cards,
    required List<CardFolder> folders,
  }) async {
    if (cards.isEmpty) {
      throw const FileSystemException(
        'Ajoutez au moins une carte avant d’activer la sauvegarde externe.',
      );
    }

    final externalFolder = ExternalBackupFolderService();

    if (!await externalFolder.hasSelectedFolder()) {
      throw const FileSystemException(
        'Choisissez d’abord un dossier de sauvegarde externe.',
      );
    }

    final bytes = await _buildBackupBytes(
      cards: cards,
      folders: folders,
    );

    await _writeLocalBackup(bytes);

    final weekKey = _weekKey(DateTime.now());
    final fileName = _externalFileName(weekKey);

    final writtenFile = await externalFolder.writeWeeklyBackup(
      fileName: fileName,
      bytes: bytes,
    );

    if (!writtenFile.exists || writtenFile.size <= 0) {
      throw const FileSystemException(
        'Le dossier n’a pas confirmé la création de la sauvegarde externe.',
      );
    }

    await externalFolder.keepOnlyLatestSeven();

    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(
      _lastExternalBackupWeekKey,
      weekKey,
    );
  }

  Future<ExternalBackupStatus> checkExternalBackup() async {
    final externalFolder = ExternalBackupFolderService();
    final hasFolder = await externalFolder.hasSelectedFolder();
    final weekKey = _weekKey(DateTime.now());
    final fileName = _externalFileName(weekKey);

    if (!hasFolder) {
      return ExternalBackupStatus(
        hasFolder: false,
        hasBackupForCurrentWeek: false,
        folderName: null,
        fileName: fileName,
        fileSize: 0,
      );
    }

    final fileInfo = await externalFolder.doesFileExist(fileName);

    // L'état n'est enregistré qu'après une écriture Android confirmée.
    final preferences = await SharedPreferences.getInstance();

    if (fileInfo.exists && fileInfo.size > 0) {
      await preferences.setString(
        _lastExternalBackupWeekKey,
        weekKey,
      );
    }

    return ExternalBackupStatus(
      hasFolder: true,
      hasBackupForCurrentWeek: fileInfo.exists && fileInfo.size > 0,
      folderName: fileInfo.folderName.isEmpty
          ? await externalFolder.getSelectedFolderName()
          : fileInfo.folderName,
      fileName: fileInfo.fileName,
      fileSize: fileInfo.size,
    );
  }

  Future<File> localBackupFile() async {
    final directory = await getApplicationDocumentsDirectory();

    return File(
      '${directory.path}/$_localBackupFileName',
    );
  }

  Future<bool> _writeExternalBackupForCurrentWeekIfMissing({
    required List<int> bytes,
  }) async {
    final externalFolder = ExternalBackupFolderService();

    if (!await externalFolder.hasSelectedFolder()) return false;

    final weekKey = _weekKey(DateTime.now());
    final fileName = _externalFileName(weekKey);
    final existingFile = await externalFolder.doesFileExist(fileName);

    // Vérification réelle du dossier : aucun faux succès basé sur une préférence.
    if (existingFile.exists && existingFile.size > 0) {
      final preferences = await SharedPreferences.getInstance();
      await preferences.setString(
        _lastExternalBackupWeekKey,
        weekKey,
      );
      return false;
    }

    final writtenFile = await externalFolder.writeWeeklyBackup(
      fileName: fileName,
      bytes: bytes,
    );

    if (!writtenFile.exists || writtenFile.size <= 0) {
      throw const FileSystemException(
        'Le dossier n’a pas confirmé la création de la sauvegarde externe.',
      );
    }

    await externalFolder.keepOnlyLatestSeven();

    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(
      _lastExternalBackupWeekKey,
      weekKey,
    );

    return true;
  }

  Future<void> _writeLocalBackup(List<int> bytes) async {
    final backupFile = await localBackupFile();

    await backupFile.writeAsBytes(
      bytes,
      flush: true,
    );
  }

  Future<List<int>> _buildBackupBytes({
    required List<BusinessCard> cards,
    required List<CardFolder> folders,
  }) async {
    final archive = Archive();
    final encodedCards = <Map<String, dynamic>>[];

    for (final card in cards) {
      encodedCards.add(
        await _cardToBackupData(
          card: card,
          archive: archive,
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

    final compressed = ZipEncoder().encode(archive);

    if (compressed == null) {
      throw const FileSystemException(
        'Impossible de compresser la sauvegarde locale.',
      );
    }

    return compressed;
  }

  Future<Map<String, dynamic>> _cardToBackupData({
    required BusinessCard card,
    required Archive archive,
  }) async {
    final data = card.toJson();

    data.remove('frontImagePath');
    data.remove('backImagePath');

    final frontImageFile = await _addImageToArchive(
      archive: archive,
      path: card.frontImagePath,
      cardId: card.id,
      side: 'front',
    );

    final backImageFile = await _addImageToArchive(
      archive: archive,
      path: card.backImagePath,
      cardId: card.id,
      side: 'back',
    );

    return {
      ...data,
      'frontImageFile': frontImageFile,
      'backImageFile': backImageFile,
    };
  }

  Future<String?> _addImageToArchive({
    required Archive archive,
    required String? path,
    required String cardId,
    required String side,
  }) async {
    if (path == null || path.isEmpty) return null;

    final image = File(path);

    if (!await image.exists()) return null;

    final extension = _extension(path);
    final archivePath = 'images/${cardId}_$side$extension';
    final bytes = await image.readAsBytes();

    archive.addFile(
      ArchiveFile(
        archivePath,
        bytes.length,
        bytes,
      ),
    );

    return archivePath;
  }

  String _extension(String path) {
    final index = path.lastIndexOf('.');

    if (index == -1) return '.jpg';

    final extension = path.substring(index).toLowerCase();

    return extension.length > 5 ? '.jpg' : extension;
  }

  String _externalFileName(String weekKey) {
    return 'oz_carte2visite_auto_$weekKey.ozbackup';
  }

  String _weekKey(DateTime date) {
    final year = date.year;
    final firstDay = DateTime(year, 1, 1);
    final firstMondayOffset = (8 - firstDay.weekday) % 7;
    final firstMonday = firstDay.add(
      Duration(days: firstMondayOffset),
    );

    final week = date.isBefore(firstMonday)
        ? 1
        : (date.difference(firstMonday).inDays ~/ 7) + 2;

    return '${year}_S${week.toString().padLeft(2, '0')}';
  }
}
