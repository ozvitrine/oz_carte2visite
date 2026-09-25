import 'dart:io';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../models/business_card.dart';
import '../models/card_folder.dart';

class GlobalPdfExportService {
  Future<void> exportAllFolders({
    required List<CardFolder> folders,
    required List<BusinessCard> cards,
  }) async {
    final document = pw.Document();

    final sortedFolders = [...folders]..sort(
        (first, second) => first.name.toLowerCase().compareTo(
              second.name.toLowerCase(),
            ),
      );

    final content = <pw.Widget>[];

    for (final folder in sortedFolders) {
      final folderCards =
          cards.where((card) => card.folderId == folder.id).toList()
            ..sort(
              (first, second) => first.title.toLowerCase().compareTo(
                    second.title.toLowerCase(),
                  ),
            );

      content.add(
        pw.Header(
          level: 0,
          child: pw.Text(
            folder.name,
            style: pw.TextStyle(
              fontSize: 18,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
        ),
      );

      content.add(
        pw.Padding(
          padding: const pw.EdgeInsets.only(bottom: 10),
          child: pw.Text(
            '${folderCards.length} carte(s)',
            style: const pw.TextStyle(
              fontSize: 10,
              color: PdfColors.grey700,
            ),
          ),
        ),
      );

      if (folderCards.isEmpty) {
        content.add(
          pw.Padding(
            padding: const pw.EdgeInsets.only(bottom: 16),
            child: pw.Text(
              'Aucune carte dans ce classeur.',
              style: const pw.TextStyle(
                fontSize: 10,
                color: PdfColors.grey600,
              ),
            ),
          ),
        );
      }

      for (final card in folderCards) {
        final image = await _readImage(card.frontImagePath);

        content.add(
          pw.Container(
            margin: const pw.EdgeInsets.only(bottom: 10),
            padding: const pw.EdgeInsets.all(10),
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.grey400),
              borderRadius: pw.BorderRadius.circular(6),
            ),
            child: pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.SizedBox(
                  width: 105,
                  height: 66,
                  child: image == null
                      ? pw.Center(
                          child: pw.Text(
                            'Pas d’image',
                            style: const pw.TextStyle(
                              fontSize: 9,
                              color: PdfColors.grey600,
                            ),
                          ),
                        )
                      : pw.Image(image, fit: pw.BoxFit.contain),
                ),
                pw.SizedBox(width: 12),
                pw.Expanded(
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        card.company.isEmpty ? card.name : card.company,
                        style: pw.TextStyle(
                          fontSize: 13,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      if (card.company.isNotEmpty && card.name.isNotEmpty)
                        pw.Padding(
                          padding: const pw.EdgeInsets.only(top: 2),
                          child: pw.Text(
                            card.name,
                            style: const pw.TextStyle(fontSize: 10),
                          ),
                        ),
                      if (card.phone.isNotEmpty)
                        pw.Padding(
                          padding: const pw.EdgeInsets.only(top: 4),
                          child: pw.Text(
                            'Tél. : ${card.phone}',
                            style: const pw.TextStyle(fontSize: 9),
                          ),
                        ),
                      if (card.email.isNotEmpty)
                        pw.Padding(
                          padding: const pw.EdgeInsets.only(top: 2),
                          child: pw.Text(
                            'E-mail : ${card.email}',
                            style: const pw.TextStyle(fontSize: 9),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }

      content.add(pw.SizedBox(height: 12));
    }

    document.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(28),
        build: (_) => [
          pw.Text(
            'oz_carte2visite — Tous les classeurs',
            style: pw.TextStyle(
              fontSize: 22,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 6),
          pw.Text(
            'Export global classé par classeur et par ordre alphabétique.',
            style: const pw.TextStyle(
              fontSize: 10,
              color: PdfColors.grey700,
            ),
          ),
          pw.SizedBox(height: 18),
          ...content,
        ],
      ),
    );

    await Printing.sharePdf(
      bytes: await document.save(),
      filename: 'oz_carte2visite_tous_les_classeurs.pdf',
    );
  }

  Future<pw.MemoryImage?> _readImage(String? path) async {
    if (path == null) return null;

    final file = File(path);

    if (!await file.exists()) return null;

    try {
      return pw.MemoryImage(await file.readAsBytes());
    } on FileSystemException {
      return null;
    }
  }
}
