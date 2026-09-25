import 'dart:io';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../models/business_card.dart';
import '../models/card_folder.dart';
import '../services/card_field_extractor.dart';
import '../services/image_optimization_service.dart';
import '../state/card_store.dart';
import '../widgets/inactivity_guard.dart';
import '../l10n/app_localizations.dart';
import '../state/app_settings_store.dart';
import '../services/ad_service.dart';

class EditCardScreen extends StatefulWidget {
  const EditCardScreen({
    super.key,
    required this.card,
    required this.isFirstCard,
  });

  final BusinessCard card;
  final bool isFirstCard;

  @override
  State<EditCardScreen> createState() => _EditCardScreenState();
}

class _EditCardScreenState extends State<EditCardScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _companyController;
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _emailController;
  late final TextEditingController _notesController;

  late String _selectedFolderId;
  String? _frontImagePath;
  String? _backImagePath;
  bool _isAnalysing = false;

  ExtractedCardFields? _ocrFields;
  ExtractedCardFields? _qrFields;

  @override
  void initState() {
    super.initState();
    AdService.instance.setAdsSuspended(true);

    _companyController = TextEditingController(text: widget.card.company);
    _nameController = TextEditingController(text: widget.card.name);
    _phoneController = TextEditingController(text: widget.card.phone);
    _emailController = TextEditingController(text: widget.card.email);
    _notesController = TextEditingController(text: widget.card.notes);

    _selectedFolderId = widget.card.folderId;
    _frontImagePath = widget.card.frontImagePath;
    _backImagePath = widget.card.backImagePath;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        InactivityGuard.of(context)?.setEditingCard(true);
      }
    });
  }

  @override
  void dispose() {
    InactivityGuard.of(context)?.setEditingCard(false);

    _companyController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _notesController.dispose();

    AdService.instance.setAdsSuspended(false);
    super.dispose();
  }

  Future<void> _chooseImage({required bool front}) async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt_outlined),
                title: Text(AppLocalizations.of(context)!.onboardingTakePhoto),
                onTap: () => Navigator.pop(context, ImageSource.camera),
              ),
              ListTile(
                leading: const Icon(Icons.photo_library_outlined),
                title:
                    Text(AppLocalizations.of(context)!.onboardingChooseImage),
                onTap: () => Navigator.pop(context, ImageSource.gallery),
              ),
            ],
          ),
        );
      },
    );

    if (source == null) return;

    final image = await ImagePicker().pickImage(
      source: source,
      imageQuality: 90,
    );

    if (image == null) return;

    setState(() => _isAnalysing = true);

    try {
      final optimizedPath = await ImageOptimizationService().optimizeImage(
        image.path,
        imageType: front ? 'recto' : 'verso',
      );

      if (!mounted) return;

      setState(() {
        if (front) {
          _frontImagePath = optimizedPath;
        } else {
          _backImagePath = optimizedPath;
        }
      });

      await _analyseImage(
        optimizedPath,
        extractText: front,
      );
    } on FileSystemException catch (error) {
      _showMessage(error.message);
    } catch (_) {
      _showMessage(AppLocalizations.of(context)!.onboardingImageError);
    } finally {
      if (mounted) {
        setState(() => _isAnalysing = false);
      }
    }
  }

  Future<void> _analyseImage(
    String imagePath, {
    required bool extractText,
  }) async {
    if (extractText) {
      await _extractText(imagePath);
    }

    await _readQrCodeFromImage(imagePath);
  }

  Future<void> _extractText(String imagePath) async {
    final recognizer = TextRecognizer(
      script: TextRecognitionScript.latin,
    );

    try {
      final result = await recognizer.processImage(
        InputImage.fromFilePath(imagePath),
      );

      final lines = <OcrLine>[
        for (final block in result.blocks)
          for (final line in block.lines)
            OcrLine(line.text, line.boundingBox.height.toDouble()),
      ];

      _ocrFields = CardFieldExtractor().fromOcrLines(lines);
      _applyExtractedFields();

      if (mounted) {
        _showMessage(AppLocalizations.of(context)!.editCardOcrDetected);
      }
    } catch (_) {
      if (mounted) {
        _showMessage(AppLocalizations.of(context)!.onboardingOcrFailed);
      }
    } finally {
      await recognizer.close();
    }
  }

  Future<void> _readQrCodeFromImage(String imagePath) async {
    final scanner = BarcodeScanner(
      formats: [BarcodeFormat.qrCode],
    );

    try {
      final barcodes = await scanner.processImage(
        InputImage.fromFilePath(imagePath),
      );

      for (final barcode in barcodes) {
        final value = barcode.rawValue?.trim();

        if (value == null || value.isEmpty) continue;

        final fields = CardFieldExtractor().fromQrText(value);
        _qrFields = fields;
        _applyExtractedFields();

        if (fields.isEmpty) {
          _addQrCodeToNotes(value);
        }

        if (mounted) {
          _showMessage(AppLocalizations.of(context)!.editCardQrDetected);
        }
        break;
      }
    } catch (_) {
      // L'absence de QR Code ne doit pas provoquer un message d'erreur.
    } finally {
      await scanner.close();
    }
  }

  void _addQrCodeToNotes(String value) {
    final entry = 'Qrcode = $value';
    final notes = _notesController.text.trim();

    if (notes.contains(entry)) return;

    setState(() {
      _notesController.text = notes.isEmpty ? entry : '$notes\n\n$entry';
    });
  }

  String _formatPhoneNumber(String value) {
    final digits = value.replaceAll(RegExp(r'\D'), '');

    if (digits.length == 10 && digits.startsWith('0')) {
      return RegExp(r'.{1,2}')
          .allMatches(digits)
          .map((match) => match.group(0)!)
          .join('.');
    }

    if (digits.length == 11 && digits.startsWith('33')) {
      final localNumber = '0${digits.substring(2)}';

      return RegExp(r'.{1,2}')
          .allMatches(localNumber)
          .map((match) => match.group(0)!)
          .join('.');
    }

    return value.trim();
  }

  /// Applique la fusion des champs déjà extraits par OCR et par QR Code
  /// aux champs du formulaire — uniquement ceux encore vides, pour ne
  /// jamais écraser une correction déjà faite par l'utilisateur.
  void _applyExtractedFields() {
    const empty = ExtractedCardFields();
    final merged = CardFieldExtractor().merge(
      _ocrFields ?? empty,
      _qrFields ?? empty,
    );

    setState(() {
      if (_companyController.text.isEmpty && merged.company != null) {
        _companyController.text = merged.company!;
      }

      if (_nameController.text.isEmpty && merged.name != null) {
        _nameController.text = merged.name!;
      }

      if (_emailController.text.isEmpty && merged.email != null) {
        _emailController.text = merged.email!;
      }

      if (_phoneController.text.isEmpty && merged.phone != null) {
        _phoneController.text = _formatPhoneNumber(merged.phone!);
      }
    });
  }

  Future<void> _searchQrCodesAgain() async {
    if (_frontImagePath == null && _backImagePath == null) {
      _showMessage(AppLocalizations.of(context)!.editCardMissingImage);
      return;
    }

    setState(() => _isAnalysing = true);

    try {
      if (_frontImagePath != null) {
        await _readQrCodeFromImage(_frontImagePath!);
      }

      if (_backImagePath != null) {
        await _readQrCodeFromImage(_backImagePath!);
      }
    } finally {
      if (mounted) {
        setState(() => _isAnalysing = false);
      }
    }
  }

  Future<void> _saveCard() async {
    if (!_formKey.currentState!.validate()) return;

    if (_companyController.text.trim().isEmpty &&
        _nameController.text.trim().isEmpty) {
      _showMessage(AppLocalizations.of(context)!.editCardMissingNameOrCompany);
      return;
    }

    final store = context.read<CardStore>();
    final settings = context.read<AppSettingsStore>();

    final isNewCard = !store.cards.any(
      (savedCard) => savedCard.id == widget.card.id,
    );

    if (isNewCard && settings.isLimitedToOneCard && store.cards.isNotEmpty) {
      _showMessage(AppLocalizations.of(context)!.editCardPlanLimited);
      return;
    }

    final card = BusinessCard(
      id: widget.card.id,
      company: _companyController.text.trim(),
      name: _nameController.text.trim(),
      phone: _formatPhoneNumber(_phoneController.text),
      email: _emailController.text.trim(),
      notes: _notesController.text.trim(),
      folderId: _selectedFolderId,
      frontImagePath: _frontImagePath,
      backImagePath: _backImagePath,
      createdAt: widget.card.createdAt,
      updatedAt: DateTime.now(),
    );

    await store.saveCard(card);

    if (mounted) {
      Navigator.pop(context, _selectedFolderId);
    }
  }

  void _showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final folders = context.watch<CardStore>().folders;

    final currentFolder = folders.firstWhereOrNull(
      (folder) => folder.id == widget.card.folderId,
    );
    final companyLabel =
        switch (currentFolder?.kind ?? FolderKind.businessCard) {
      FolderKind.businessCard => t.fieldCompany,
      FolderKind.discount => t.fieldMerchant,
      FolderKind.subscription => t.fieldClub,
    };

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.card.company.isEmpty && widget.card.name.isEmpty
              ? t.editCardAddTitle
              : t.editCardEditTitle,
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              t.editCardImagesSection,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            _imageSection(
              label: t.editCardFront,
              path: _frontImagePath,
              onTap: () => _chooseImage(front: true),
            ),
            const SizedBox(height: 12),
            _imageSection(
              label: t.editCardBack,
              path: _backImagePath,
              onTap: () => _chooseImage(front: false),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: _isAnalysing ? null : _searchQrCodesAgain,
              icon: const Icon(Icons.qr_code_scanner),
              label: Text(t.editCardSearchQr),
            ),
            if (_isAnalysing) ...[
              const SizedBox(height: 20),
              const Center(child: CircularProgressIndicator()),
              const SizedBox(height: 8),
              Center(
                child: Text(t.editCardAnalyzing),
              ),
            ],
            const SizedBox(height: 24),
            Text(
              t.editCardInfoSection,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _companyController,
              decoration: InputDecoration(
                labelText: companyLabel,
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: t.fieldName,
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: t.fieldPhone,
                hintText: '06.80.80.80.00',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: t.fieldEmail,
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                final email = value?.trim() ?? '';

                if (email.isEmpty) return null;

                final isValid = RegExp(
                  r'^[\w.+-]+@[\w-]+\.[\w.-]+$',
                ).hasMatch(email);

                return isValid ? null : t.editCardInvalidEmail;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _notesController,
              minLines: 4,
              maxLines: 10,
              decoration: InputDecoration(
                labelText: t.fieldNotes,
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _selectedFolderId,
              decoration: InputDecoration(
                labelText: t.fieldFolder,
                border: OutlineInputBorder(),
              ),
              items: folders
                  .map(
                    (CardFolder folder) => DropdownMenuItem<String>(
                      value: folder.id,
                      child: Text(folder.name),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => _selectedFolderId = value);
                }
              },
            ),
            const SizedBox(height: 28),
            FilledButton.icon(
              onPressed: _isAnalysing ? null : _saveCard,
              icon: const Icon(Icons.save_outlined),
              label: Text(t.editCardSave),
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(52),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _imageSection({
    required String label,
    required String? path,
    required VoidCallback onTap,
  }) {
    final t = AppLocalizations.of(context)!;
    final hasImage = path != null && File(path).existsSync();

    return InkWell(
      onTap: _isAnalysing ? null : onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 160,
        decoration: BoxDecoration(
          border: Border.all(
            color: Theme.of(context).colorScheme.outline,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: hasImage
            ? Stack(
                fit: StackFit.expand,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(
                      File(path),
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    left: 10,
                    top: 10,
                    child: Chip(label: Text(label)),
                  ),
                ],
              )
            : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.add_a_photo_outlined, size: 36),
                    const SizedBox(height: 8),
                    Text(t.editCardAddImage(label)),
                  ],
                ),
              ),
      ),
    );
  }
}
