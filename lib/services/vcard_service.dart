import '../models/business_card.dart';

/// Construit le texte vCard 3.0 représentant une carte — c'est ce texte qui
/// est encodé dans le QR Code généré, et que n'importe quelle application
/// d'appareil photo sait proposer d'ajouter aux contacts.
class VCardService {
  String build(BusinessCard card) {
    final lines = <String>[
      'BEGIN:VCARD',
      'VERSION:3.0',
      'N:;${_escape(card.name)};;;',
      'FN:${_escape(card.name)}',
    ];

    if (card.company.isNotEmpty) {
      lines.add('ORG:${_escape(card.company)}');
    }

    if (card.phone.isNotEmpty) {
      lines.add('TEL;TYPE=CELL:${_escape(card.phone)}');
    }

    if (card.email.isNotEmpty) {
      lines.add('EMAIL:${_escape(card.email)}');
    }

    if (card.notes.isNotEmpty) {
      lines.add('NOTE:${_escape(card.notes)}');
    }

    lines.add('END:VCARD');

    return lines.join('\r\n');
  }

  /// Échappe les caractères réservés par le format vCard (RFC 6350) :
  /// une virgule, un point-virgule ou un retour à la ligne non échappés
  /// casseraient la lecture par l'application de contacts qui scanne le
  /// QR Code.
  String _escape(String value) {
    return value
        .replaceAll('\\', r'\\')
        .replaceAll(',', r'\,')
        .replaceAll(';', r'\;')
        .replaceAll('\n', r'\n');
  }
}
