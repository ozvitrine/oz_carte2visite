import 'dart:io';

import 'package:flutter_contacts/flutter_contacts.dart';

import '../models/business_card.dart';

class AndroidContactService {
  Future<void> saveCardAsContact(BusinessCard card) async {
    final granted = await FlutterContacts.requestPermission(
      readonly: false,
    );

    if (!granted) {
      throw const ContactPermissionException();
    }

    final nameParts = card.name
        .trim()
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .toList();

    final firstName = nameParts.isEmpty ? '' : nameParts.first;

    final lastName = nameParts.length > 1 ? nameParts.skip(1).join(' ') : '';

    final contact = Contact()
      ..name.first = firstName
      ..name.last = lastName
      ..organizations = card.company.isEmpty
          ? []
          : [
              Organization(
                company: card.company,
              ),
            ]
      ..phones = card.phone.isEmpty
          ? []
          : [
              Phone(
                card.phone,
                label: PhoneLabel.mobile,
              ),
            ]
      ..emails = card.email.isEmpty
          ? []
          : [
              Email(
                card.email,
                label: EmailLabel.work,
              ),
            ]
      ..notes = card.notes.isEmpty
          ? []
          : [
              Note(card.notes),
            ];

    // Android Contacts n'utilise qu'une photo de profil.
    // L'image recto de la carte est utilisée si elle est disponible.
    if (card.frontImagePath != null) {
      final photoFile = File(card.frontImagePath!);

      if (await photoFile.exists()) {
        contact.photo = await photoFile.readAsBytes();
      }
    }

    await FlutterContacts.insertContact(contact);
  }
}

class ContactPermissionException implements Exception {
  const ContactPermissionException();
}
