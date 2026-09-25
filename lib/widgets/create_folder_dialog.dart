import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../l10n/app_localizations.dart';
import '../models/card_folder.dart';
import '../state/app_settings_store.dart';

class CreateFolderResult {
  const CreateFolderResult({required this.name, required this.kind});

  final String name;
  final FolderKind kind;
}

class CreateFolderDialog extends StatefulWidget {
  const CreateFolderDialog({super.key});

  static Future<CreateFolderResult?> show(BuildContext context) {
    return showDialog<CreateFolderResult>(
      context: context,
      builder: (_) => const CreateFolderDialog(),
    );
  }

  @override
  State<CreateFolderDialog> createState() => _CreateFolderDialogState();
}

class _CreateFolderDialogState extends State<CreateFolderDialog> {
  final _controller = TextEditingController();

  // Fixé une fois le classeur créé — jamais modifiable ensuite, d'où
  // l'importance de le demander dès cet écran.
  FolderKind _kind = FolderKind.businessCard;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final settings = context.watch<AppSettingsStore>();

    final showKindPicker =
        settings.subscriptionFoldersEnabled || settings.discountFoldersEnabled;

    return AlertDialog(
      title: Text(t.homeNewFolderTitle),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _controller,
              autofocus: true,
              decoration: InputDecoration(
                labelText: t.homeFolderNameLabel,
                border: const OutlineInputBorder(),
              ),
            ),
            if (showKindPicker) ...[
              const SizedBox(height: 16),
              Text(
                t.folderKindTitle,
                style: Theme.of(context).textTheme.labelLarge,
              ),
              RadioListTile<FolderKind>(
                value: FolderKind.businessCard,
                groupValue: _kind,
                dense: true,
                contentPadding: EdgeInsets.zero,
                title: Text(t.folderKindBusinessCard),
                subtitle: Text(t.folderKindBusinessCardDetail),
                onChanged: (value) => setState(() => _kind = value!),
              ),
              if (settings.subscriptionFoldersEnabled)
                RadioListTile<FolderKind>(
                  value: FolderKind.subscription,
                  groupValue: _kind,
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  title: Text(t.folderKindSubscription),
                  subtitle: Text(t.folderKindSubscriptionDetail),
                  onChanged: (value) => setState(() => _kind = value!),
                ),
              if (settings.discountFoldersEnabled)
                RadioListTile<FolderKind>(
                  value: FolderKind.discount,
                  groupValue: _kind,
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  title: Text(t.folderKindDiscount),
                  subtitle: Text(t.folderKindDiscountDetail),
                  onChanged: (value) => setState(() => _kind = value!),
                ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(t.actionCancel),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(
            CreateFolderResult(
              name: _controller.text.trim(),
              kind: showKindPicker ? _kind : FolderKind.businessCard,
            ),
          ),
          child: Text(t.actionCreate),
        ),
      ],
    );
  }
}
