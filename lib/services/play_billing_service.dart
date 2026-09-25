import 'dart:async';

import 'package:in_app_purchase/in_app_purchase.dart';

/// Gère l'abonnement Premium via Google Play Billing. Ne fait aucune
/// vérification de reçu côté serveur — cette application n'a pas de
/// backend, donc la confiance repose sur le SDK Google Play côté client,
/// comme le fait couramment une petite application sans infrastructure
/// dédiée. C'est moins robuste qu'une vérification serveur face à un
/// appareil rooté trafiqué, mais standard pour ce type de projet.
class PlayBillingService {
  PlayBillingService._();

  static final PlayBillingService instance = PlayBillingService._();

  /// Doit correspondre exactement à l'ID produit créé dans la Console
  /// Google Play (Monetize → Products → Subscriptions).
  static const String premiumSubscriptionId = '10e_premium_annuel';

  final InAppPurchase _iap = InAppPurchase.instance;
  StreamSubscription<List<PurchaseDetails>>? _subscription;
  void Function(bool active)? _onPremiumStatusChanged;

  bool _isAvailable = false;
  bool get isAvailable => _isAvailable;

  /// À appeler une fois au démarrage de l'application. `onPremiumStatusChanged`
  /// est rappelé chaque fois que le statut Premium change — achat réussi,
  /// restauration, ou annulation détectée.
  Future<void> initialize({
    required void Function(bool active) onPremiumStatusChanged,
  }) async {
    _onPremiumStatusChanged = onPremiumStatusChanged;
    _isAvailable = await _iap.isAvailable();

    if (!_isAvailable) return;

    _subscription = _iap.purchaseStream.listen(
      _handlePurchaseUpdates,
      onDone: () => _subscription?.cancel(),
      onError: (_) {
        // Silencieux : une erreur de flux ne doit pas faire planter l'app.
        // Le statut Premium reste celui déjà connu localement.
      },
    );
  }

  /// Récupère les informations du produit (prix localisé, description)
  /// depuis Google Play, pour affichage avant achat.
  Future<ProductDetails?> fetchProductDetails() async {
    if (!_isAvailable) return null;

    final response = await _iap.queryProductDetails({premiumSubscriptionId});

    if (response.error != null || response.productDetails.isEmpty) {
      return null;
    }

    return response.productDetails.first;
  }

  /// Lance le flux d'achat natif Google Play. Le résultat arrive de façon
  /// asynchrone via purchaseStream, pas en retour direct de cette méthode.
  Future<bool> buy(ProductDetails product) async {
    if (!_isAvailable) return false;

    final purchaseParam = PurchaseParam(productDetails: product);

    return _iap.buyNonConsumable(purchaseParam: purchaseParam);
  }

  /// Redemande à Google Play la liste des achats actifs de l'utilisateur.
  /// Requis par les règles du Play Store (bouton « Restaurer mes achats »
  /// obligatoire), et utile aussi pour revérifier le statut à chaque
  /// démarrage de l'app.
  ///
  /// Play Billing ne renvoie que les abonnements encore actifs — un
  /// abonnement expiré ou annulé n'apparaît simplement plus. Pour détecter
  /// ce cas et retirer Premium en conséquence, cette méthode attend un
  /// court délai après la demande : si aucun achat valide n'est remonté
  /// dans ce délai, le statut Premium local est désactivé. Ce délai est
  /// une approximation raisonnable en l'absence de backend pour vérifier
  /// l'état réel de façon synchrone.
  Future<void> restorePurchases() async {
    if (!_isAvailable) return;

    var matchFound = false;

    final subscription = _iap.purchaseStream.listen((purchases) {
      for (final purchase in purchases) {
        if (purchase.productID == premiumSubscriptionId &&
            (purchase.status == PurchaseStatus.purchased ||
                purchase.status == PurchaseStatus.restored)) {
          matchFound = true;
        }
      }
    });

    await _iap.restorePurchases();
    await Future<void>.delayed(const Duration(seconds: 2));
    await subscription.cancel();

    if (!matchFound) {
      _onPremiumStatusChanged?.call(false);
    }
  }

  void _handlePurchaseUpdates(List<PurchaseDetails> purchases) {
    for (final purchase in purchases) {
      if (purchase.productID != premiumSubscriptionId) continue;

      switch (purchase.status) {
        case PurchaseStatus.purchased:
        case PurchaseStatus.restored:
          _onPremiumStatusChanged?.call(true);

          if (purchase.pendingCompletePurchase) {
            _iap.completePurchase(purchase);
          }
        case PurchaseStatus.canceled:
        case PurchaseStatus.error:
          // Un achat annulé ou en erreur ne désactive pas Premium tout
          // seul : seule l'absence de l'abonnement dans une restauration
          // (aucun achat actif retrouvé) doit le faire, pour éviter de
          // couper Premium sur une simple erreur réseau passagère.
          if (purchase.pendingCompletePurchase) {
            _iap.completePurchase(purchase);
          }
        case PurchaseStatus.pending:
          break;
      }
    }
  }

  void dispose() {
    _subscription?.cancel();
    _subscription = null;
  }
}
