import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../models/card_folder.dart';

/// Laisse choisir un sous-ensemble de classeurs avant une transmission —
/// contrairement à une sauvegarde complète, qui inclut toujours tout.
/// Retourne la liste des identifiants de classeurs cochés, ou `null` si
/// l'utilisateur annule.
class SelectFoldersDialog extends StatefulWidget {
  const SelectFoldersDialog({super.key, required this.folders});

  final List<CardFolder> folders;

  static Future<List<String>?> show(
    BuildContext context, {
    required List<CardFolder> folders,
  }) {
    return showDialog<List<String>>(
      context: context,
      builder: (_) => SelectFoldersDialog(folders: folders),
    );
  }

  @override
  State<SelectFoldersDialog> createState() => _SelectFoldersDialogState();
}

class _SelectFoldersDialogState extends State<SelectFoldersDialog> {
  // Tout coché par défaut : l'utilisateur décoche ce qu'il ne veut pas
  // transmettre, plutôt que de devoir tout recocher un par un.
  late Set<String> _selected;

  @override
  void initState() {
    super.initState();
    // Abonnement et Fidélité restent décochés par défaut : l'utilisateur
    // doit les inclure volontairement, plutôt que de risquer de les
    // transmettre sans y penser.
    _selected = widget.folders
        .where((folder) => folder.kind == FolderKind.businessCard)
        .map((folder) => folder.id)
        .toSet();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return AlertDialog(
      title: Text(t.settingsSelectFoldersTitle),
      content: SizedBox(
        width: 320,
        child: ListView(
          shrinkWrap: true,
          children: [
            for (final folder in widget.folders)
              CheckboxListTile(
                value: _selected.contains(folder.id),
                title: Text(folder.name),
                onChanged: (checked) {
                  setState(() {
                    if (checked ?? false) {
                      _selected.add(folder.id);
                    } else {
                      _selected.remove(folder.id);
                    }
                  });
                },
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(t.actionCancel),
        ),
        FilledButton(
          onPressed: _selected.isEmpty
              ? null
              : () => Navigator.pop(context, _selected.toList()),
          child: Text(t.actionValidate),
        ),
      ],
    );
  }
}
