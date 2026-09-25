import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../l10n/app_localizations.dart';
import '../services/ad_service.dart';
import '../services/card_field_extractor.dart';
import '../services/image_optimization_service.dart';
import '../state/app_settings_store.dart';
import '../state/card_store.dart';

enum _ConsentChoice { reviewConsent, useFreePlan }

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int _step = 0;
  AppLicensePlan _plan = AppLicensePlan.noAdsLimited;

  final _companyController = TextEditingController();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _notesController = TextEditingController();

  String? _frontImagePath;
  String? _backImagePath;
  bool _isReading = false;

  ExtractedCardFields? _ocrFields;
  ExtractedCardFields? _qrFields;

  @override
  void dispose() {
    _companyController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _chooseImage({required bool front}) async {
    final t = AppLocalizations.of(context)!;
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt_outlined),
                title: Text(t.onboardingTakePhoto),
                onTap: () => Navigator.pop(context, ImageSource.camera),
              ),
              ListTile(
                leading: const Icon(Icons.photo_library_outlined),
                title: Text(t.onboardingChooseImage),
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

    setState(() => _isReading = true);

    try {
      final optimizedPath = await ImageOptimizationService().optimizeImage(
        image.path,
        imageType: front ? 'premiere_carte_recto' : 'premiere_carte_verso',
      );

      if (!mounted) return;

      setState(() {
        if (front) {
          _frontImagePath = optimizedPath;
        } else {
          _backImagePath = optimizedPath;
        }
      });

      if (front) {
        await _extractText(optimizedPath);
      }

      await _readQrCodeFromImage(optimizedPath);
    } on FileSystemException catch (error) {
      _showMessage(error.message);
    } catch (_) {
      _showMessage(t.onboardingImageError);
    } finally {
      if (mounted) {
        setState(() => _isReading = false);
      }
    }
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
        _showMessage(AppLocalizations.of(context)!.onboardingOcrDetected);
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
        final qrText = barcode.rawValue?.trim();

        if (qrText == null || qrText.isEmpty) continue;

        final fields = CardFieldExtractor().fromQrText(qrText);
        _qrFields = fields;
        _applyExtractedFields();

        if (fields.isEmpty) {
          // Rien d'exploitable détecté (pas un vCard, pas de motif
          // reconnu) : on garde au moins le contenu brut, dans les notes.
          _addQrCodeToNotes(qrText);
        }

        if (mounted) {
          _showMessage(AppLocalizations.of(context)!.onboardingQrDetected);
        }
        break;
      }
    } catch (_) {
      // L'absence de QR Code n'est pas une erreur.
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

  Future<void> _next() async {
    if (_step == 1 &&
        _plan == AppLicensePlan.adsUnlimited &&
        !AdService.instance.canRequestAds) {
      await _resolveConsentMismatch();
      return;
    }

    if (_step < 2) {
      setState(() => _step += 1);
      return;
    }

    if (_frontImagePath == null) {
      _showMessage(AppLocalizations.of(context)!.onboardingMissingFrontPhoto);
      return;
    }

    if (_companyController.text.trim().isEmpty &&
        _nameController.text.trim().isEmpty) {
      _showMessage(
          AppLocalizations.of(context)!.onboardingMissingNameOrCompany);
      return;
    }

    final store = context.read<CardStore>();
    final settings = context.read<AppSettingsStore>();

    final card = store.createCard().copyWith(
          company: _companyController.text.trim(),
          name: _nameController.text.trim(),
          phone: _formatPhoneNumber(_phoneController.text),
          email: _emailController.text.trim(),
          notes: _notesController.text.trim(),
          frontImagePath: _frontImagePath,
          backImagePath: _backImagePath,
          updatedAt: DateTime.now(),
        );

    // Le choix est sauvegardé avant le premier enregistrement de carte.
    await settings.setLicensePlan(_plan);
    await store.finishOnboarding(card);
  }

  /// Propose deux issues plutôt que de fermer l'application : revoir le
  /// consentement publicitaire sur place, ou basculer sur la formule sans
  /// publicité pour continuer immédiatement.
  Future<void> _resolveConsentMismatch() async {
    final t = AppLocalizations.of(context)!;

    final choice = await showDialog<_ConsentChoice>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          icon: const Icon(Icons.error_outline),
          title: Text(t.consentRequiredTitle),
          content: Text(t.consentRequiredBody),
          actions: [
            OutlinedButton(
              onPressed: () => Navigator.pop(
                dialogContext,
                _ConsentChoice.reviewConsent,
              ),
              child: Text(t.actionReviewConsent),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(
                dialogContext,
                _ConsentChoice.useFreePlan,
              ),
              child: Text(t.actionSwitchToFreePlan),
            ),
          ],
        );
      },
    );

    if (!mounted || choice == null) return;

    if (choice == _ConsentChoice.useFreePlan) {
      setState(() {
        _plan = AppLicensePlan.noAdsLimited;
        _step += 1;
      });
      return;
    }

    // reviewConsent : rouvre le formulaire de confidentialité de Google.
    // L'utilisateur retente ensuite lui-même « Valider la formule ».
    await AdService.instance.showPrivacyOptionsForm();
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
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.appTitle)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: switch (_step) {
            0 => _legalStep(),
            1 => _licenseStep(),
            _ => _firstCardPhotoStep(),
          },
        ),
      ),
    );
  }

  Widget _legalStep() {
    final t = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Spacer(),
        Icon(
          Icons.contact_page_outlined,
          size: 64,
          color: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(height: 24),
        Text(
          t.onboardingLegalTitle,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 16),
        Text(t.onboardingLegalBody),
        const Spacer(),
        FilledButton(
          onPressed: _next,
          style: FilledButton.styleFrom(
            minimumSize: const Size.fromHeight(52),
          ),
          child: Text(t.onboardingLegalAccept),
        ),
      ],
    );
  }

  Widget _licenseStep() {
    final t = AppLocalizations.of(context)!;

    final plans = [
      (
        plan: AppLicensePlan.noAdsLimited,
        title: t.onboardingPlanFreeTitle,
        detail: t.onboardingPlanFreeDetail,
      ),
      (
        plan: AppLicensePlan.adsUnlimited,
        title: t.onboardingPlanAdsTitle,
        detail: t.onboardingPlanAdsDetail,
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          t.onboardingPlanTitle,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 8),
        Text(t.onboardingPlanSubtitle),
        const SizedBox(height: 20),
        ...plans.map(
          (item) => Card(
            child: RadioListTile<AppLicensePlan>(
              value: item.plan,
              groupValue: _plan,
              title: Text(item.title),
              subtitle: Text(item.detail),
              onChanged: (value) {
                if (value != null) {
                  setState(() => _plan = value);
                }
              },
            ),
          ),
        ),
        const SizedBox(height: 12),
        Card(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          child: ListTile(
            leading: const Icon(Icons.workspace_premium_outlined),
            title: Text(t.onboardingPremiumTitle),
            subtitle: Text(t.onboardingPremiumDetail),
          ),
        ),
        const Spacer(),
        FilledButton(
          onPressed: _next,
          style: FilledButton.styleFrom(
            minimumSize: const Size.fromHeight(52),
          ),
          child: Text(t.onboardingPlanValidate),
        ),
      ],
    );
  }

  Widget _firstCardPhotoStep() {
    final t = AppLocalizations.of(context)!;

    return ListView(
      children: [
        Text(
          t.onboardingPhotoStepTitle,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 8),
        Text(t.onboardingPhotoStepSubtitle),
        const SizedBox(height: 20),
        _imageButton(
          label: t.onboardingFrontPhotoLabel,
          path: _frontImagePath,
          required: true,
          onTap: () => _chooseImage(front: true),
        ),
        const SizedBox(height: 12),
        _imageButton(
          label: t.onboardingBackPhotoLabel,
          path: _backImagePath,
          required: false,
          onTap: () => _chooseImage(front: false),
        ),
        if (_isReading) ...[
          const SizedBox(height: 20),
          const Center(child: CircularProgressIndicator()),
          const SizedBox(height: 8),
          Center(
            child: Text(t.onboardingAnalyzing),
          ),
        ],
        const SizedBox(height: 24),
        Text(
          t.onboardingDetectedInfoTitle,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _companyController,
          decoration: InputDecoration(
            labelText: t.fieldCompany,
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _nameController,
          decoration: InputDecoration(
            labelText: t.fieldName,
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _phoneController,
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
            labelText: t.fieldPhone,
            hintText: '06.80.80.80.00',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            labelText: t.fieldEmail,
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _notesController,
          minLines: 3,
          maxLines: 8,
          decoration: InputDecoration(
            labelText: t.fieldNotes,
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 24),
        FilledButton(
          onPressed: _isReading ? null : _next,
          style: FilledButton.styleFrom(
            minimumSize: const Size.fromHeight(52),
          ),
          child: Text(t.onboardingValidateCard),
        ),
      ],
    );
  }

  Widget _imageButton({
    required String label,
    required String? path,
    required bool required,
    required VoidCallback onTap,
  }) {
    final hasImage = path != null && File(path).existsSync();

    return InkWell(
      onTap: _isReading ? null : onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 150,
        decoration: BoxDecoration(
          border: Border.all(
            color: Theme.of(context).colorScheme.outline,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: hasImage
            ? ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(
                  File(path),
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              )
            : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.add_a_photo_outlined, size: 34),
                    const SizedBox(height: 8),
                    Text(required ? '$label *' : label),
                  ],
                ),
              ),
      ),
    );
  }
}
