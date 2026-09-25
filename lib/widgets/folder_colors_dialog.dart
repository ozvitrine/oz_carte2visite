import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../l10n/app_localizations.dart';
import '../models/card_folder.dart';
import '../state/card_store.dart';
import '../theme/folder_colors.dart';

/// Liste tous les classeurs avec leur couleur, accessible depuis les
/// réglages. Remplace le bouton palette qui apparaissait auparavant sur
/// chaque classeur de l'écran d'accueil.
class FolderColorsDialog extends StatelessWidget {
  const FolderColorsDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (_) => const FolderColorsDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final folders = context.watch<CardStore>().folders;

    return AlertDialog(
      title: Text(t.settingsFolderColorsTitle),
      content: SizedBox(
        width: 320,
        child: ListView.separated(
          shrinkWrap: true,
          itemCount: folders.length,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final folder = folders[index];
            final color = resolveFolderColor(folder.colorValue, index);

            return ListTile(
              leading: CircleAvatar(backgroundColor: color, radius: 14),
              title: Text(folder.name),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _chooseColor(context, folder),
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(t.actionClose),
        ),
      ],
    );
  }

  Future<void> _chooseColor(BuildContext context, CardFolder folder) async {
    final t = AppLocalizations.of(context)!;

    // `null` signifie « fermé sans choix » ; ce repère const distingue un
    // « Réinitialiser » explicite, sans quoi fermer la boîte par erreur
    // effacerait la couleur du classeur.
    const resetSentinel = Object();

    final selected = await showDialog<Object?>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(t.homeFolderColorTitle),
          content: SizedBox(
            width: 280,
            child: Wrap(
              spacing: 14,
              runSpacing: 14,
              children: [
                for (final color in folderColorPalette)
                  InkWell(
                    onTap: () => Navigator.pop(dialogContext, color),
                    borderRadius: BorderRadius.circular(28),
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: folder.colorValue == color.toARGB32()
                            ? Border.all(
                                color: Theme.of(dialogContext)
                                    .colorScheme
                                    .onSurface,
                                width: 3,
                              )
                            : null,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(t.actionCancel),
            ),
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, resetSentinel),
              child: Text(t.actionReset),
            ),
          ],
        );
      },
    );

    if (selected == null) return;

    final newColor =
        identical(selected, resetSentinel) ? null : selected as Color;

    if (context.mounted) {
      await context.read<CardStore>().setFolderColor(folder.id, newColor);
    }
  }
}
