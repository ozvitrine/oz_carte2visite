import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:provider/provider.dart';

import '../l10n/app_localizations.dart';
import '../services/play_billing_service.dart';
import '../state/app_settings_store.dart';

class PersonalLicenseScreen extends StatefulWidget {
  const PersonalLicenseScreen({super.key});

  @override
  State<PersonalLicenseScreen> createState() => _PersonalLicenseScreenState();
}

class _PersonalLicenseScreenState extends State<PersonalLicenseScreen> {
  ProductDetails? _product;
  bool _isPurchasing = false;
  bool _isRestoring = false;

  @override
  void initState() {
    super.initState();
    _loadProduct();
  }

  Future<void> _loadProduct() async {
    final product = await PlayBillingService.instance.fetchProductDetails();

    if (!mounted) return;

    setState(() => _product = product);
  }

  Future<void> _subscribe() async {
    final product = _product;
    if (product == null) return;

    setState(() => _isPurchasing = true);

    try {
      await PlayBillingService.instance.buy(product);
      // Le résultat de l'achat arrive de façon asynchrone via le flux
      // d'achat, écouté globalement dans main.dart — cet écran n'a rien
      // d'autre à faire ici, l'indicateur de statut se mettra à jour tout
      // seul dès que AppSettingsStore sera notifié.
    } catch (_) {
      if (mounted) {
        _showMessage(AppLocalizations.of(context)!.licensePurchaseError);
      }
    } finally {
      if (mounted) {
        setState(() => _isPurchasing = false);
      }
    }
  }

  Future<void> _restorePurchases() async {
    setState(() => _isRestoring = true);

    try {
      await PlayBillingService.instance.restorePurchases();

      if (mounted) {
        _showMessage(AppLocalizations.of(context)!.licenseRestoreDone);
      }
    } finally {
      if (mounted) {
        setState(() => _isRestoring = false);
      }
    }
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
    final settings = context.watch<AppSettingsStore>();

    return Scaffold(
      appBar: AppBar(
        title: Text(t.licenseTitle),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: ListTile(
              leading: Icon(
                settings.isPremium
                    ? Icons.verified_outlined
                    : Icons.workspace_premium_outlined,
              ),
              title: Text(
                settings.isPremium
                    ? t.licensePlayBillingActive
                    : t.licenseNoneActive,
              ),
              subtitle: Text(
                settings.isPremium
                    ? t.licensePlayBillingSubtitle
                    : t.licenseImportHint,
              ),
            ),
          ),
          const SizedBox(height: 16),
          if (!settings.isPremium)
            FilledButton.icon(
              onPressed:
                  (_isPurchasing || _product == null) ? null : _subscribe,
              icon: _isPurchasing
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.workspace_premium_outlined),
              label: Text(
                _product != null
                    ? t.licenseSubscribeButton(_product!.price)
                    : t.licenseProductUnavailable,
              ),
            ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: _isRestoring ? null : _restorePurchases,
            icon: _isRestoring
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.restore_outlined),
            label: Text(t.licenseRestoreButton),
          ),
        ],
      ),
    );
  }
}
