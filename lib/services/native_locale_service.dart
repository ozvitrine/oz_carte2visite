import 'package:flutter/services.dart';

/// Fait suivre le choix de langue jusqu'au niveau natif Android, via
/// AppCompatDelegate.setApplicationLocales(). C'est nécessaire parce que le
/// formulaire de consentement Google (UMP) n'est pas un widget Flutter — il
/// suit la langue système configurée côté Android, pas le `locale:` de
/// MaterialApp, qui ne concerne que l'arbre de widgets Flutter.
class NativeLocaleService {
  static const _channel = MethodChannel('oz_carte2visite/app_locale');

  Future<void> setAppLocale(String languageCode) async {
    try {
      await _channel.invokeMethod<void>('setAppLocale', {
        'languageCode': languageCode,
      });
    } on PlatformException {
      // Non bloquant : l'interface Flutter reste dans la bonne langue même
      // si la partie native n'a pas pu suivre.
    } on MissingPluginException {
      // Le canal natif n'existe pas encore côté Android (build pas encore
      // à jour) — pas bloquant non plus.
    }
  }
}
