import 'package:collection/collection.dart';

/// Une ligne de texte détectée, avec sa hauteur à l'écran — c'est cette
/// hauteur qui permet de repérer le nom de l'entreprise, généralement
/// imprimé plus gros que le reste sur une carte de visite.
class OcrLine {
  const OcrLine(this.text, this.height);

  final String text;
  final double height;
}

/// Résultat d'une extraction : chaque champ peut rester `null` si rien de
/// fiable n'a été trouvé.
class ExtractedCardFields {
  const ExtractedCardFields({
    this.company,
    this.name,
    this.email,
    this.phone,
  });

  final String? company;
  final String? name;
  final String? email;
  final String? phone;

  bool get isEmpty =>
      company == null && name == null && email == null && phone == null;
}

/// Extrait entreprise / nom / e-mail / téléphone depuis le texte détecté
/// par l'OCR ou le contenu d'un QR Code, et combine les deux sources.
///
/// Heuristiques utilisées :
/// - L'entreprise est la ligne de texte la plus grande visuellement, avec
///   une préférence pour les lignes tout en majuscules ; si l'adresse
///   e-mail est connue, une ligne dont le contenu correspond au nom de
///   domaine (après @) est préférée à la taille du texte.
/// - Le nom du titulaire est recherché parmi les lignes restantes, avec
///   une préférence pour celles qui correspondent à la partie de
///   l'adresse e-mail avant le @, sinon pour le motif « NOM Prénom » /
///   « Prénom NOM ».
class CardFieldExtractor {
  static final _emailPattern = RegExp(
    r'[\w.+-]+@[\w-]+\.[\w.-]+',
    caseSensitive: false,
  );

  static final _phonePattern = RegExp(
    r'(?<!\w)(?:\+?\d{1,3}[\s.,-]?)?(?:\(?\d{1,4}\)?[\s.,/-]?){2,5}\d{2,4}(?!\w)',
  );

  static final _websitePattern = RegExp(
    r'(https?:\/\/|www\.|\.fr\b|\.com\b|\.net\b|\.org\b)',
    caseSensitive: false,
  );

  static final _nameLikePattern = RegExp(
    r'\b[A-ZÀ-Ÿ]{2,}\b.*\b[A-ZÀ-Ÿ][a-zà-ÿ]+\b|\b[A-ZÀ-Ÿ][a-zà-ÿ]+\b.*\b[A-ZÀ-Ÿ]{2,}\b',
  );

  /// Extraction depuis les lignes détectées par l'OCR d'une image.
  ExtractedCardFields fromOcrLines(List<OcrLine> ocrLines) {
    final lines = ocrLines.where((l) => l.text.trim().isNotEmpty).toList();

    if (lines.isEmpty) return const ExtractedCardFields();

    final joinedText = lines.map((l) => l.text).join('\n');
    final email = _emailPattern.firstMatch(joinedText)?.group(0)?.trim();
    final phone = _phonePattern.firstMatch(joinedText)?.group(0)?.trim();

    final candidates = lines.where((l) {
      final t = l.text.trim();
      return !_isEmailLine(t) &&
          !_isPhoneLine(t) &&
          !_isWebsiteLine(t) &&
          !_isMostlyDigits(t) &&
          t.length >= 2;
    }).toList();

    final domainToken = _domainToken(email);
    final localTokens = _localTokens(email);

    final company = _pickCompany(candidates, domainToken);

    final remaining =
        candidates.where((l) => l.text.trim() != company).toList();

    final name = _pickName(remaining, localTokens);

    return ExtractedCardFields(
      company: company,
      name: name,
      email: email,
      phone: phone,
    );
  }

  /// Extraction depuis le contenu d'un QR Code. Si c'est un vCard (format
  /// standard, celui que génère aussi cette application), les champs sont
  /// lus directement plutôt que devinés — c'est plus fiable. Sinon, les
  /// mêmes heuristiques que l'OCR s'appliquent, ligne par ligne.
  ExtractedCardFields fromQrText(String text) {
    final trimmed = text.trim();

    if (trimmed.toUpperCase().startsWith('BEGIN:VCARD')) {
      final fromVCard = _fromVCard(trimmed);
      if (!fromVCard.isEmpty) return fromVCard;
    }

    final lines = trimmed
        .split(RegExp(r'\r?\n'))
        .map((line) => OcrLine(line, 1))
        .toList();

    return fromOcrLines(lines);
  }

