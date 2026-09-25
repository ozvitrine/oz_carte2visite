import 'dart:io';

import 'package:collection/collection.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../l10n/app_localizations.dart';
import '../models/business_card.dart';
import '../models/card_folder.dart';
import '../services/ad_service.dart';
import '../services/automatic_backup_service.dart';
import '../services/backup_service.dart';
import '../services/card_import_service.dart';
import '../services/external_backup_folder_service.dart';
import '../state/app_settings_store.dart';
import '../state/card_store.dart';
import '../theme/app_themes.dart';
import 'personal_license_screen.dart';

import '../widgets/choose_destination_folder_dialog.dart';
import '../widgets/confirm_dialog.dart';
import '../widgets/create_folder_dialog.dart';
import '../widgets/folder_colors_dialog.dart';
import '../widgets/restore_mode_dialog.dart';
import '../widgets/select_folders_dialog.dart';
import '../widgets/theme_mode_dialog.dart';
import '../widgets/theme_selection_dialog.dart';

import 'folder_cards_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

// À mettre à jour manuellement à chaque nouvelle version envoyée sur le
// Play Store — Android n'expose pas cette date de façon fiable, impossible
// de la déduire automatiquement.
const _lastUpdateDate = '24/09/2026';

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isImportingCard = false;
  bool _isProcessingBackup = false;
  bool _isChoosingExternalFolder = false;
  bool _isActivatingExternalBackup = false;
  bool _isCheckingExternalBackup = false;
  bool _isUpdatingPrivacyOptions = false;

  bool _privacyOptionsRequired = false;
  String? _appVersion;

  bool get _isBusy =>
      _isImportingCard ||
      _isProcessingBackup ||
      _isChoosingExternalFolder ||
      _isActivatingExternalBackup ||
      _isCheckingExternalBackup ||
      _isUpdatingPrivacyOptions;

  @override
  void initState() {
    super.initState();
    _refreshPrivacyOptionsRequirement();
    _loadAppVersion();
  }

  Future<void> _loadAppVersion() async {
    final info = await PackageInfo.fromPlatform();

    if (!mounted) return;

    setState(() {
      _appVersion = '${info.version} (${info.buildNumber})';
    });
  }

  Future<void> _refreshPrivacyOptionsRequirement() async {
    final required = await AdService.instance.privacyOptionsRequired();
    if (!mounted) return;
    setState(() => _privacyOptionsRequired = required);
  }

  Future<void> _openPrivacyOptions() async {
    setState(() => _isUpdatingPrivacyOptions = true);

    try {
      await AdService.instance.showPrivacyOptionsForm();
    } finally {
      if (mounted) {
        setState(() => _isUpdatingPrivacyOptions = false);
      }
      await _refreshPrivacyOptionsRequirement();
    }
  }

  Future<void> _importCardFromFile() async {
    final t = AppLocalizations.of(context)!;
    setState(() => _isImportingCard = true);

    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.any,
        allowMultiple: false,
      );

      if (result == null) return;

      final path = result.files.single.path;
      if (path == null || path.isEmpty) {
        _showMessage(t.settingsFilePickError);
        return;
      }

      final importedCard = await CardImportService().importFromFile(path);
      if (!mounted) return;

      final store = context.read<CardStore>();
      final existingCard =
          store.cards.firstWhereOrNull((c) => c.id == importedCard.id);

      if (existingCard != null) {
        final existingFolder = _folderById(existingCard.folderId);
        if (existingFolder == null) {
          _showMessage(t.settingsCardFolderMissing);
          return;
        }

        final shouldOpenFolder = await _confirmExistingCard(
          card: existingCard,
          folder: existingFolder,
        );

        if (shouldOpenFolder && mounted) {
          _openFolder(existingFolder);
        }
        return;
      }

      final destination = await _chooseDestinationFolder();
      if (destination == null || !mounted) return;

      final cardForFolder = importedCard.copyWith(
        folderId: destination.id,
        updatedAt: DateTime.now(),
      );

      final isAdded = await store.importCard(cardForFolder);
      if (!mounted) return;

      if (!isAdded) {
        final savedCard =
            store.cards.firstWhereOrNull((c) => c.id == cardForFolder.id);
        final savedFolder =
            savedCard == null ? null : _folderById(savedCard.folderId);

        if (savedCard != null && savedFolder != null) {
          final shouldOpenFolder = await _confirmExistingCard(
            card: savedCard,
            folder: savedFolder,
          );

          if (shouldOpenFolder && mounted) {
            _openFolder(savedFolder);
          }
        } else {
          _showMessage(t.settingsCardAlreadySaved);
        }
        return;
      }

      _openFolder(destination);
    } on FormatException catch (error) {
      _showMessage(error.message);
    } catch (_) {
      _showMessage(t.settingsImportError);
    } finally {
      if (mounted) {
        setState(() => _isImportingCard = false);
      }
    }
  }

  Future<void> _exportBackup() async {
    final t = AppLocalizations.of(context)!;
    final store = context.read<CardStore>();

    if (store.cards.isEmpty) {
      _showMessage(t.settingsAddCardBeforeBackup);
      return;
    }

    setState(() => _isProcessingBackup = true);

    try {
      await BackupService().exportBackup(
        cards: store.cards,
        folders: store.folders,
      );

      if (mounted) {
        _showMessage(AppLocalizations.of(context)!.settingsBackupReady);
      }
    } catch (_) {
      if (mounted) {
        _showMessage(AppLocalizations.of(context)!.settingsBackupError);
      }
    } finally {
      if (mounted) {
        setState(() => _isProcessingBackup = false);
      }
    }
  }

  /// Contrairement à _exportBackup, qui inclut toujours tout : ici,
  /// l'utilisateur choisit d'abord les classeurs à transmettre. Le fichier
  /// produit reste un .ozbackup standard — aucune différence côté import.
  Future<void> _transmitSelectedFolders() async {
    final t = AppLocalizations.of(context)!;
    final store = context.read<CardStore>();

    // Les classeurs Abonnement et Carte de fidélité ne sont jamais
    // transmis : ils n'apparaissent même pas dans ce sélecteur, dont le
    // seul but est la transmission.
    final transferableFolders = store.folders
        .where((folder) => folder.kind == FolderKind.businessCard)
        .toList();

    if (transferableFolders.isEmpty) {
      _showMessage(t.settingsAddCardBeforeBackup);
      return;
    }

    final selectedIds = await SelectFoldersDialog.show(
      context,
      folders: transferableFolders,
    );

    if (selectedIds == null || selectedIds.isEmpty || !mounted) return;

    final selectedFolders = store.folders
        .where((folder) => selectedIds.contains(folder.id))
        .toList();
    final selectedCards = store.cards
        .where((card) => selectedIds.contains(card.folderId))
        .toList();

    if (selectedCards.isEmpty) {
      _showMessage(t.settingsTransmitEmptyFolders);
      return;
    }

    setState(() => _isProcessingBackup = true);

    try {
      await BackupService().exportBackup(
        cards: selectedCards,
        folders: selectedFolders,
        filePrefix: 'oz_carte2visite_transmission',
        shareSubject: t.settingsTransmitShareSubject,
        shareText: t.settingsTransmitShareText(selectedFolders.length),
      );

      if (mounted) {
        _showMessage(AppLocalizations.of(context)!.settingsTransmitReady);
      }
    } catch (_) {
      if (mounted) {
        _showMessage(AppLocalizations.of(context)!.settingsTransmitError);
      }
    } finally {
      if (mounted) {
        setState(() => _isProcessingBackup = false);
      }
    }
  }

  Future<void> _restoreBackup() async {
    setState(() => _isProcessingBackup = true);

    try {
      final backup = await BackupService().pickAndRestoreBackup();
      if (!mounted) return;

      final choice = await RestoreModeDialog.show(
        context,
        cards: backup.cards.length,
        folders: backup.folders.length,
      );

      if (choice == null || !mounted) return;

      if (choice == RestoreMode.replace) {
        final t = AppLocalizations.of(context)!;
        final colors = Theme.of(context).colorScheme;

        final confirmedReplace = await ConfirmDialog.show(
          context,
          icon: Icons.warning_amber_outlined,
          iconColor: colors.error,
          title: t.settingsConfirmReplaceTitle,
          body: t.settingsConfirmReplaceBody(
              backup.cards.length, backup.folders.length),
          cancelLabel: t.actionCancel,
          confirmLabel: t.actionReplaceAll,
          isDestructive: true,
        );

        if (!confirmedReplace || !mounted) return;

        await context.read<CardStore>().restoreBackup(
              backup,
              mode: RestoreMode.replace,
            );

        if (!mounted) return;

        _showMessage(
          AppLocalizations.of(context)!
              .settingsRestoreReplaced(backup.cards.length),
        );
        return;
      }

      final t = AppLocalizations.of(context)!;
      final confirmation = await ConfirmDialog.show(
        context,
        icon: Icons.restore_outlined,
        title: t.settingsConfirmMergeTitle,
        body: t.settingsConfirmMergeBody(
            backup.cards.length, backup.folders.length),
        cancelLabel: t.actionCancel,
        confirmLabel: t.actionRestore,
      );

      if (!confirmation || !mounted) return;

      final result = await context.read<CardStore>().restoreBackup(
            backup,
            mode: RestoreMode.merge,
          );

      if (!mounted || result == null) return;

      _showMessage(
        AppLocalizations.of(context)!.settingsRestoreMerged(
          result.addedCards,
          result.existingCards,
          result.addedFolders,
        ),
      );
    } on BackupCancelledException {
      // Annulation du file picker
    } on FormatException catch (error) {
      _showMessage(error.message);
    } catch (_) {
      _showMessage(AppLocalizations.of(context)!.settingsRestoreError);
    } finally {
      if (mounted) {
        setState(() => _isProcessingBackup = false);
      }
    }
  }

  Future<void> _setExternalBackupEnabled(bool enabled) async {
    final t = AppLocalizations.of(context)!;
    final settings = context.read<AppSettingsStore>();

    if (!enabled) {
      await settings.setExternalBackupEnabled(false);
      if (mounted) {
        _showMessage(t.settingsExternalBackupDisabled);
      }
      return;
    }

    final store = context.read<CardStore>();

    if (store.cards.isEmpty) {
      _showMessage(t.settingsAddCardBeforeExternal);
      return;
    }

    final externalFolder = ExternalBackupFolderService();
    final hasFolder = await externalFolder.hasSelectedFolder();

    if (!mounted) return;

    if (!hasFolder) {
      _showMessage(t.settingsChooseFolderFirst);
      return;
    }

    setState(() => _isActivatingExternalBackup = true);

    try {
      await AutomaticBackupService().activateExternalBackup(
        cards: store.cards,
        folders: store.folders,
      );

      if (!mounted) return;

      await settings.setExternalBackupEnabled(true);

      if (mounted) {
        _showMessage(t.settingsExternalBackupActivated);
      }
    } on FileSystemException catch (error) {
      if (mounted) {
        _showMessage(error.message);
      }
    } catch (_) {
      if (mounted) {
        _showMessage(t.settingsExternalBackupActivateError);
      }
    } finally {
      if (mounted) {
        setState(() => _isActivatingExternalBackup = false);
      }
    }
  }

  Future<void> _chooseExternalBackupFolder() async {
    final t = AppLocalizations.of(context)!;
    setState(() => _isChoosingExternalFolder = true);

    try {
      final folderName = await ExternalBackupFolderService().chooseFolder();

      if (!mounted || folderName == null || folderName.isEmpty) {
        return;
      }

      await context
          .read<AppSettingsStore>()
          .setExternalBackupFolderName(folderName);

      if (mounted) {
        _showMessage(t.settingsFolderSelected(folderName));
      }
    } catch (_) {
      if (mounted) {
        _showMessage(AppLocalizations.of(context)!.settingsFolderSelectError);
      }
    } finally {
      if (mounted) {
        setState(() => _isChoosingExternalFolder = false);
      }
    }
  }

  Future<void> _checkExternalBackup() async {
    final t = AppLocalizations.of(context)!;
    setState(() => _isCheckingExternalBackup = true);

    try {
      final status = await AutomaticBackupService().checkExternalBackup();

      if (!mounted) return;

      if (!status.hasFolder) {
        _showMessage(t.settingsNoExternalFolder);
        return;
      }

      if (status.hasBackupForCurrentWeek) {
        _showMessage(
          t.settingsBackupVerified(
            status.fileName,
            status.fileSize ~/ 1024,
            status.folderName ?? t.settingsSelectedFolderFallback,
          ),
        );
      } else {
        _showMessage(t.settingsNoBackupThisWeek);
      }
    } catch (_) {
      if (mounted) {
        _showMessage(AppLocalizations.of(context)!.settingsCheckExternalError);
      }
    } finally {
      if (mounted) {
        setState(() => _isCheckingExternalBackup = false);
      }
    }
  }

  Future<void> _chooseThemeMode() async {
    final settings = context.read<AppSettingsStore>();
    final selected = await ThemeModeDialog.show(context, settings.themeMode);

    if (selected != null && mounted) {
      await context.read<AppSettingsStore>().setThemeMode(selected);
    }
  }

  Future<void> _chooseTheme() async {
    final currentTheme = context.read<AppSettingsStore>().selectedTheme;
    final selected = await ThemeSelectionDialog.show(context, currentTheme);

    if (selected != null && mounted) {
      await context.read<AppSettingsStore>().setTheme(selected);
    }
  }

  Future<void> _setAutoClose(bool enabled) async {
    await context.read<AppSettingsStore>().setAutoCloseEnabled(enabled);

    if (!mounted) return;

    final t = AppLocalizations.of(context)!;
    _showMessage(
      enabled ? t.settingsAutoCloseEnabled : t.settingsAutoCloseDisabled,
    );
  }

  Future<void> _showNotice() async {
    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        final t = AppLocalizations.of(dialogContext)!;

        return AlertDialog(
          insetPadding: EdgeInsets.fromLTRB(
            24,
            24,
            24,
            24 + MediaQuery.of(dialogContext).padding.bottom,
          ),
          title: Text(t.settingsNoticeTitle),
          content: SingleChildScrollView(
            child: Text(t.settingsNoticeBody),
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

  Future<void> _openChangelog() async {
    final uri = Uri.parse(
      'https://ozvitrine.github.io/oz_carte2visite/changelog.html',
    );

    if (!await launchUrl(uri, mode: LaunchMode.externalApplication) &&
        mounted) {
      _showMessage(AppLocalizations.of(context)!.settingsChangelogError);
    }
  }

  Future<void> _showLegalInformation() async {
    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        final t = AppLocalizations.of(dialogContext)!;

        return AlertDialog(
          insetPadding: EdgeInsets.fromLTRB(
            24,
            24,
            24,
            24 + MediaQuery.of(dialogContext).padding.bottom,
          ),
          title: Text(t.settingsLegalTitle),
          content: SingleChildScrollView(
            child: Text(t.settingsLegalBody),
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

  Future<bool> _confirmExistingCard({
    required BusinessCard card,
    required CardFolder folder,
  }) async {
    final t = AppLocalizations.of(context)!;

    final displayName = card.company.isNotEmpty
        ? card.company
        : card.name.isNotEmpty
            ? card.name
            : t.settingsThisCardFallback;

    return ConfirmDialog.show(
      context,
      icon: Icons.info_outline,
      title: t.settingsCardAlreadySavedTitle,
      body: t.settingsCardAlreadySavedBody(displayName, folder.name),
      cancelLabel: t.actionStayHere,
      confirmLabel: t.actionOpenFolder,
    );
  }

  void _openFolder(CardFolder folder) {
    if (!mounted) return;

    Navigator.pop(context);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FolderCardsScreen(folder: folder),
      ),
    );
  }

  Future<CardFolder?> _chooseDestinationFolder() async {
    final store = context.read<CardStore>();

    if (store.folders.isEmpty) {
      return _createNewFolder();
    }

    final result =
        await ChooseDestinationFolderDialog.show(context, store.folders);

    if (!mounted || result == null || result.isCancelled) {
      return null;
    }

    if (result.shouldCreateFolder) {
      return _createNewFolder();
    }

    if (result.folderId == null) return null;

    return _folderById(result.folderId!);
  }

  Future<CardFolder?> _createNewFolder() async {
    if (!mounted) return null;

    final result = await CreateFolderDialog.show(context);
    final cleanName = result?.name.trim() ?? '';

    if (cleanName.isEmpty || !mounted) return null;

    final store = context.read<CardStore>();
    final created = await store.addFolder(cleanName, kind: result!.kind);

    if (!mounted) return null;

    if (!created) {
      _showMessage(AppLocalizations.of(context)!.settingsFolderNameTaken);
      return null;
    }

    return _folderByName(cleanName);
  }

  CardFolder? _folderById(String id) {
    return context
        .read<CardStore>()
        .folders
        .firstWhereOrNull((f) => f.id == id);
  }

  CardFolder? _folderByName(String name) {
    final normalizedName = _normalizeFolderName(name);
    return context.read<CardStore>().folders.firstWhereOrNull(
          (f) => _normalizeFolderName(f.name) == normalizedName,
        );
  }

  String _normalizeFolderName(String value) {
    return value.trim().toLowerCase().replaceAll(RegExp(r'\s+'), ' ');
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

  /// Seule direction autorisée : mono-carte → avec publicité. Une fois sur
  /// la formule avec publicité, aucun retour en arrière n'est proposé.
  bool _canUpgradeToAdsPlan(AppSettingsStore settings) {
    return !settings.isPremium &&
        settings.licensePlan == AppLicensePlan.noAdsLimited;
  }

  Future<void> _upgradeToAdsPlan() async {
    final t = AppLocalizations.of(context)!;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          icon: const Icon(Icons.ondemand_video_outlined),
          title: Text(t.settingsSwitchToAdsTitle),
          content: Text(t.settingsSwitchToAdsBody),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: Text(t.actionCancel),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: Text(t.actionConfirm),
            ),
          ],
        );
      },
    );

    if (confirmed != true || !mounted) return;

    if (!AdService.instance.canRequestAds) {
      await _resolveConsentForAdsUpgrade();
      return;
    }

    await context
        .read<AppSettingsStore>()
        .setLicensePlan(AppLicensePlan.adsUnlimited);

    if (mounted) {
      _showMessage(AppLocalizations.of(context)!.settingsPlanChanged);
    }
  }

  /// Même logique que pendant l'onboarding : le consentement est requis
  /// avant d'activer la formule avec publicité, jamais contourné.
  Future<void> _resolveConsentForAdsUpgrade() async {
    final t = AppLocalizations.of(context)!;

    final reviewed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          icon: const Icon(Icons.error_outline),
          title: Text(t.consentRequiredTitle),
          content: Text(t.settingsConsentNeededForAdsBody),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: Text(t.actionCancel),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: Text(t.actionReviewConsent),
            ),
          ],
        );
      },
    );

    if (reviewed != true || !mounted) return;

    await AdService.instance.showPrivacyOptionsForm();

    if (!mounted) return;

    if (AdService.instance.canRequestAds) {
      await context
          .read<AppSettingsStore>()
          .setLicensePlan(AppLicensePlan.adsUnlimited);

      if (mounted) {
        _showMessage(AppLocalizations.of(context)!.settingsPlanChanged);
      }
    } else {
      _showMessage(AppLocalizations.of(context)!.settingsConsentStillMissing);
    }
  }

  IconData _currentPlanIcon(AppSettingsStore settings) {
    if (settings.isPremium) {
      return Icons.workspace_premium_outlined;
    }

    return switch (settings.licensePlan) {
      AppLicensePlan.adsUnlimited => Icons.ondemand_video_outlined,
      AppLicensePlan.noAdsLimited => Icons.looks_one_outlined,
      AppLicensePlan.premium => Icons.workspace_premium_outlined,
    };
  }

  String _currentPlanLabel(AppLocalizations t, AppSettingsStore settings) {
    if (settings.isPremium) {
      return t.licensePlayBillingActive;
    }

    return switch (settings.licensePlan) {
      AppLicensePlan.adsUnlimited => t.settingsPlanAdsLabel,
      AppLicensePlan.noAdsLimited => t.settingsPlanFreeLabel,
      AppLicensePlan.premium => t.settingsPlanPremiumLabel,
    };
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final settings = context.watch<AppSettingsStore>();
    final settingsLocked = !settings.canUseSettings;

    final externalFolderName = settings.externalBackupFolderName;

    return Scaffold(
      appBar: AppBar(
        title: Text(t.settingsTitle),
      ),
      body: ListView(
        padding: EdgeInsets.fromLTRB(
          16,
          16,
          16,
          16 + MediaQuery.of(context).padding.bottom,
        ),
        children: [
          Card(
            child: ListTile(
              leading: Icon(_currentPlanIcon(settings)),
              title: Text(t.settingsCurrentPlanTitle),
              subtitle: Text(_currentPlanLabel(t, settings)),
              trailing: _canUpgradeToAdsPlan(settings)
                  ? const Icon(Icons.chevron_right)
                  : null,
              onTap: _canUpgradeToAdsPlan(settings) ? _upgradeToAdsPlan : null,
            ),
          ),
          const SizedBox(height: 16),
          if (settingsLocked)
            Card(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              child: ListTile(
                leading: const Icon(Icons.lock_outline),
                title: Text(t.settingsLockedTitle),
                subtitle: Text(t.settingsLockedBody),
              ),
            ),
          if (settingsLocked) const SizedBox(height: 16),
          Text(
            t.settingsSectionImport,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              leading: const Icon(Icons.file_open_outlined),
              title: Text(t.settingsImportCardTitle),
              subtitle: Text(t.settingsImportCardSubtitle),
              trailing: _isImportingCard
                  ? const SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.chevron_right),
              enabled: !_isBusy && !settingsLocked,
              onTap: _isBusy || settingsLocked ? null : _importCardFromFile,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            t.settingsSectionDbBackup,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.backup_outlined),
                  title: Text(t.settingsExportBackupTitle),
                  subtitle: Text(t.settingsExportBackupSubtitle),
                  trailing: _isProcessingBackup
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.share_outlined),
                  enabled: !_isBusy && !settingsLocked,
                  onTap: _isBusy || settingsLocked ? null : _exportBackup,
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.restore_outlined),
                  title: Text(t.settingsRestoreBackupTitle),
                  subtitle: Text(t.settingsRestoreBackupSubtitle),
                  trailing: const Icon(Icons.chevron_right),
                  enabled: !_isBusy && !settingsLocked,
                  onTap: _isBusy || settingsLocked ? null : _restoreBackup,
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.checklist_outlined),
                  title: Text(t.settingsTransmitFoldersTitle),
                  subtitle: Text(t.settingsTransmitFoldersSubtitle),
                  trailing: _isProcessingBackup
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.chevron_right),
                  enabled: !_isBusy && !settingsLocked,
                  onTap: _isBusy || settingsLocked
                      ? null
                      : _transmitSelectedFolders,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            t.settingsSectionExternalBackup,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Card(
            child: Column(
              children: [
                SwitchListTile(
                  secondary: const Icon(Icons.cloud_sync_outlined),
                  title: Text(t.settingsExternalToggleTitle),
                  subtitle: Text(
                    settings.externalBackupEnabled
                        ? t.settingsExternalToggleOn
                        : t.settingsExternalToggleOff,
                  ),
                  value: settings.externalBackupEnabled,
                  onChanged: _isBusy || settingsLocked
                      ? null
                      : _setExternalBackupEnabled,
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.folder_outlined),
                  title: Text(t.settingsChooseFolderMenuTitle),
                  subtitle: Text(
                    externalFolderName == null
                        ? t.settingsNoFolderSelected
                        : t.settingsCurrentFolder(externalFolderName),
                  ),
                  trailing: _isChoosingExternalFolder
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.chevron_right),
                  enabled: !_isBusy && !settingsLocked,
                  onTap: _isBusy || settingsLocked
                      ? null
                      : _chooseExternalBackupFolder,
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.verified_outlined),
                  title: Text(t.settingsCheckExternalTitle),
                  subtitle: Text(t.settingsCheckExternalSubtitle),
                  trailing: _isCheckingExternalBackup
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.chevron_right),
                  enabled: !_isBusy && !settingsLocked,
                  onTap:
                      _isBusy || settingsLocked ? null : _checkExternalBackup,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 0),
            child: Text(
              t.settingsExternalFootnote,
              style: const TextStyle(fontSize: 12),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            t.settingsSectionAppearance,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.brightness_6_outlined),
                  title: Text(t.settingsDisplayModeTitle),
                  subtitle: Text(
                    switch (settings.themeMode) {
                      AppThemeMode.system => t.settingsThemeAutoTitle,
                      AppThemeMode.light => t.settingsThemeLightTitle,
                      AppThemeMode.dark => t.settingsThemeDarkTitle,
                    },
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  enabled: !_isBusy && !settingsLocked,
                  onTap: _isBusy || settingsLocked ? null : _chooseThemeMode,
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.palette_outlined),
                  title: Text(t.settingsAppThemeTitle),
                  subtitle: Text(settings.selectedTheme.label),
                  trailing: const Icon(Icons.chevron_right),
                  enabled: !_isBusy && !settingsLocked,
                  onTap: _isBusy || settingsLocked ? null : _chooseTheme,
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.folder_special_outlined),
                  title: Text(t.settingsFolderColorsTitle),
                  subtitle: Text(t.settingsFolderColorsSubtitle),
                  trailing: const Icon(Icons.chevron_right),
                  enabled: !_isBusy && !settingsLocked,
                  onTap: _isBusy || settingsLocked
                      ? null
                      : () => FolderColorsDialog.show(context),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            t.settingsSectionBehavior,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Card(
            child: SwitchListTile(
              secondary: const Icon(Icons.timer_outlined),
              title: Text(t.settingsAutoCloseTitle),
              subtitle: Text(t.settingsAutoCloseSubtitle),
              value: settings.autoCloseEnabled,
              onChanged: _isBusy || settingsLocked ? null : _setAutoClose,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            t.settingsSectionFolderKinds,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Card(
            child: Column(
              children: [
                SwitchListTile(
                  secondary: const Icon(Icons.card_membership_outlined),
                  title: Text(t.folderKindSubscription),
                  subtitle: Text(
                    settings.isPremium
                        ? t.settingsFolderKindToggleSubtitle
                        : t.settingsFolderKindPremiumOnly,
                  ),
                  value: settings.subscriptionFoldersEnabled,
                  onChanged: (_isBusy || !settings.isPremium)
                      ? null
                      : (value) =>
                          settings.setSubscriptionFoldersEnabled(value),
                ),
                const Divider(height: 1),
                SwitchListTile(
                  secondary: const Icon(Icons.sell_outlined),
                  title: Text(t.folderKindDiscount),
                  subtitle: Text(
                    settings.isPremium
                        ? t.settingsFolderKindToggleSubtitle
                        : t.settingsFolderKindPremiumOnly,
                  ),
                  value: settings.discountFoldersEnabled,
                  onChanged: (_isBusy || !settings.isPremium)
                      ? null
                      : (value) => settings.setDiscountFoldersEnabled(value),
                ),
              ],
            ),
          ),
          if (_privacyOptionsRequired) ...[
            const SizedBox(height: 24),
            Text(
              t.settingsSectionPrivacy,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Card(
              child: ListTile(
                leading: const Icon(Icons.privacy_tip_outlined),
                title: Text(t.settingsPersonalizedAdsTitle),
                subtitle: Text(t.settingsPersonalizedAdsSubtitle),
                trailing: _isUpdatingPrivacyOptions
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.chevron_right),
                enabled: !_isBusy,
                onTap: _isBusy ? null : _openPrivacyOptions,
              ),
            ),
          ],
          const SizedBox(height: 24),
          Text(
            t.settingsSectionInfo,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.menu_book_outlined),
                  title: Text(t.settingsNoticeTitle),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: _showNotice,
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.verified_user_outlined),
                  title: Text(t.settingsPersonalLicenseTitle),
                  subtitle: Text(t.settingsPersonalLicenseSubtitle),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const PersonalLicenseScreen(),
                      ),
                    );
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.gavel_outlined),
                  title: Text(t.settingsLegalMenuTitle),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: _showLegalInformation,
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.new_releases_outlined),
                  title: Text(t.settingsChangelogTitle),
                  subtitle: Text(t.settingsChangelogSubtitle),
                  trailing: const Icon(Icons.open_in_new, size: 18),
                  onTap: _openChangelog,
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.info_outline),
                  title: Text(t.settingsVersionTitle),
                  subtitle: Text(
                    _appVersion == null
                        ? t.commonLoading
                        : t.settingsVersionSubtitle(
                            _appVersion!,
                            _lastUpdateDate,
                          ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
