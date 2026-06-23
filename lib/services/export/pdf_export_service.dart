import 'dart:typed_data';

import 'package:flutter/material.dart' show DateTimeRange;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../../data/models/measurement_model.dart';

// Transparent white variants for use on the green header background.
const _white70 = PdfColor(1, 1, 1, 0.7);
const _white54 = PdfColor(1, 1, 1, 0.54);

class PdfExportService {
  static const _primary = PdfColor(0.106, 0.42, 0.227); // #1B6B3A
  static const _primaryLight = PdfColor(0.298, 0.686, 0.478); // #4CAF7A
  static const _textPrimary = PdfColor(0.102, 0.102, 0.18); // #1A1A2E
  static const _textSecondary = PdfColor(0.42, 0.447, 0.502); // #6B7280
  static const _bgRow = PdfColor(0.969, 0.98, 0.969); // #F8FAF7

  static Future<void> shareReport({
    required List<MeasurementModel> measurements,
    required String farmerName,
    DateTimeRange? dateRange,
    String? plotName,
  }) async {
    final bytes = await _buildPdf(
      measurements: measurements,
      farmerName: farmerName,
      dateRange: dateRange,
      plotName: plotName,
    );

    await Printing.sharePdf(
      bytes: bytes,
      filename: 'soil_report_${DateTime.now().millisecondsSinceEpoch}.pdf',
    );
  }

