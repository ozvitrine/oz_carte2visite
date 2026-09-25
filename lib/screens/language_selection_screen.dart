import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../l10n/app_localizations.dart';
import '../state/app_settings_store.dart';

class LanguageSelectionScreen extends StatefulWidget {
  const LanguageSelectionScreen({super.key});

  @override
  State<LanguageSelectionScreen> createState() =>
      _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen> {
  // Anglais par défaut, sauf si le téléphone est réglé en français — dans
  // les deux cas, le choix reste explicite et modifiable avant de valider.
  String _selectedCode = 'en';

  @override
  void initState() {
    super.initState();

    final deviceLanguage =
        WidgetsBinding.instance.platformDispatcher.locale.languageCode;

    if (deviceLanguage == 'fr') {
      _selectedCode = 'fr';
    }
  }

  Future<void> _confirm() async {
    await context.read<AppSettingsStore>().setLocale(_selectedCode);
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                t.languageScreenTitle,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 12),
              Text(
                t.languageScreenSubtitle,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 32),
              _LanguageOption(
                label: t.languageOptionFrench,
                code: 'fr',
                selected: _selectedCode == 'fr',
                onTap: () => setState(() => _selectedCode = 'fr'),
              ),
              const SizedBox(height: 12),
              _LanguageOption(
                label: t.languageOptionEnglish,
                code: 'en',
                selected: _selectedCode == 'en',
                onTap: () => setState(() => _selectedCode = 'en'),
              ),
              const SizedBox(height: 32),
              FilledButton(
                onPressed: _confirm,
                child: Text(t.languageScreenContinue),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LanguageOption extends StatelessWidget {
  const _LanguageOption({
    required this.label,
    required this.code,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final String code;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? colors.primary : colors.outlineVariant,
            width: selected ? 2 : 1,
          ),
          color: selected ? colors.primaryContainer : null,
        ),
        child: Row(
          children: [
            Icon(
              selected
                  ? Icons.radio_button_checked
                  : Icons.radio_button_unchecked,
              color: selected ? colors.primary : colors.outline,
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      ),
    );
  }
}
