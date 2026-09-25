import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/business_card.dart';
import '../models/card_folder.dart';
import '../services/android_contact_service.dart';
import '../services/card_share_service.dart';
import '../l10n/app_localizations.dart';
import '../services/vcard_service.dart';
import '../state/app_settings_store.dart';
import '../state/card_store.dart';
import 'edit_card_screen.dart';
import 'folder_cards_screen.dart';

class CardDetailScreen extends StatefulWidget {
  const CardDetailScreen({
    super.key,
    required this.card,
    required this.folder,
  });

  final BusinessCard card;
  final CardFolder folder;

  @override
  State<CardDetailScreen> createState() => _CardDetailScreenState();
}

class _CardDetailScreenState extends State<CardDetailScreen> {
  bool _isSavingContact = false;
  late BusinessCard _card;

  @override
  void initState() {
    super.initState();
    _card = widget.card;
  }

  BusinessCard get card {
    // context.read, pas watch : ce getter est appelé aussi bien pendant la
    // construction de l'écran que depuis des gestionnaires d'événements
    // (boutons). watch() n'est autorisé que dans le premier cas et fait
    // planter l'application dans le second — ce qui touchait plusieurs
    // boutons de cet écran, pas seulement le QR Code.
    final store = context.read<CardStore>();

    for (final savedCard in store.cards) {
      if (savedCard.id == _card.id) {
        return savedCard;
      }
    }

    return _card;
  }

  CardFolder get folder => widget.folder;

  /// La génération de QR Code n'a de sens que pour vos propres cartes : on
  /// ne propose pas de générer un QR pour la carte d'un client ou d'un
  /// fournisseur simplement numérisée. « personal » est l'identifiant fixe
  /// du classeur « Mes cartes de visite ».
  bool get _canGenerateQrCode => card.folderId == 'personal';

