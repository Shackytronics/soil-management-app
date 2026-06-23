import 'dart:io';

import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../data/models/measurement_model.dart';

class ExcelExportService {
  static Future<void> shareReport({
    required List<MeasurementModel> measurements,
    required String farmerName,
  }) async {
    final file = await _buildExcel(
      measurements: measurements,
      farmerName: farmerName,
    );
    await Share.shareXFiles(
      [XFile(file.path)],
      subject: 'Soil Measurement Report – $farmerName',
    );
  }

  static Future<File> _buildExcel({
    required List<MeasurementModel> measurements,
    required String farmerName,
  }) async {
    final excel = Excel.createExcel();
    excel.rename('Sheet1', 'Soil Measurements');
    final sheet = excel['Soil Measurements'];

    final headers = [
      'Date',
      'Plot',
      'Nitrogen (mg/kg)',
      'Phosphorus (mg/kg)',
      'Potassium (mg/kg)',
      'pH',
      'Moisture (%)',
      'Temperature (°C)',
      'EC (mS/cm)',
      'Notes',
      'Synced',
    ];

    for (var col = 0; col < headers.length; col++) {
      final cell = sheet.cell(
        CellIndex.indexByColumnRow(columnIndex: col, rowIndex: 0),
      );
      cell.value = TextCellValue(headers[col]);
      cell.cellStyle = CellStyle(
        bold: true,
        backgroundColorHex: ExcelColor.fromHexString('1B6B3A'),
        fontColorHex: ExcelColor.fromHexString('FFFFFF'),
      );
    }

    for (var i = 0; i < measurements.length; i++) {
      final m = measurements[i];
      final row = i + 1;

      _setCell(sheet, 0, row, TextCellValue(_formatDate(m.recordedAt)));
      _setCell(sheet, 1, row, TextCellValue(m.plotName));
      _setCell(sheet, 2, row, DoubleCellValue(m.nitrogen));
      _setCell(sheet, 3, row, DoubleCellValue(m.phosphorus));
      _setCell(sheet, 4, row, DoubleCellValue(m.potassium));
      _setCell(sheet, 5, row, DoubleCellValue(m.ph));
      _setCell(sheet, 6, row, DoubleCellValue(m.moisture));
      _setCell(sheet, 7, row, DoubleCellValue(m.temperature));
      _setCell(sheet, 8, row, DoubleCellValue(m.ec));
      _setCell(sheet, 9, row, TextCellValue(m.notes ?? ''));
      _setCell(
          sheet, 10, row, TextCellValue(m.isSynced ? 'Yes' : 'Pending'));
    }

    // Info sheet
    excel.copy('Soil Measurements', 'Info');
    // Actually, just add a second sheet with metadata
    final info = excel['Info'];
    _setCell(info, 0, 0, TextCellValue('Exported by'));
    _setCell(info, 1, 0, TextCellValue(farmerName));
    _setCell(info, 0, 1, TextCellValue('Export date'));
    _setCell(info, 1, 1, TextCellValue(_formatDate(DateTime.now())));
    _setCell(info, 0, 2, TextCellValue('Total readings'));
    _setCell(info, 1, 2, IntCellValue(measurements.length));
    _setCell(info, 0, 3, TextCellValue('App'));
    _setCell(info, 1, 3, TextCellValue('AI Soil Management v1.0.0'));

    final bytes = excel.save();
    if (bytes == null) throw Exception('Failed to generate Excel file');

    final dir = await getApplicationDocumentsDirectory();
    final filename =
        'soil_report_${DateTime.now().millisecondsSinceEpoch}.xlsx';
    final file = File('${dir.path}/$filename');
    await file.writeAsBytes(bytes);
    return file;
  }

  static void _setCell(Sheet sheet, int col, int row, CellValue value) {
    sheet
        .cell(CellIndex.indexByColumnRow(columnIndex: col, rowIndex: row))
        .value = value;
  }

  static String _formatDate(DateTime dt) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${dt.day} ${months[dt.month - 1]} ${dt.year}';
  }
}
