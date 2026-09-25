import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../models/card_folder.dart';

enum FolderChoiceType { select, create, cancel }

class FolderChoiceResult {
  final FolderChoiceType type;
  final String? folderId;

  const FolderChoiceResult.select(this.folderId)
      : type = FolderChoiceType.select;
  const FolderChoiceResult.create()
      : type = FolderChoiceType.create,
        folderId = null;
  const FolderChoiceResult.cancel()
      : type = FolderChoiceType.cancel,
        folderId = null;

  bool get isCancelled => type == FolderChoiceType.cancel;
  bool get shouldCreateFolder => type == FolderChoiceType.create;
}

class ChooseDestinationFolderDialog extends StatefulWidget {
  final List<CardFolder> folders;

  const ChooseDestinationFolderDialog({super.key, required this.folders});

  static Future<FolderChoiceResult?> show(
    BuildContext context,
    List<CardFolder> folders,
  ) {
    return showDialog<FolderChoiceResult>(
      context: context,
      barrierDismissible: false,
      builder: (_) => ChooseDestinationFolderDialog(folders: folders),
    );
  }

  @override
  State<ChooseDestinationFolderDialog> createState() =>
      _ChooseDestinationFolderDialogState();
}

class _ChooseDestinationFolderDialogState
    extends State<ChooseDestinationFolderDialog> {
  late String _selectedFolderId;

  @override
  void initState() {
    super.initState();
    _selectedFolderId = widget.folders.first.id;
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return AlertDialog(
      title: Text(t.settingsChooseFolderTitle),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(t.settingsChooseFolderBody),
            const SizedBox(height: 12),
            ...widget.folders.map(
              (folder) => RadioListTile<String>(
                value: folder.id,
                groupValue: _selectedFolderId,
                title: Text(folder.name),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _selectedFolderId = value);
                  }
                },
              ),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.create_new_folder_outlined),
              title: Text(t.settingsCreateNewFolder),
              onTap: () =>
                  Navigator.of(context).pop(const FolderChoiceResult.create()),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () =>
              Navigator.of(context).pop(const FolderChoiceResult.cancel()),
          child: Text(t.actionCancel),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context)
              .pop(FolderChoiceResult.select(_selectedFolderId)),
          child: Text(t.actionImport),
        ),
      ],
    );
  }
}
