import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../l10n/app_localizations.dart';
import '../services/personal_license_service.dart';
import '../state/app_settings_store.dart';

/// Construit le libellé affiché pour une licence active. Sorti du modèle
/// [PersonalLicense] lui-même, qui n'a pas accès à AppLocalizations — c'est
/// ici, dans l'écran, que la traduction se fait.
String licenseLabel(AppLocalizations t, PersonalLicense license) {
  if (license.isLifetime) {
    return t.licenseLifetime;
  }

  if (license.expiresAt == null) {
    return t.licenseAnnual;
  }

  final date = license.expiresAt!;
  final day = date.day.toString().padLeft(2, '0');
  final month = date.month.toString().padLeft(2, '0');

  return t.licenseUntil('$day/$month/${date.year}');
}

class PersonalLicenseScreen extends StatefulWidget {
  const PersonalLicenseScreen({super.key});

  @override
  State<PersonalLicenseScreen> createState() => _PersonalLicenseScreenState();
}

class _PersonalLicenseScreenState extends State<PersonalLicenseScreen> {
  final _licenseService = PersonalLicenseService();

  String? _installationId;
  bool _isLoadingId = true;
  bool _isImporting = false;

  @override
  void initState() {
    super.initState();
    _loadInstallationId();
  }

  Future<void> _loadInstallationId() async {
    final id = await _licenseService.getInstallationId();

    if (!mounted) return;

    setState(() {
      _installationId = id;
      _isLoadingId = false;
    });
  }

  Future<void> _importLicense() async {
    setState(() => _isImporting = true);

    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.any,
        allowMultiple: false,
      );

      if (result == null) return;

      final path = result.files.single.path;

      if (path == null || path.isEmpty) {
        _showMessage(AppLocalizations.of(context)!.settingsFilePickError);
        return;
      }

      final content = await File(path).readAsString();
      final license = await _licenseService.validateLicenseText(content);

      if (!mounted) return;

      await context.read<AppSettingsStore>().activatePersonalLicense(
            license,
          );

      // Le fichier n'a plus d'utilité une fois la licence enregistrée sur
      // l'appareil : on l'efface. Erreur silencieuse si la suppression
      // échoue (permissions, fichier déjà déplacé) — ça n'annule pas
      // l'activation, qui a déjà réussi.
      try {
        await File(path).delete();
      } catch (_) {
        // Non bloquant : la licence reste active même si le fichier
        // source n'a pas pu être supprimé.
      }

      if (!mounted) return;

      _showMessage(
        AppLocalizations.of(context)!.licenseActivated(
          licenseLabel(AppLocalizations.of(context)!, license),
        ),
      );
    } on FormatException catch (error) {
      _showMessage(error.message);
    } on FileSystemException catch (error) {
      _showMessage(error.message);
    } catch (_) {
      _showMessage(AppLocalizations.of(context)!.licenseImportError);
    } finally {
      if (mounted) {
        setState(() => _isImporting = false);
      }
    }
  }

  Future<void> _confirmRemoveLicense() async {
    final settings = context.read<AppSettingsStore>();

    if (!settings.personalLicenseIsActive) {
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          icon: const Icon(Icons.warning_amber_outlined),
          title: Text(AppLocalizations.of(dialogContext)!.licenseRemoveTitle),
          content: Text(AppLocalizations.of(dialogContext)!.licenseRemoveBody),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: Text(AppLocalizations.of(dialogContext)!.actionCancel),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: Text(AppLocalizations.of(dialogContext)!.actionRemove),
            ),
          ],
        );
      },
    );

    if (confirmed != true || !mounted) return;

    await settings.clearPersonalLicense();

    if (mounted) {
      _showMessage(AppLocalizations.of(context)!.licenseRemoved);
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
    final settings = context.watch<AppSettingsStore>();
    final license = settings.personalLicense;

    return Scaffold(
      appBar: AppBar(
        title: Text(t.licenseTitle),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    t.licenseDeviceIdTitle,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(t.licenseDeviceIdBody),
                  const SizedBox(height: 14),
                  SelectableText(
                    _isLoadingId
                        ? t.licenseLoading
                        : (_installationId ?? t.licenseUnavailable),
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: ListTile(
              leading: Icon(
                settings.personalLicenseIsActive
                    ? Icons.verified_outlined
                    : Icons.workspace_premium_outlined,
              ),
              title: Text(
                settings.personalLicenseIsActive
                    ? licenseLabel(t, license!)
                    : t.licenseNoneActive,
              ),
              subtitle: Text(
                settings.personalLicenseIsActive
                    ? t.licenseHolder(
                        license?.licensee ?? t.licenseUnknownHolder)
                    : t.licenseImportHint,
              ),
            ),
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: _isImporting ? null : _importLicense,
            icon: _isImporting
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  )
                : const Icon(Icons.file_open_outlined),
            label: Text(t.licenseImportButton),
          ),
          if (settings.personalLicenseIsActive) ...[
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: _confirmRemoveLicense,
              icon: const Icon(Icons.delete_outline),
              label: Text(t.licenseRemoveButton),
            ),
          ],
          const SizedBox(height: 24),
          Text(
            t.licenseDeviceBoundNotice,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}
