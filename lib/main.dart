import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'l10n/app_localizations.dart';
import 'screens/app_gate.dart';
import 'services/ad_service.dart';
import 'services/database/app_database.dart';
import 'services/database/drift_storage_service.dart';
import 'services/play_billing_service.dart';
import 'state/app_settings_store.dart';
import 'state/card_store.dart';
import 'widgets/inactivity_guard.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const OzCarte2VisiteBootstrap());
}

enum _ConsentChoice { reviewConsent, useFreePlan }

class OzCarte2VisiteBootstrap extends StatelessWidget {
  const OzCarte2VisiteBootstrap({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppSettingsStore()..load(),
      child: const _AppProviders(),
    );
  }
}

class _AppProviders extends StatelessWidget {
  const _AppProviders();

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<AppSettingsStore>();

    if (!settings.isLoaded) {
      return const MaterialApp(
        home: Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    return ChangeNotifierProvider(
      create: (_) => CardStore(
        DriftStorageService(AppDatabase()),
        settings,
      )..load(),
      child: const OzCarte2VisiteApp(),
    );
  }
}

class OzCarte2VisiteApp extends StatefulWidget {
  const OzCarte2VisiteApp({super.key});

  @override
  State<OzCarte2VisiteApp> createState() => _OzCarte2VisiteAppState();
}

class _OzCarte2VisiteAppState extends State<OzCarte2VisiteApp>
    with WidgetsBindingObserver {
  bool _isAdInitialized = false;
  bool _adInitTriggered = false;
  bool _wasInBackground = false;

  // Nécessaire pour afficher une boîte de dialogue depuis _initializeAds(),
  // qui se déclenche hors du contexte du Navigator de MaterialApp.
  final _navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializePlayBilling();
    // L'initialisation publicitaire (et le formulaire de consentement
    // Google qui va avec) n'est plus lancée ici : elle attend que la
    // langue soit choisie, dans build() ci-dessous. Sinon le formulaire
    // de consentement pouvait apparaître avant même l'écran de langue.
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    AdService.instance.dispose();
    PlayBillingService.instance.dispose();
    super.dispose();
  }

  /// Indépendant du choix de langue et de la publicité : l'abonnement
  /// Premium doit être revérifié dès que possible à chaque lancement,
  /// sans attendre l'écran de langue.
  Future<void> _initializePlayBilling() async {
    await PlayBillingService.instance.initialize(
      onPremiumStatusChanged: (active) {
        if (!mounted) return;
        context.read<AppSettingsStore>().setPlayBillingPremiumActive(active);
      },
    );

    await PlayBillingService.instance.restorePurchases();
  }

  Future<void> _initializeAds() async {
    await AdService.instance.initialize();

    if (!mounted) return;

    _isAdInitialized = true;

    // Pas de publicité ici : le premier lancement (mentions légales,
    // formule et première carte) doit rester sans publicité.

    _checkAdsPlanConsistency();
  }

  /// Un utilisateur déjà installé, déjà sur la formule « avec publicité »,
  /// peut avoir retiré son consentement depuis les réglages entre deux
  /// lancements. Dans ce cas, la formule n'est plus valide — elle repose
  /// entièrement sur l'affichage de publicités.
  void _checkAdsPlanConsistency() {
    final settings = context.read<AppSettingsStore>();

    if (settings.licensePlan != AppLicensePlan.adsUnlimited) return;
    if (AdService.instance.canRequestAds) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showConsentRequiredDialog();
    });
  }

  Future<void> _showConsentRequiredDialog() async {
    final navigatorContext = _navigatorKey.currentContext;
    if (navigatorContext == null) return;

    final t = AppLocalizations.of(navigatorContext)!;

    final choice = await showDialog<_ConsentChoice>(
      context: navigatorContext,
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

    if (choice == null) return;

    if (choice == _ConsentChoice.useFreePlan) {
      if (mounted) {
        await context
            .read<AppSettingsStore>()
            .setLicensePlan(AppLicensePlan.noAdsLimited);
      }
      return;
    }

    // reviewConsent : rouvre le formulaire, puis revérifie — si le
    // consentement est maintenant valide, tout continue normalement.
    await AdService.instance.showPrivacyOptionsForm();

    if (mounted) {
      _checkAdsPlanConsistency();
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      _wasInBackground = true;

      // Écrit immédiatement la sauvegarde locale en attente : l'app peut
      // être tuée par le système à tout moment une fois en arrière-plan.
      context.read<CardStore>().flushAutomaticBackup();
      return;
    }

    if (state == AppLifecycleState.detached) {
      _wasInBackground = false;
      return;
    }

    if (state == AppLifecycleState.resumed && _wasInBackground) {
      _wasInBackground = false;
      _showAdOnRealReturn();
    }
  }

  Future<void> _showAdOnRealReturn() async {
    if (!_isAdInitialized || !mounted) return;

    final store = context.read<CardStore>();
    final settings = context.read<AppSettingsStore>();

    // Aucune annonce tant que l'utilisateur n'a pas terminé la première carte.
    if (!store.onboardingComplete) return;

    // Aucune annonce pour Premium ou Sans publicité.
    if (!settings.shouldShowAds) return;

    // Création/modification de carte : les publicités sont suspendues.
    if (AdService.instance.adsSuspended) return;

    // La fermeture d'une App Open Ad provoque aussi un événement resumed.
    // Il ne faut jamais en rouvrir une autre immédiatement.
    if (AdService.instance.consumeJustDismissedAd()) return;

    await AdService.instance.showAppOpenAdWhenReady();
  }

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<AppSettingsStore>();

    // Ne se déclenche qu'une fois, et seulement après que l'utilisateur a
    // choisi sa langue — c'est ce choix qui détermine la langue du
    // formulaire de consentement Google affiché juste après.
    if (settings.localeChosen && !_adInitTriggered) {
      _adInitTriggered = true;
      _initializeAds();
    }

    return MaterialApp(
      navigatorKey: _navigatorKey,
      title: 'oz_carte2visite',
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      // Tant qu'aucun choix explicite n'a été fait (LanguageSelectionScreen
      // pas encore passé), locale reste `null` : Flutter retombe alors sur
      // la langue du téléphone si elle fait partie de supportedLocales, et
      // sur le français sinon. Une fois le choix fait, il prime toujours
      // sur la langue du téléphone.
      locale: settings.locale,
      theme: ThemeData(
        colorScheme: settings.selectedTheme.colorScheme(Brightness.light),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: settings.selectedTheme.colorScheme(Brightness.dark),
        useMaterial3: true,
      ),
      themeMode: settings.materialThemeMode,
      home: InactivityGuard(
        child: const AppGate(),
      ),
    );
  }
}
