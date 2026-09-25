import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/native_locale_service.dart';
import '../theme/app_themes.dart';

enum AppThemeMode {
  system,
  light,
  dark,
}

enum AppLicensePlan {
  noAdsLimited,
  adsUnlimited,
  premium,
}

class AppSettingsStore extends ChangeNotifier {
  static const _themeModeKey = 'app_theme_mode';
  static const _appThemeIdKey = 'app_theme_id';
  static const _localeCodeKey = 'app_locale_code';
  static const _autoCloseEnabledKey = 'auto_close_enabled';
  static const _externalBackupEnabledKey = 'external_backup_enabled';
  static const _externalBackupFolderNameKey = 'external_backup_folder_name';
  static const _licensePlanKey = 'license_plan';
  static const _playBillingPremiumActiveKey = 'play_billing_premium_active';
  static const _subscriptionFoldersEnabledKey = 'subscription_folders_enabled';
  static const _discountFoldersEnabledKey = 'discount_folders_enabled';

  AppThemeMode _themeMode = AppThemeMode.system;
  AppLicensePlan _selectedPlan = AppLicensePlan.adsUnlimited;
  AppTheme _selectedTheme = defaultAppTheme;
  String? _localeCode;
  bool _autoCloseEnabled = true;
  bool _externalBackupEnabled = false;
  String? _externalBackupFolderName;
  bool _isLoaded = false;
  bool _playBillingPremiumActive = false;

  // Activés par défaut : la fonctionnalité existe déjà, elle ne doit pas
  // disparaître silencieusement pour qui ne les a jamais désactivés.
  bool _subscriptionFoldersEnabled = true;
  bool _discountFoldersEnabled = true;

  AppThemeMode get themeMode => _themeMode;

  /// Formule réellement active : un abonnement Google Play actif prévaut
  /// sur le choix gratuit ou avec publicité.
  AppLicensePlan get licensePlan {
    return isPremium ? AppLicensePlan.premium : _selectedPlan;
  }

  AppTheme get selectedTheme => _selectedTheme;
  Color get seedColor => _selectedTheme.seedColor;

  /// `null` tant que l'utilisateur n'a pas encore fait de choix explicite
  /// — c'est ce qui déclenche l'affichage de l'écran de choix de langue
  /// au tout premier lancement, avant même l'onboarding.
  Locale? get locale => _localeCode == null ? null : Locale(_localeCode!);
  bool get localeChosen => _localeCode != null;
  bool get autoCloseEnabled => _autoCloseEnabled;
  bool get externalBackupEnabled => _externalBackupEnabled;
  String? get externalBackupFolderName => _externalBackupFolderName;
  bool get isLoaded => _isLoaded;

  bool get playBillingPremiumActive => _playBillingPremiumActive;

  bool get subscriptionFoldersEnabled => _subscriptionFoldersEnabled;
  bool get discountFoldersEnabled => _discountFoldersEnabled;

  /// Vrai si Premium est actif — uniquement via un abonnement Google Play
  /// désormais.
  bool get isPremium => _playBillingPremiumActive;

  bool get shouldShowAds => licensePlan == AppLicensePlan.adsUnlimited;

  bool get canUseSettings => licensePlan == AppLicensePlan.premium;

  bool get isLimitedToOneCard => licensePlan == AppLicensePlan.noAdsLimited;

  ThemeMode get materialThemeMode {
    return switch (_themeMode) {
      AppThemeMode.system => ThemeMode.system,
      AppThemeMode.light => ThemeMode.light,
      AppThemeMode.dark => ThemeMode.dark,
    };
  }

