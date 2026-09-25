import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/card_folder.dart';
import '../services/global_pdf_export_service.dart';
import '../state/app_settings_store.dart';
import '../state/card_store.dart';
import '../l10n/app_localizations.dart';
import '../theme/folder_colors.dart';
import '../widgets/create_folder_dialog.dart';
import 'folder_cards_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isExporting = false;

  @override
  void initState() {
    super.initState();
    // Après le premier rendu : le contexte a alors accès à Provider et à
    // AppLocalizations, ce qui n'est pas garanti dans initState lui-même.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkExpiringSubscriptions();
    });
  }

  Future<void> _checkExpiringSubscriptions() async {
    if (!mounted) return;

    final expiring = context.read<CardStore>().expiringSubscriptionCards;

    if (expiring.isEmpty) return;

    final t = AppLocalizations.of(context)!;

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          icon: const Icon(Icons.event_busy_outlined),
          title: Text(t.homeExpiringSubscriptionsTitle),
          content: SizedBox(
            width: 320,
            child: ListView(
              shrinkWrap: true,
              children: [
                for (final card in expiring)
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.card_membership_outlined),
                    title: Text(card.title),
                    subtitle: Text(
                      t.homeExpiringSubscriptionDate(
                        _formatDate(card.expirationDate!),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          actions: [
            FilledButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(t.actionClose),
            ),
          ],
        );
      },
    );
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');

    return '$day/$month/${date.year}';
  }

  Future<void> _createFolder() async {
    final t = AppLocalizations.of(context)!;

    final result = await CreateFolderDialog.show(context);

    if (result == null || !mounted) return;

    final cleanName = result.name.trim();

    if (cleanName.isEmpty) return;

    final created =
        await context.read<CardStore>().addFolder(cleanName, kind: result.kind);

    if (!mounted) return;

    if (!created) {
      _showMessage(t.homeFolderNameTaken(cleanName));
      return;
    }

    _showMessage(t.homeFolderCreated(cleanName));
  }

  Future<void> _renameFolder(CardFolder folder) async {
    final t = AppLocalizations.of(context)!;
    final controller = TextEditingController(text: folder.name);

    final name = await showDialog<String>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(t.homeRenameFolderTitle),
          content: TextField(
            controller: controller,
            autofocus: true,
            decoration: InputDecoration(
              labelText: t.homeFolderNameLabel,
              border: OutlineInputBorder(),
            ),
            onSubmitted: (value) {
              Navigator.of(dialogContext).pop(value.trim());
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(t.actionCancel),
            ),
            FilledButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(
                  controller.text.trim(),
                );
              },
              child: Text(t.actionRename),
            ),
          ],
        );
      },
    );

    await Future<void>.delayed(
      const Duration(milliseconds: 200),
    );

    controller.dispose();

    final cleanName = name?.trim() ?? '';

    if (cleanName.isEmpty || !mounted) return;

    if (cleanName == folder.name) return;

    final renamed = await context.read<CardStore>().renameFolder(
          folder.id,
          cleanName,
        );

    if (!mounted) return;

    if (!renamed) {
      _showMessage(t.homeFolderNameTaken(cleanName));
      return;
    }

    _showMessage(t.homeFolderRenamed(cleanName));
  }

  Future<void> _exportAllFolders() async {
    final t = AppLocalizations.of(context)!;

    if (!context.read<AppSettingsStore>().canUseSettings) {
      _showMessage(t.premiumRequiredMessage);
      return;
    }

    final store = context.read<CardStore>();

    // Les classeurs Abonnement et Carte de fidélité ne sont jamais
    // transmis, y compris dans cet export global — on les exclut plutôt
    // que de bloquer l'export entier pour les classeurs qui restent
    // autorisés.
    final transferableFolders = store.folders
        .where((folder) => folder.kind == FolderKind.businessCard)
        .toList();
    final transferableFolderIds =
        transferableFolders.map((folder) => folder.id).toSet();
    final transferableCards = store.cards
        .where((card) => transferableFolderIds.contains(card.folderId))
        .toList();

    if (transferableCards.isEmpty) {
      _showMessage(t.homeAddCardBeforeExport);
      return;
    }

    setState(() => _isExporting = true);

    try {
      await GlobalPdfExportService().exportAllFolders(
        folders: transferableFolders,
        cards: transferableCards,
      );

      if (mounted) {
        _showMessage(AppLocalizations.of(context)!.homeGlobalPdfReady);
      }
    } catch (_) {
      if (mounted) {
        _showMessage(AppLocalizations.of(context)!.homeGlobalPdfError);
      }
    } finally {
      if (mounted) {
        setState(() => _isExporting = false);
      }
    }
  }

  void _showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 80),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final store = context.watch<CardStore>();
    final settings = context.watch<AppSettingsStore>();

    // Le classeur par défaut Abonnement / Carte de fidélité ne peut pas
    // être supprimé (comme tout classeur par défaut), mais peut être
    // masqué depuis les réglages — réservé au Premium.
    final visibleFolders = settings.subscriptionFoldersEnabled
        ? store.folders
        : store.folders
            .where((folder) => folder.kind != FolderKind.subscription)
            .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(t.homeTitle),
        actions: [
          IconButton(
            tooltip: t.homeExportAllTooltip,
            onPressed: _isExporting ? null : _exportAllFolders,
            icon: _isExporting
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.picture_as_pdf_outlined),
          ),
          IconButton(
            tooltip: t.homeSettingsTooltip,
            onPressed: _isExporting
                ? null
                : () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const SettingsScreen(),
                      ),
                    );
                  },
            icon: const Icon(Icons.settings_outlined),
          ),
        ],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: visibleFolders.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final folder = visibleFolders[index];
          final count = store.cardsForFolder(folder.id).length;
          final folderColor = resolveFolderColor(folder.colorValue, index);
          final tintedBackground = Color.alphaBlend(
            folderColor.withValues(alpha: 0.12),
            Theme.of(context).colorScheme.surface,
          );

          return Card(
            color: tintedBackground,
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: folderColor,
                foregroundColor: Colors.white,
                child: const Icon(Icons.folder_outlined),
              ),
              title: Text(folder.name),
              subtitle: Text(t.homeCardCount(count)),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!folder.isDefault)
                    IconButton(
                      tooltip: t.homeRenameFolderTooltip,
                      onPressed:
                          _isExporting ? null : () => _renameFolder(folder),
                      icon: const Icon(Icons.edit_outlined),
                    ),
                  const Icon(Icons.chevron_right),
                ],
              ),
              onTap: _isExporting
                  ? null
                  : () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => FolderCardsScreen(folder: folder),
                        ),
                      );
                    },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _isExporting ? null : _createFolder,
        icon: const Icon(Icons.create_new_folder_outlined),
        label: Text(t.homeNewFolderTitle),
      ),
    );
  }
}