  /// Combine deux extractions (typiquement OCR + QR). Quand les deux
  /// sources donnent une valeur différente pour un même champ, les deux
  /// sont conservées à la suite, séparées par « / », pour que
  /// l'utilisateur corrige lui-même.
  ExtractedCardFields merge(ExtractedCardFields a, ExtractedCardFields b) {
    return ExtractedCardFields(
      company: _mergeField(a.company, b.company),
      name: _mergeField(a.name, b.name),
      email: _mergeField(a.email, b.email),
      phone: _mergeField(a.phone, b.phone),
    );
  }

  String? _mergeField(String? x, String? y) {
    final xs = x?.trim() ?? '';
    final ys = y?.trim() ?? '';

    if (xs.isEmpty) return ys.isEmpty ? null : ys;
    if (ys.isEmpty) return xs;
    if (xs.toLowerCase() == ys.toLowerCase()) return xs;

    return '$xs / $ys';
  }

  String? _pickCompany(List<OcrLine> candidates, String? domainToken) {
    if (candidates.isEmpty) return null;

    if (domainToken != null) {
      final domainMatch = candidates.firstWhereOrNull(
        (l) => _normalize(l.text).contains(domainToken),
      );

      if (domainMatch != null) return domainMatch.text.trim();
    }

    final sorted = [...candidates]..sort((a, b) {
        final byHeight = b.height.compareTo(a.height);
        if (byHeight != 0) return byHeight;

        final aCaps = _isAllCaps(a.text);
        final bCaps = _isAllCaps(b.text);
        if (aCaps != bCaps) return aCaps ? -1 : 1;

        return 0;
      });

    return sorted.first.text.trim();
  }

  String? _pickName(List<OcrLine> remaining, List<String> localTokens) {
    if (remaining.isEmpty) return null;

    if (localTokens.isNotEmpty) {
      final localMatch = remaining.firstWhereOrNull((l) {
        final norm = _normalize(l.text);
        return localTokens.any((token) => norm.contains(token));
      });

      if (localMatch != null) return localMatch.text.trim();
    }

    final patternMatch = remaining.firstWhereOrNull(
      (l) => _nameLikePattern.hasMatch(l.text),
    );

    return (patternMatch ?? remaining.first).text.trim();
  }

  ExtractedCardFields _fromVCard(String content) {
    String unescape(String value) => value
        .replaceAll(r'\n', '\n')
        .replaceAll(r'\,', ',')
        .replaceAll(r'\;', ';')
        .replaceAll(r'\\', r'\');

    String? name;
    String? company;
    String? email;
    String? phone;

    for (final rawLine in content.split(RegExp(r'\r?\n'))) {
      final line = rawLine.trim();
      if (line.isEmpty) continue;

      final colonIndex = line.indexOf(':');
      if (colonIndex == -1) continue;

      final key = line.substring(0, colonIndex).toUpperCase();
      final value = unescape(line.substring(colonIndex + 1)).trim();

      if (value.isEmpty) continue;

      if (key == 'FN') {
        name ??= value;
      } else if (key == 'ORG') {
        company ??= value;
      } else if (key.startsWith('EMAIL')) {
        email ??= value;
      } else if (key.startsWith('TEL')) {
        phone ??= value;
      }
    }

    return ExtractedCardFields(
      company: company,
      name: name,
      email: email,
      phone: phone,
    );
  }

  String? _domainToken(String? email) {
    if (email == null) return null;

    final atIndex = email.indexOf('@');
    if (atIndex == -1) return null;

    final domainPart = email.substring(atIndex + 1);
    if (domainPart.isEmpty) return null;

    return domainPart.split('.').first.toLowerCase();
  }

  List<String> _localTokens(String? email) {
    if (email == null) return const [];

    final atIndex = email.indexOf('@');
    if (atIndex == -1) return const [];

    return email
        .substring(0, atIndex)
        .toLowerCase()
        .split(RegExp(r'[._\-0-9]+'))
        .where((token) => token.length >= 2)
        .toList();
  }

  String _normalize(String value) {
    return value.toLowerCase().replaceAll(RegExp(r'[^a-zà-ÿ0-9]'), '');
  }

  bool _isAllCaps(String value) {
    final trimmed = value.trim();
    return trimmed.isNotEmpty && trimmed == trimmed.toUpperCase();
  }

  bool _isEmailLine(String value) => _emailPattern.hasMatch(value);

  bool _isPhoneLine(String value) {
    final digitCount = value.replaceAll(RegExp(r'\D'), '').length;
    return _phonePattern.hasMatch(value) || digitCount >= 8;
  }

  bool _isWebsiteLine(String value) => _websitePattern.hasMatch(value);

  bool _isMostlyDigits(String value) {
    final characters = value.replaceAll(RegExp(r'\s'), '');
    if (characters.isEmpty) return true;

    final digits = characters.replaceAll(RegExp(r'\D'), '').length;
    return digits / characters.length > 0.45;
  }
}
