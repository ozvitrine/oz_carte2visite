import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdService {
  AdService._();

  static final AdService instance = AdService._();

  /// Bloc App Open de test fourni par Google. Utilisé en debug uniquement :
  /// cliquer sur ses propres publicités réelles entraîne la suspension du
  /// compte AdMob.
  static const _androidTestAppOpenAdUnitId =
      'ca-app-pub-3940256099942544/9257395921';

  /// Bloc App Open réel, enregistré dans la console AdMob. Peut être
  /// remplacé au build si besoin : flutter build appbundle
  /// --dart-define=ADMOB_APP_OPEN_ID=...
  static const _androidAppOpenAdUnitId = String.fromEnvironment(
    'ADMOB_APP_OPEN_ID',
    defaultValue: 'ca-app-pub-2062643671190861/6754857400',
  );

  /// Identifiants d’appareils autorisés à recevoir des publicités de test
  /// même en build release. À relever dans le logcat au premier lancement.
  static const List<String> _testDeviceIds = <String>[];

  AppOpenAd? _appOpenAd;
  Future<AppOpenAd?>? _loadingAd;
  bool _isShowing = false;
  bool _isInitialized = false;
  bool _justDismissedAd = false;
  bool _adsSuspended = false;
  bool _canRequestAds = false;

  bool get adsSuspended => _adsSuspended;

  /// Faux tant que l’utilisateur européen n’a pas répondu au formulaire de
  /// consentement : aucune publicité ne doit être demandée avant.
  bool get canRequestAds => _canRequestAds;

  static String get _appOpenAdUnitId {
    if (kDebugMode || _androidAppOpenAdUnitId.isEmpty) {
      return _androidTestAppOpenAdUnitId;
    }

    return _androidAppOpenAdUnitId;
  }

  Future<void> initialize() async {
    if (_isInitialized) return;

    // Le consentement RGPD doit être recueilli avant l’initialisation du SDK
    // publicitaire. Le Play Store rejette les applications qui affichent une
    // publicité personnalisée sans cet écran dans l’EEE.
    await _requestConsent();

    if (!_canRequestAds) {
      // Le SDK reste non initialisé : l’application fonctionne normalement,
      // simplement sans publicité.
      return;
    }

    if (_testDeviceIds.isNotEmpty) {
      await MobileAds.instance.updateRequestConfiguration(
        RequestConfiguration(testDeviceIds: _testDeviceIds),
      );
    }

    await MobileAds.instance.initialize();
    _isInitialized = true;
  }

  Future<void> _requestConsent() async {
    if (!Platform.isAndroid) {
      _canRequestAds = false;
      return;
    }

    final completer = Completer<void>();

    ConsentInformation.instance.requestConsentInfoUpdate(
      ConsentRequestParameters(),
      () async {
        try {
          await _loadAndShowConsentFormIfRequired();
        } finally {
          if (!completer.isCompleted) completer.complete();
        }
      },
      (FormError error) {
        // En cas d’échec réseau, on reste prudent : pas de publicité.
        debugPrint('Consentement indisponible : ${error.message}');

        if (!completer.isCompleted) completer.complete();
      },
    );

    await completer.future.timeout(
      const Duration(seconds: 10),
      onTimeout: () {},
    );

    _canRequestAds = await ConsentInformation.instance.canRequestAds();
  }

  Future<void> _loadAndShowConsentFormIfRequired() {
    final completer = Completer<void>();

    ConsentForm.loadAndShowConsentFormIfRequired((FormError? error) {
      if (error != null) {
        debugPrint('Formulaire de consentement : ${error.message}');
      }

      if (!completer.isCompleted) completer.complete();
    });

    return completer.future;
  }

  /// Permet à l’utilisateur de revenir sur son choix depuis les réglages,
  /// comme l’exige le RGPD.
  Future<void> showPrivacyOptionsForm() async {
    final completer = Completer<void>();

    ConsentForm.showPrivacyOptionsForm((FormError? error) {
      if (error != null) {
        debugPrint('Options de confidentialité : ${error.message}');
      }

      if (!completer.isCompleted) completer.complete();
    });

    await completer.future;

    _canRequestAds = await ConsentInformation.instance.canRequestAds();

    if (!_canRequestAds) {
      _appOpenAd?.dispose();
      _appOpenAd = null;
      _loadingAd = null;
    }
  }

  Future<bool> privacyOptionsRequired() async {
    final status =
        await ConsentInformation.instance.getPrivacyOptionsRequirementStatus();

    return status == PrivacyOptionsRequirementStatus.required;
  }

  /// Suspend les publicités pendant un parcours sensible : création ou
  /// modification de carte, caméra, galerie, OCR et choix du classeur.
  void setAdsSuspended(bool suspended) {
    _adsSuspended = suspended;
  }

  bool consumeJustDismissedAd() {
    if (!_justDismissedAd) return false;

    _justDismissedAd = false;
    return true;
  }

  Future<AppOpenAd?> _loadAppOpenAd() {
    if (!_canRequestAds) {
      return Future.value(null);
    }

    final existingAd = _appOpenAd;

    if (existingAd != null) {
      return Future.value(existingAd);
    }

    final loadingAd = _loadingAd;

    if (loadingAd != null) {
      return loadingAd;
    }

    final completer = Completer<AppOpenAd?>();

    _loadingAd = completer.future;

    AppOpenAd.load(
      adUnitId: _appOpenAdUnitId,
      request: const AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          _appOpenAd = ad;
          _loadingAd = null;
          completer.complete(ad);
        },
        onAdFailedToLoad: (_) {
          _appOpenAd = null;
          _loadingAd = null;
          completer.complete(null);
        },
      ),
    );

    return completer.future;
  }

  Future<bool> showAppOpenAdWhenReady() async {
    if (_isShowing || _adsSuspended) return false;

    if (!_isInitialized) {
      await initialize();
    }

    if (!_canRequestAds) return false;

    final ad = await _loadAppOpenAd().timeout(
      const Duration(seconds: 12),
      onTimeout: () => null,
    );

    if (ad == null || _isShowing || _adsSuspended) {
      return false;
    }

    return _show(ad);
  }

  Future<bool> showAppOpenAdIfAvailable() async {
    if (_isShowing || _adsSuspended || !_canRequestAds) return false;

    final ad = _appOpenAd;

    if (ad == null) {
      _loadAppOpenAd();
      return false;
    }

    return _show(ad);
  }

  Future<bool> _show(AppOpenAd ad) {
    _isShowing = true;

    final completer = Completer<bool>();

    ad.fullScreenContentCallback = FullScreenContentCallback<AppOpenAd>(
      onAdShowedFullScreenContent: (_) {},
      onAdDismissedFullScreenContent: (dismissedAd) {
        dismissedAd.dispose();
        _appOpenAd = null;
        _isShowing = false;
        _justDismissedAd = true;

        _loadAppOpenAd();

        if (!completer.isCompleted) {
          completer.complete(true);
        }
      },
      onAdFailedToShowFullScreenContent: (failedAd, _) {
        failedAd.dispose();
        _appOpenAd = null;
        _isShowing = false;
        _justDismissedAd = true;

        _loadAppOpenAd();

        if (!completer.isCompleted) {
          completer.complete(false);
        }
      },
    );

    ad.show();

    return completer.future;
  }

  void dispose() {
    _appOpenAd?.dispose();
    _appOpenAd = null;
    _loadingAd = null;
    _isShowing = false;
    _justDismissedAd = false;
    _adsSuspended = false;
  }
}
