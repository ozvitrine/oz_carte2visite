import 'package:flutter/services.dart';

class ExternalBackupFileInfo {
  const ExternalBackupFileInfo({
    required this.exists,
    required this.fileName,
    required this.size,
    required this.folderName,
  });

  final bool exists;
  final String fileName;
  final int size;
  final String folderName;
}

class ExternalBackupFolderService {
  static const _channel = MethodChannel(
    'oz_carte2visite/external_backup_folder',
  );

  Future<String?> chooseFolder() async {
    return _channel.invokeMethod<String>('chooseFolder');
  }

  Future<String?> getSelectedFolderName() async {
    return _channel.invokeMethod<String>('getSelectedFolderName');
  }

  Future<bool> hasSelectedFolder() async {
    return await _channel.invokeMethod<bool>('hasSelectedFolder') ?? false;
  }

  Future<ExternalBackupFileInfo> writeWeeklyBackup({
    required String fileName,
    required List<int> bytes,
  }) async {
    final result = await _channel.invokeMapMethod<String, dynamic>(
      'writeWeeklyBackup',
      {
        'fileName': fileName,
        'bytes': bytes,
      },
    );

    if (result == null) {
      throw PlatformException(
        code: 'EMPTY_WRITE_RESULT',
        message: 'Android n’a pas confirmé l’écriture du fichier.',
      );
    }

    return ExternalBackupFileInfo(
      exists: true,
      fileName: result['fileName']?.toString() ?? fileName,
      size: (result['size'] as num?)?.toInt() ?? 0,
      folderName: result['folderName']?.toString() ?? '',
    );
  }

  Future<ExternalBackupFileInfo> doesFileExist(
    String fileName,
  ) async {
    final result = await _channel.invokeMapMethod<String, dynamic>(
      'doesFileExist',
      {'fileName': fileName},
    );

    if (result == null) {
      throw PlatformException(
        code: 'EMPTY_CHECK_RESULT',
        message: 'Android n’a pas renvoyé le résultat de vérification.',
      );
    }

    return ExternalBackupFileInfo(
      exists: result['exists'] == true,
      fileName: result['fileName']?.toString() ?? fileName,
      size: (result['size'] as num?)?.toInt() ?? 0,
      folderName: result['folderName']?.toString() ?? '',
    );
  }

  Future<void> keepOnlyLatestSeven() async {
    await _channel.invokeMethod<void>('keepOnlyLatestSeven');
  }
}