  Future<void> _editCard() async {
    final store = context.read<CardStore>();

    final latestCard =
        store.cards.where((savedCard) => savedCard.id == _card.id).firstOrNull;

    if (latestCard == null) {
      _showMessage(AppLocalizations.of(context)!.cardDetailGone);
      return;
    }

    final selectedFolderId = await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (_) => EditCardScreen(
          card: latestCard,
          isFirstCard: false,
        ),
      ),
    );

    if (!mounted || selectedFolderId == null) return;

    final updatedCard =
        store.cards.where((savedCard) => savedCard.id == _card.id).firstOrNull;

    if (updatedCard == null) {
      _showMessage(AppLocalizations.of(context)!.cardDetailGone);
      return;
    }

    // La carte n'a pas changé de classeur : on met simplement à jour la fiche.
    if (selectedFolderId == folder.id) {
      setState(() => _card = updatedCard);
      return;
    }

    CardFolder? destinationFolder;

    for (final savedFolder in store.folders) {
      if (savedFolder.id == selectedFolderId) {
        destinationFolder = savedFolder;
        break;
      }
    }

    if (destinationFolder == null) {
      _showMessage(AppLocalizations.of(context)!.folderDestinationNotFound);
      return;
    }

    // Ferme la fiche de l'ancien classeur, puis remplace l'écran de classeur
    // précédent par le classeur réellement choisi.
    Navigator.pop(context, destinationFolder);
  }

  Future<void> _openUrl(String value) async {
    final normalizedValue = value.startsWith('http') ? value : 'https://$value';

    final url = Uri.tryParse(normalizedValue);

    if (url == null ||
        !await launchUrl(
          url,
          mode: LaunchMode.externalApplication,
        )) {
      if (mounted) {
        _showMessage(AppLocalizations.of(context)!.cardLinkOpenError);
      }
    }
  }

  Future<void> _call() async {
    final phone = _cleanPhone(card.phone);

    if (phone.isEmpty) return;

    final uri = Uri(scheme: 'tel', path: phone);

    if (!await launchUrl(uri) && mounted) {
      _showMessage(AppLocalizations.of(context)!.cardPhoneAppError);
    }
  }

  Future<void> _sendEmail() async {
    if (card.email.isEmpty) return;

    final uri = Uri(
      scheme: 'mailto',
      path: card.email,
      queryParameters: {
        'subject': AppLocalizations.of(context)!.cardEmailSubject(card.name),
      },
    );

    if (!await launchUrl(uri) && mounted) {
      _showMessage(AppLocalizations.of(context)!.cardEmailAppError);
    }
  }

  Future<void> _sendSmsToContact() async {
    final phone = _cleanPhone(card.phone);

    if (phone.isEmpty) return;

    final uri = Uri(scheme: 'sms', path: phone);

    if (!await launchUrl(uri) && mounted) {
      _showMessage(AppLocalizations.of(context)!.cardSmsAppError);
    }
  }

  Future<void> _openWhatsApp() async {
    final phone = _cleanPhone(card.phone);

    if (phone.isEmpty) return;

    // wa.me attend un numéro international sans le signe +.
    final whatsappNumber = phone.startsWith('+') ? phone.substring(1) : phone;
    final uri = Uri.parse('https://wa.me/$whatsappNumber');

    if (!await launchUrl(uri, mode: LaunchMode.externalApplication) &&
        mounted) {
      _showMessage(AppLocalizations.of(context)!.cardWhatsAppError);
    }
  }

  Future<void> _sendCardBySms() async {
    if (!_requirePremium()) return;

    final uri = Uri(
      scheme: 'sms',
      queryParameters: {
        'body': _cardAsText(AppLocalizations.of(context)!),
      },
    );

    if (!await launchUrl(uri) && mounted) {
      _showMessage(AppLocalizations.of(context)!.cardSmsAppError);
    }
  }

  Future<void> _sendCardByEmail() async {
    if (!_requirePremium()) return;

    final subjectTitle = card.company.isNotEmpty ? card.company : card.name;

    final uri = Uri(
      scheme: 'mailto',
      queryParameters: {
        'subject': subjectTitle,
        'body': _cardAsText(AppLocalizations.of(context)!),
      },
    );

    if (!await launchUrl(uri) && mounted) {
      _showMessage(AppLocalizations.of(context)!.cardEmailAppError);
    }
  }

  /// Réservé à Premium : partager, exporter ou ajouter une carte aux
  /// contacts sort les données de l'appareil, contrairement à la simple
  /// consultation ou modification d'une carte, qui reste disponible pour
  /// toutes les formules.
  bool _requirePremium() {
    if (context.read<AppSettingsStore>().canUseSettings) return true;

    _showMessage(AppLocalizations.of(context)!.premiumRequiredMessage);
    return false;
  }

  Future<void> _shareCard() async {
    if (!_requirePremium()) return;

    try {
      await CardShareService().shareCard(card);

      if (mounted) {
        _showMessage(AppLocalizations.of(context)!.cardShareOzcardReady);
      }
    } catch (_) {
      if (mounted) {
        _showMessage(AppLocalizations.of(context)!.cardShareOzcardError);
      }
    }
  }

  Future<void> _saveToAndroidContacts() async {
    if (!_requirePremium()) return;

    setState(() => _isSavingContact = true);

    try {
      await AndroidContactService().saveCardAsContact(card);

      if (mounted) {
        _showMessage(AppLocalizations.of(context)!.cardContactSaved);
      }
    } on ContactPermissionException {
      if (mounted) {
        _showMessage(AppLocalizations.of(context)!.cardContactPermissionNeeded);
      }
    } catch (_) {
      if (mounted) {
        _showMessage(AppLocalizations.of(context)!.cardContactSaveError);
      }
    } finally {
      if (mounted) {
        setState(() => _isSavingContact = false);
      }
    }
  }

  Future<void> _deleteCard() async {
    final t = AppLocalizations.of(context)!;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(t.cardDeleteConfirmTitle),
          content: Text(t.cardDeleteConfirmBody),
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

    await context.read<CardStore>().deleteCard(card.id);

    if (mounted) {
      Navigator.pop(context);
    }
  }

  Future<void> _showFullImage(
    String imagePath,
    String title,
  ) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FullScreenImageScreen(
          imagePath: imagePath,
          title: title,
        ),
      ),
    );
  }

  /// Ouvre le QR Code de la carte dans une boîte de dialogue. Réservé aux
  /// cartes du classeur « Mes cartes de visite » (voir [_canGenerateQrCode]).
  Future<void> _generateQrCode() async {
    if (!_canGenerateQrCode) return;

    final t = AppLocalizations.of(context)!;
    final vCardText = VCardService().build(card);
    final title = card.company.isNotEmpty ? card.company : card.name;

    if (!mounted) return;

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(t.cardQrDialogTitle),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: QrImageView(
                  data: vCardText,
                  version: QrVersions.auto,
                  size: 220,
                  backgroundColor: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                title.isEmpty
                    ? t.cardQrScanHintNoTitle
                    : t.cardQrScanHintWithTitle(title),
                textAlign: TextAlign.center,
                style: Theme.of(dialogContext).textTheme.bodySmall,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(t.actionClose),
            ),
          ],
        );
      },
    );
  }

  String _cleanPhone(String phone) {
    return phone.replaceAll(RegExp(r'[^0-9+]'), '');
  }

  String _cardAsText(AppLocalizations t) {
    final lines = <String>[
      t.cardAsTextHeader,
    ];

    if (card.company.isNotEmpty) {
      lines.add(t.cardAsTextCompany(card.company));
    }

    if (card.name.isNotEmpty) {
      lines.add(t.cardAsTextName(card.name));
    }

    if (card.phone.isNotEmpty) {
      lines.add(t.cardAsTextPhone(card.phone));
    }

    if (card.email.isNotEmpty) {
      lines.add(t.cardAsTextEmail(card.email));
    }

    if (card.notes.isNotEmpty) {
      lines.add(t.cardAsTextNotes(card.notes));
    }

    return lines.join('\n');
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
    final currentCard = card;
    final title =
        currentCard.company.isNotEmpty ? currentCard.company : currentCard.name;

    return Scaffold(
      appBar: AppBar(
        title: Text(title.isEmpty ? t.cardDefaultTitle : title),
        actions: [
          IconButton(
            tooltip: t.cardEditTooltip,
            icon: const Icon(Icons.edit_outlined),
            onPressed: _editCard,
          ),
          IconButton(
            tooltip: t.cardDeleteTooltip,
            icon: const Icon(Icons.delete_outline),
            onPressed: _deleteCard,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (currentCard.frontImagePath != null &&
              File(currentCard.frontImagePath!).existsSync())
            _imageCard(
              label: t.cardFrontLabel,
              imagePath: currentCard.frontImagePath!,
            ),
          if (currentCard.backImagePath != null &&
              File(currentCard.backImagePath!).existsSync()) ...[
            const SizedBox(height: 12),
            _imageCard(
              label: t.cardBackLabel,
              imagePath: currentCard.backImagePath!,
            ),
          ],
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _detailLine(t.fieldCompany, currentCard.company),
                  _detailLine(t.fieldName, currentCard.name),
                  _detailLine(t.fieldPhone, currentCard.phone),
                  _detailLine(t.cardDetailEmailLabel, currentCard.email),
                  _detailLine(t.fieldFolder, folder.name),
                ],
              ),
            ),
          ),
          if (currentCard.notes.isNotEmpty) ...[
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: _NotesWithLinks(
                  text: currentCard.notes,
                  onOpenLink: _openUrl,
                ),
              ),
            ),
          ],
          const SizedBox(height: 16),
          Text(
            t.cardSectionContact,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.tertiaryContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                FilledButton.tonalIcon(
                  onPressed: currentCard.phone.isEmpty ? null : _call,
                  icon: const Icon(Icons.phone_outlined),
                  label: Text(t.actionCall),
                ),
                FilledButton.tonalIcon(
                  onPressed:
                      currentCard.phone.isEmpty ? null : _sendSmsToContact,
                  icon: const Icon(Icons.sms_outlined),
                  label: Text(t.actionSmsContact),
                ),
                FilledButton.tonalIcon(
                  onPressed: currentCard.email.isEmpty ? null : _sendEmail,
                  icon: const Icon(Icons.email_outlined),
                  label: Text(t.cardDetailEmailLabel),
                ),
                FilledButton.tonalIcon(
                  onPressed: currentCard.phone.isEmpty ? null : _openWhatsApp,
                  icon: const Icon(Icons.chat_outlined),
                  label: Text(t.actionWhatsApp),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            t.cardSectionTransfer,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              FilledButton.tonalIcon(
                onPressed: _sendCardBySms,
                icon: const Icon(Icons.send_to_mobile_outlined),
                label: Text(t.actionSendCardSms),
              ),
              FilledButton.tonalIcon(
                onPressed: _sendCardByEmail,
                icon: const Icon(Icons.forward_to_inbox_outlined),
                label: Text(t.actionSendCardEmail),
              ),
              FilledButton.tonalIcon(
                onPressed: _shareCard,
                icon: const Icon(Icons.share_outlined),
                label: Text(t.actionShareOzcard),
              ),
              if (_canGenerateQrCode)
                FilledButton.tonalIcon(
                  onPressed: _generateQrCode,
                  icon: const Icon(Icons.qr_code_2_outlined),
                  label: Text(t.actionGenerateQr),
                ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            t.cardSectionOther,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              FilledButton.tonalIcon(
                onPressed: _isSavingContact ? null : _saveToAndroidContacts,
                icon: _isSavingContact
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.person_add_alt_1_outlined),
                label: Text(t.actionAddToContacts),
              ),
            ],
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _imageCard({
    required String label,
    required String imagePath,
  }) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => _showFullImage(imagePath, label),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ConstrainedBox(
              constraints: const BoxConstraints(
                maxHeight: 220,
                minHeight: 120,
              ),
              child: SizedBox(
                width: double.infinity,
                child: Image.file(
                  File(imagePath),
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 10,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.fullscreen_outlined),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      AppLocalizations.of(context)!.cardImageTapHint(label),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _detailLine(String label, String value) {
    if (value.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 2),
          Text(value),
        ],
      ),
    );
  }
}

