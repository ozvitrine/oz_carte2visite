import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../state/card_store.dart';

class RestoreModeDialog extends StatelessWidget {
  final int cardsCount;
  final int foldersCount;

  const RestoreModeDialog({
    super.key,
    required this.cardsCount,
    required this.foldersCount,
  });

  static Future<RestoreMode?> show(
    BuildContext context, {
    required int cards,
    required int folders,
  }) {
    return showDialog<RestoreMode>(
      context: context,
      builder: (_) => RestoreModeDialog(
        cardsCount: cards,
        foldersCount: folders,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return AlertDialog(
      icon: const Icon(Icons.restore_outlined),
      title: Text(t.settingsChooseRestoreModeTitle),
      content: Text(t.settingsChooseRestoreModeBody(cardsCount, foldersCount)),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(t.actionCancel),
        ),
        OutlinedButton(
          onPressed: () => Navigator.pop(context, RestoreMode.replace),
          child: Text(t.actionReplace),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, RestoreMode.merge),
          child: Text(t.actionMerge),
        ),
      ],
    );
  }
}