  Future<void> load() async {
    final preferences = await SharedPreferences.getInstance();

    final savedTheme = preferences.getString(_themeModeKey);
    final savedThemeId = preferences.getString(_appThemeIdKey);
    final savedPlan = preferences.getString(_licensePlanKey);

    _themeMode = switch (savedTheme) {
      'light' => AppThemeMode.light,
      'dark' => AppThemeMode.dark,
      _ => AppThemeMode.system,
    };

    _selectedPlan = switch (savedPlan) {
      'no_ads_limited' => AppLicensePlan.noAdsLimited,
      _ => AppLicensePlan.adsUnlimited,
    };

    // appThemeById retombe déjà sur le thème par défaut si savedThemeId est
    // absent (première utilisation, ou mise à jour depuis une version
    // antérieure au système de thèmes nommés).
    _selectedTheme = appThemeById(savedThemeId);
    _localeCode = preferences.getString(_localeCodeKey);

    // Réappliqué à chaque démarrage : la langue native (formulaire de
    // consentement Google notamment) doit rester alignée avec le choix
    // déjà fait, même après un redémarrage complet de l'app.
    if (_localeCode != null) {
      await NativeLocaleService().setAppLocale(_localeCode!);
    }

    _autoCloseEnabled = preferences.getBool(_autoCloseEnabledKey) ?? true;

    _externalBackupEnabled =
        preferences.getBool(_externalBackupEnabledKey) ?? false;

    _externalBackupFolderName = preferences.getString(
      _externalBackupFolderNameKey,
    );

    // Statut local mis en cache : la vraie source de vérité reste Google
    // Play, revérifiée à chaque démarrage via PlayBillingService.restore()
    // dans main.dart — cette valeur ne sert qu'à afficher le bon état
    // avant que cette vérification asynchrone ne se termine.
    _playBillingPremiumActive =
        preferences.getBool(_playBillingPremiumActiveKey) ?? false;

    _subscriptionFoldersEnabled =
        preferences.getBool(_subscriptionFoldersEnabledKey) ?? true;
    _discountFoldersEnabled =
        preferences.getBool(_discountFoldersEnabledKey) ?? true;

    _isLoaded = true;
    notifyListeners();
  }

  Future<void> setLicensePlan(AppLicensePlan plan) async {
    // Premium ne peut être activé que via Google Play Billing.
    if (plan == AppLicensePlan.premium) {
      return;
    }

    _selectedPlan = plan;

    final value = switch (plan) {
      AppLicensePlan.noAdsLimited => 'no_ads_limited',
      AppLicensePlan.adsUnlimited => 'ads_unlimited',
      AppLicensePlan.premium => 'ads_unlimited',
    };

    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(_licensePlanKey, value);

    notifyListeners();
  }

  /// Reflète l'état d'abonnement Google Play Billing. Appelé par
  /// PlayBillingService à chaque changement (achat, restauration,
  /// expiration détectée) — jamais par l'écran directement.
  Future<void> setPlayBillingPremiumActive(bool active) async {
    if (_playBillingPremiumActive == active) return;

    _playBillingPremiumActive = active;

    final preferences = await SharedPreferences.getInstance();
    await preferences.setBool(_playBillingPremiumActiveKey, active);

    notifyListeners();
  }

  Future<void> setSubscriptionFoldersEnabled(bool enabled) async {
    _subscriptionFoldersEnabled = enabled;

    final preferences = await SharedPreferences.getInstance();
    await preferences.setBool(_subscriptionFoldersEnabledKey, enabled);

    notifyListeners();
  }

  Future<void> setDiscountFoldersEnabled(bool enabled) async {
    _discountFoldersEnabled = enabled;

    final preferences = await SharedPreferences.getInstance();
    await preferences.setBool(_discountFoldersEnabledKey, enabled);

    notifyListeners();
  }

  Future<void> setThemeMode(AppThemeMode mode) async {
    _themeMode = mode;

    final value = switch (mode) {
      AppThemeMode.system => 'system',
      AppThemeMode.light => 'light',
      AppThemeMode.dark => 'dark',
    };

    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(_themeModeKey, value);

    notifyListeners();
  }

  Future<void> setTheme(AppTheme theme) async {
    _selectedTheme = theme;

    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(_appThemeIdKey, theme.id);

    notifyListeners();
  }

  Future<void> setLocale(String code) async {
    _localeCode = code;

    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(_localeCodeKey, code);

    await NativeLocaleService().setAppLocale(code);

    notifyListeners();
  }

  Future<void> setAutoCloseEnabled(bool enabled) async {
    _autoCloseEnabled = enabled;

    final preferences = await SharedPreferences.getInstance();
    await preferences.setBool(_autoCloseEnabledKey, enabled);

    notifyListeners();
  }

  Future<void> setExternalBackupEnabled(bool enabled) async {
    _externalBackupEnabled = enabled;

    final preferences = await SharedPreferences.getInstance();
    await preferences.setBool(_externalBackupEnabledKey, enabled);

    notifyListeners();
  }

  Future<void> setExternalBackupFolderName(String? folderName) async {
    _externalBackupFolderName = folderName;

    final preferences = await SharedPreferences.getInstance();

    if (folderName == null || folderName.isEmpty) {
      await preferences.remove(_externalBackupFolderNameKey);
    } else {
      await preferences.setString(
        _externalBackupFolderNameKey,
        folderName,
      );
    }

    notifyListeners();
  }
}
