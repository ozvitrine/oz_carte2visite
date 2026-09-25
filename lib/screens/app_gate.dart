import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/ad_service.dart';
import '../state/app_settings_store.dart';
import '../state/card_store.dart';
import 'home_screen.dart';
import 'language_selection_screen.dart';
import 'onboarding_screen.dart';

class AppGate extends StatefulWidget {
  const AppGate({super.key});

  @override
  State<AppGate> createState() => _AppGateState();
}

class _AppGateState extends State<AppGate> {
  bool _wasOnboardingComplete = false;
  bool _didShowFirstAd = false;

  @override
  Widget build(BuildContext context) {
    final store = context.watch<CardStore>();
    final settings = context.watch<AppSettingsStore>();

    if (store.loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (!settings.localeChosen) {
      return const LanguageSelectionScreen();
    }

    if (!store.onboardingComplete) {
      _wasOnboardingComplete = false;
      return const OnboardingScreen();
    }

    if (!_wasOnboardingComplete) {
      _wasOnboardingComplete = true;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted || _didShowFirstAd) return;

        if (settings.shouldShowAds) {
          _didShowFirstAd = true;
          AdService.instance.showAppOpenAdWhenReady();
        }
      });
    }

    return const HomeScreen();
  }
}
