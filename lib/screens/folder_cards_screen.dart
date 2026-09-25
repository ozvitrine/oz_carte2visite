import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/card_folder.dart';
import '../services/pdf_export_service.dart';
import '../state/app_settings_store.dart';
import '../state/card_store.dart';
import '../l10n/app_localizations.dart';
import '../theme/folder_colors.dart';
import 'card_detail_screen.dart';
import 'edit_card_screen.dart';

class FolderCardsScreen extends StatefulWidget {
  const FolderCardsScreen({
    super.key,
    required this.folder,
  });

  final CardFolder folder;

  @override
  State<FolderCardsScreen> createState() => _FolderCardsScreenState();
}

class _FolderCardsScreenState extends State<FolderCardsScreen> {
  String _selectedLetter = 'Toutes';
  bool _isExporting = false;

  final List<String> _letters = const [
    'Toutes',
    'A',
    'B',
    'C',
    'D',
    'E',
    'F',
    'G',
    'H',
    'I',
    'J',
    'K',
    'L',
    'M',
    'N',
    'O',
    'P',
    'Q',
    'R',
    'S',
    'T',
    'U',
    'V',
    'W',
    'X',
    'Y',
    'Z',
  ];

  Future<void> _deleteFolder() async {
    final t = AppLocalizations.of(context)!;

    if (widget.folder.isDefault) {
      _showMessage(t.folderDeleteDefaultBlocked);
      return;
    }

    final store = context.read<CardStore>();
    final cards = store.cardsForFolder(widget.folder.id);

    if (cards.isNotEmpty) {
      _showMessage(t.folderDeleteNotEmpty);
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(t.folderDeleteConfirmTitle),
          content: Text(t.folderDeleteConfirmBody(widget.folder.name)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: Text(t.actionCancel),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: Text(t.actionDelete),
            ),
          ],
        );
      },
    );

    if (confirmed != true || !mounted) return;

    final deleted = await store.deleteFolder(widget.folder.id);

    if (!mounted) return;

    if (deleted) {
      Navigator.pop(context);
    } else {
      _showMessage(AppLocalizations.of(context)!.folderDeleteFailed);
    }
  }

  Future<void> _exportPdf() async {
    if (!context.read<AppSettingsStore>().canUseSettings) {
      _showMessage(AppLocalizations.of(context)!.premiumRequiredMessage);
      return;
    }

    final cards = context.read<CardStore>().cardsForFolder(widget.folder.id);

    if (cards.isEmpty) {
      _showMessage(AppLocalizations.of(context)!.homeAddCardBeforeExport);
      return;
    }

    setState(() => _isExporting = true);

    try {
      await PdfExportService().exportFolder(
        folder: widget.folder,
        cards: cards,
      );

      if (mounted) {
        _showMessage(AppLocalizations.of(context)!.folderPdfReady);
      }
    } catch (_) {
      if (mounted) {
        _showMessage(AppLocalizations.of(context)!.folderPdfError);
      }
    } finally {
      if (mounted) {
        setState(() => _isExporting = false);
      }
    }
  }

  Future<void> _addCard() async {
    final store = context.read<CardStore>();
    final settings = context.read<AppSettingsStore>();

    if (settings.isLimitedToOneCard && store.cards.isNotEmpty) {
      _showMessage(AppLocalizations.of(context)!.editCardPlanLimited);
      return;
    }

    final selectedFolderId = await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (_) => EditCardScreen(
          card: store.createCard(folderId: widget.folder.id),
          isFirstCard: false,
        ),
      ),
    );

    if (!mounted) return;

    if (selectedFolderId == null || selectedFolderId == widget.folder.id) {
      setState(() {});
      return;
    }

    CardFolder? destinationFolder;

    for (final folder in store.folders) {
      if (folder.id == selectedFolderId) {
        destinationFolder = folder;
        break;
      }
    }

    if (destinationFolder == null) {
      _showMessage(AppLocalizations.of(context)!.folderDestinationNotFound);
      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => FolderCardsScreen(
          folder: destinationFolder!,
        ),
      ),
    );
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

    final folderIndex = store.folders.indexWhere(
      (folder) => folder.id == widget.folder.id,
    );
    final folderColor = resolveFolderColor(
      widget.folder.colorValue,
      folderIndex < 0 ? 0 : folderIndex,
    );

    final cards = store.cardsForFolder(widget.folder.id).where((card) {
      if (_selectedLetter == 'Toutes') return true;

      final title = card.title.trim().toUpperCase();

      return title.startsWith(_selectedLetter);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.folder.name),
        actions: [
          IconButton(
            tooltip: t.folderExportTooltip,
            icon: _isExporting
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.picture_as_pdf_outlined),
            onPressed: _isExporting ? null : _exportPdf,
          ),
          // Les trois classeurs par défaut ne peuvent pas être supprimés :
          // le bouton n'apparaît que pour les classeurs créés par
          // l'utilisateur.
          if (!widget.folder.isDefault)
            IconButton(
              tooltip: t.folderDeleteTooltip,
              icon: const Icon(Icons.delete_outline),
              onPressed: _isExporting ? null : _deleteFolder,
            ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(
            height: 58,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 10,
              ),
              scrollDirection: Axis.horizontal,
              itemCount: _letters.length,
              separatorBuilder: (_, __) => const SizedBox(width: 6),
              itemBuilder: (context, index) {
                final letter = _letters[index];

                return ChoiceChip(
                  label: Text(letter == 'Toutes' ? t.folderAllLetter : letter),
                  selected: _selectedLetter == letter,
                  onSelected: _isExporting
                      ? null
                      : (_) {
                          setState(() => _selectedLetter = letter);
                        },
                );
              },
            ),
          ),
          Expanded(
            child: cards.isEmpty
                ? _EmptyFolderState(
                    folderName: widget.folder.name,
                    letter: _selectedLetter,
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: cards.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final card = cards[index];
                      final hasImage = card.frontImagePath != null &&
                          File(card.frontImagePath!).existsSync();
                      final tintedBackground = Color.alphaBlend(
                        folderColor.withValues(alpha: 0.10),
                        Theme.of(context).colorScheme.surface,
                      );

                      return Card(
                        color: tintedBackground,
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(12),
                          leading: SizedBox(
                            width: 80,
                            height: 60,
                            child: hasImage
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.file(
                                      File(card.frontImagePath!),
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : DecoratedBox(
                                    decoration: BoxDecoration(
                                      color: folderColor.withValues(
                                        alpha: 0.22,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Center(
                                      child: Icon(
                                        Icons.contact_page_outlined,
                                        color: folderColor,
                                      ),
                                    ),
                                  ),
                          ),
                          title: Text(
                            card.company.isNotEmpty ? card.company : card.name,
                          ),
                          subtitle: Text(
                            card.company.isNotEmpty ? card.name : card.phone,
                          ),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () async {
                            final destinationFolder =
                                await Navigator.push<CardFolder>(
                              context,
                              MaterialPageRoute(
                                builder: (_) => CardDetailScreen(
                                  card: card,
                                  folder: widget.folder,
                                ),
                              ),
                            );

                            if (!mounted) return;

                            if (destinationFolder != null &&
                                destinationFolder.id != widget.folder.id) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => FolderCardsScreen(
                                    folder: destinationFolder,
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _isExporting ? null : _addCard,
        icon: const Icon(Icons.add_a_photo_outlined),
        label: Text(t.folderAddCardLabel),
      ),
    );
  }
}

class _EmptyFolderState extends StatelessWidget {
  const _EmptyFolderState({
    required this.folderName,
    required this.letter,
  });

  final String folderName;
  final String letter;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final text = letter == 'Toutes'
        ? t.folderEmptyDefault(folderName)
        : t.folderEmptyLetter(letter);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.folder_open_outlined,
              size: 64,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              text,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      ),
    );
  }
}