  static Future<Uint8List> _buildPdf({
    required List<MeasurementModel> measurements,
    required String farmerName,
    DateTimeRange? dateRange,
    String? plotName,
  }) async {
    final pdf = pw.Document(title: 'Soil Management Report');
    final font = await PdfGoogleFonts.nunitoRegular();
    final fontBold = await PdfGoogleFonts.nunitoBold();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4.landscape,
        margin: const pw.EdgeInsets.all(28),
        build: (context) => [
          _buildHeader(farmerName, dateRange, plotName, fontBold),
          pw.SizedBox(height: 16),
          _buildSummary(measurements, fontBold, font),
          pw.SizedBox(height: 20),
          _buildTable(measurements, font, fontBold),
        ],
      ),
    );

    return pdf.save();
  }

  static pw.Widget _buildHeader(
    String farmerName,
    DateTimeRange? range,
    String? plotName,
    pw.Font fontBold,
  ) {
    final now = DateTime.now();
    final dateStr = '${now.day} ${_month(now.month)} ${now.year}';

    return pw.Container(
      padding: const pw.EdgeInsets.all(16),
      decoration: pw.BoxDecoration(
        color: _primary,
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'Soil Management Report',
                style: pw.TextStyle(
                  font: fontBold,
                  fontSize: 18,
                  color: PdfColors.white,
                ),
              ),
              pw.SizedBox(height: 4),
              pw.Text(
                'Farmer: $farmerName',
                style: pw.TextStyle(
                  font: fontBold,
                  fontSize: 11,
                  color: PdfColors.white,
                ),
              ),
              if (plotName != null)
                pw.Text(
                  'Plot: $plotName',
                  style: pw.TextStyle(
                    font: fontBold,
                    fontSize: 11,
                    color: _white70,
                  ),
                ),
            ],
          ),
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.end,
            children: [
              pw.Text(
                'Exported: $dateStr',
                style: pw.TextStyle(
                  fontSize: 10,
                  color: _white70,
                ),
              ),
              if (range != null)
                pw.Text(
                  '${_formatDate(range.start)} – ${_formatDate(range.end)}',
                  style: pw.TextStyle(
                    fontSize: 10,
                    color: _white70,
                  ),
                ),
              pw.Text(
                'Shackytronics',
                style: pw.TextStyle(
                  fontSize: 9,
                  color: _white54,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildSummary(
    List<MeasurementModel> data,
    pw.Font fontBold,
    pw.Font font,
  ) {
    if (data.isEmpty) {
      return pw.Text('No measurements to display.',
          style: pw.TextStyle(font: font, fontSize: 11, color: _textSecondary));
    }

    final plots = data.map((m) => m.plotName).toSet().length;
    final earliest = data.map((m) => m.recordedAt).reduce(
          (a, b) => a.isBefore(b) ? a : b,
        );
    final latest = data.map((m) => m.recordedAt).reduce(
          (a, b) => a.isAfter(b) ? a : b,
        );
    final avgPh =
        data.map((m) => m.ph).reduce((a, b) => a + b) / data.length;
    final avgMoisture =
        data.map((m) => m.moisture).reduce((a, b) => a + b) / data.length;

    return pw.Container(
      padding: const pw.EdgeInsets.all(12),
      decoration: pw.BoxDecoration(
        color: _bgRow,
        borderRadius: pw.BorderRadius.circular(6),
        border: pw.Border.all(color: _primaryLight, width: 0.5),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
        children: [
          _summaryItem('Total Readings', '${data.length}', fontBold, font),
          _summaryItem('Plots', '$plots', fontBold, font),
          _summaryItem('Date Range',
              '${_formatDate(earliest)} – ${_formatDate(latest)}', fontBold, font),
          _summaryItem('Avg pH', avgPh.toStringAsFixed(1), fontBold, font),
          _summaryItem(
              'Avg Moisture', '${avgMoisture.toStringAsFixed(0)}%', fontBold, font),
        ],
      ),
    );
  }

  static pw.Widget _summaryItem(
      String label, String value, pw.Font fontBold, pw.Font font) {
    return pw.Column(
      children: [
        pw.Text(value,
            style: pw.TextStyle(font: fontBold, fontSize: 14, color: _primary)),
        pw.Text(label,
            style: pw.TextStyle(font: font, fontSize: 9, color: _textSecondary)),
      ],
    );
  }

  static pw.Widget _buildTable(
    List<MeasurementModel> data,
    pw.Font font,
    pw.Font fontBold,
  ) {
    final headers = [
      'Date', 'Plot', 'N\n(mg/kg)', 'P\n(mg/kg)', 'K\n(mg/kg)',
      'pH', 'H₂O\n(%)', 'Temp\n(°C)', 'EC\n(mS/cm)', 'Notes',
    ];

    final headerRow = pw.TableRow(
      decoration: pw.BoxDecoration(color: _primary),
      children: headers
          .map((h) => _cell(h, fontBold, PdfColors.white, isHeader: true))
          .toList(),
    );

    final dataRows = data.asMap().entries.map((e) {
      final m = e.value;
      final bg = e.key.isEven ? PdfColors.white : _bgRow;
      return pw.TableRow(
        decoration: pw.BoxDecoration(color: bg),
        children: [
          _cell(_formatDate(m.recordedAt), font, _textPrimary),
          _cell(m.plotName, font, _textPrimary),
          _cell(m.nitrogen.toStringAsFixed(1), font, _textPrimary),
          _cell(m.phosphorus.toStringAsFixed(1), font, _textPrimary),
          _cell(m.potassium.toStringAsFixed(1), font, _textPrimary),
          _cell(m.ph.toStringAsFixed(2), font, _textPrimary),
          _cell(m.moisture.toStringAsFixed(1), font, _textPrimary),
          _cell(m.temperature.toStringAsFixed(1), font, _textPrimary),
          _cell(m.ec.toStringAsFixed(3), font, _textPrimary),
          _cell(m.notes ?? '—', font, _textSecondary),
        ],
      );
    }).toList();

    return pw.Table(
      border: pw.TableBorder.symmetric(
        inside: pw.BorderSide(color: PdfColors.grey300, width: 0.5),
      ),
      columnWidths: {
        0: const pw.FixedColumnWidth(60),
        1: const pw.FlexColumnWidth(2),
        2: const pw.FixedColumnWidth(40),
        3: const pw.FixedColumnWidth(40),
        4: const pw.FixedColumnWidth(40),
        5: const pw.FixedColumnWidth(32),
        6: const pw.FixedColumnWidth(36),
        7: const pw.FixedColumnWidth(36),
        8: const pw.FixedColumnWidth(44),
        9: const pw.FlexColumnWidth(2),
      },
      children: [headerRow, ...dataRows],
    );
  }

  static pw.Widget _cell(
    String text,
    pw.Font font,
    PdfColor color, {
    bool isHeader = false,
  }) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 5),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          font: font,
          fontSize: isHeader ? 9 : 8,
          color: color,
        ),
        maxLines: 2,
      ),
    );
  }

  static String _formatDate(DateTime dt) =>
      '${dt.day} ${_month(dt.month)} ${dt.year}';

  static String _month(int m) => const [
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
      ][m - 1];
}