class FullScreenImageScreen extends StatefulWidget {
  const FullScreenImageScreen({
    super.key,
    required this.imagePath,
    required this.title,
  });

  final String imagePath;
  final String title;

  @override
  State<FullScreenImageScreen> createState() => _FullScreenImageScreenState();
}

class _FullScreenImageScreenState extends State<FullScreenImageScreen> {
  @override
  void initState() {
    super.initState();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.immersiveSticky,
    );
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.edgeToEdge,
    );

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: Center(
                child: InteractiveViewer(
                  minScale: 0.5,
                  maxScale: 5,
                  child: Image.file(
                    File(widget.imagePath),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            Positioned(
              top: 12,
              right: 12,
              child: IconButton.filled(
                tooltip: AppLocalizations.of(context)!.imageCloseTooltip,
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close),
              ),
            ),
            Positioned(
              left: 20,
              bottom: 16,
              child: Text(
                widget.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NotesWithLinks extends StatelessWidget {
  const _NotesWithLinks({
    required this.text,
    required this.onOpenLink,
  });

  final String text;
  final ValueChanged<String> onOpenLink;

  @override
  Widget build(BuildContext context) {
    final urlPattern = RegExp(
      r'(https?:\/\/[^\s]+|www\.[^\s]+)',
      caseSensitive: false,
    );

    final matches = urlPattern.allMatches(text).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.sectionNotes,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(text),
        if (matches.isNotEmpty) ...[
          const SizedBox(height: 8),
          ...matches.map(
            (match) {
              final url = match.group(0);

              if (url == null) return const SizedBox.shrink();

              return TextButton.icon(
                onPressed: () => onOpenLink(url),
                icon: const Icon(Icons.open_in_new),
                label: Text(url),
              );
            },
          ),
        ],
      ],
    );
  }
}

extension FirstOrNull<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
