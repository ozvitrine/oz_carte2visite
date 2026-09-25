import 'dart:io';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../models/business_card.dart';
import '../models/card_folder.dart';

class PdfExportService {
  Future<void> exportFolder({
    required CardFolder folder,
    required List<BusinessCard> cards,
  }) async {
    final sortedCards = [...cards]..sort(
        (first, second) => first.title.toLowerCase().compareTo(
              second.title.toLowerCase(),
            ),
      );

    final document = pw.Document();

    final rows = <pw.Widget>[];

    for (final card in sortedCards) {
      final frontImage = await _readImage(card.frontImagePath);

      rows.add(
        pw.Container(
          margin: const pw.EdgeInsets.only(bottom: 12),
          padding: const pw.EdgeInsets.all(12),
          decoration: pw.BoxDecoration(
            border: pw.Border.all(
              color: PdfColors.grey400,
            ),
            borderRadius: pw.BorderRadius.circular(6),
          ),
          child: pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.SizedBox(
                width: 120,
                height: 75,
                child: frontImage == null
                    ? pw.Center(
                        child: pw.Text(
                          'Pas d’image',
                          style: const pw.TextStyle(
                            fontSize: 9,
                            color: PdfColors.grey600,
                          ),
                        ),
                      )
                    : pw.Image(
                        frontImage,
                        fit: pw.BoxFit.contain,
                      ),
              ),
              pw.SizedBox(width: 14),
              pw.Expanded(
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      card.company.isEmpty ? card.name : card.company,
                      style: pw.TextStyle(
                        fontSize: 14,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    if (card.company.isNotEmpty && card.name.isNotEmpty)
                      pw.Padding(
                        padding: const pw.EdgeInsets.only(top: 3),
                        child: pw.Text(
                          card.name,
                          style: const pw.TextStyle(fontSize: 11),
                        ),
                      ),
                    if (card.phone.isNotEmpty)
                      pw.Padding(
                        padding: const pw.EdgeInsets.only(top: 4),
                        child: pw.Text(
                          'Tél. : ${card.phone}',
                          style: const pw.TextStyle(fontSize: 10),
                        ),
                      ),
                    if (card.email.isNotEmpty)
                      pw.Padding(
                        padding: const pw.EdgeInsets.only(top: 2),
                        child: pw.Text(
                          'E-mail : ${card.email}',
                          style: const pw.TextStyle(fontSize: 10),
                        ),
                      ),
                    if (card.notes.isNotEmpty)
                      pw.Padding(
                        padding: const pw.EdgeInsets.only(top: 5),
                        child: pw.Text(
                          card.notes,
                          maxLines: 3,
                          overflow: pw.TextOverflow.clip,
                          style: const pw.TextStyle(
                            fontSize: 9,
                            color: PdfColors.grey700,
                          ),
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

    document.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(28),
        build: (context) => [
          pw.Text(
            folder.name,
            style: pw.TextStyle(
              fontSize: 22,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 4),
          pw.Text(
            '${sortedCards.length} carte(s) — classement alphabétique',
            style: const pw.TextStyle(
              fontSize: 11,
              color: PdfColors.grey700,
            ),
          ),
          pw.Divider(),
          pw.SizedBox(height: 10),
          ...rows,
        ],
      ),
    );

    await Printing.sharePdf(
      bytes: await document.save(),
      filename: _fileName(folder.name),
    );
  }

  Future<pw.MemoryImage?> _readImage(String? path) async {
    if (path == null) return null;

    final file = File(path);

    if (!await file.exists()) return null;

    try {
      return pw.MemoryImage(
        await file.readAsBytes(),
      );
    } on FileSystemException {
      return null;
    }
  }

  String _fileName(String folderName) {
    final safeName = folderName
        .replaceAll(
          RegExp(r'[^a-zA-Z0-9_-]'),
          '_',
        )
        .toLowerCase();

    return 'oz_carte2visite_$safeName.pdf';
  }
}
