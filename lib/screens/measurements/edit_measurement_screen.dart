import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/l10n/l10n_extension.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_gradients.dart';
import '../../core/theme/app_typography.dart';
import '../../data/models/measurement_model.dart';
import '../../providers/measurement_provider.dart';

class EditMeasurementScreen extends StatefulWidget {
  const EditMeasurementScreen({super.key, required this.measurement});
  final MeasurementModel measurement;

  @override
  State<EditMeasurementScreen> createState() => _EditMeasurementScreenState();
}

class _EditMeasurementScreenState extends State<EditMeasurementScreen> {
  late final TextEditingController _n;
  late final TextEditingController _p;
  late final TextEditingController _k;
  late final TextEditingController _ph;
  late final TextEditingController _moisture;
  late final TextEditingController _temp;
  late final TextEditingController _ec;
  late final TextEditingController _notes;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final m = widget.measurement;
    _n = TextEditingController(text: m.nitrogen.toString());
    _p = TextEditingController(text: m.phosphorus.toString());
    _k = TextEditingController(text: m.potassium.toString());
    _ph = TextEditingController(text: m.ph.toString());
    _moisture = TextEditingController(text: m.moisture.toString());
    _temp = TextEditingController(text: m.temperature.toString());
    _ec = TextEditingController(text: m.ec.toString());
    _notes = TextEditingController(text: m.notes ?? '');
  }

  @override
  void dispose() {
    for (final c in [_n, _p, _k, _ph, _moisture, _temp, _ec, _notes]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _save() async {
    final l10n = context.l10n;
    double? parse(TextEditingController c, String field) {
      final v = double.tryParse(c.text.trim());
      if (v == null) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.measValidNumberField(field))));
      }
      return v;
    }

    final n = parse(_n, l10n.measNitrogen);
    final p = parse(_p, l10n.measPhosphorus);
    final k = parse(_k, l10n.measPotassium);
    final ph = parse(_ph, l10n.measPh);
    final moisture = parse(_moisture, l10n.measMoisture);
    final temp = parse(_temp, l10n.measTemperature);
    final ec = parse(_ec, l10n.measEc);

    if ([n, p, k, ph, moisture, temp, ec].any((v) => v == null)) return;

    setState(() => _isSaving = true);

    try {
      final updated = widget.measurement.copyWith(
        nitrogen: n,
        phosphorus: p,
        potassium: k,
        ph: ph,
        moisture: moisture,
        temperature: temp,
        ec: ec,
        notes: _notes.text.trim().isEmpty ? null : _notes.text.trim(),
        isSynced: false,
      );

      await context.read<MeasurementProvider>().updateMeasurement(updated);
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${context.l10n.measUpdateFailed}: $e')));
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(context.l10n.measEdit),
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.white,
        iconTheme: const IconThemeData(color: AppColors.white),
        flexibleSpace: Container(
          decoration: const BoxDecoration(gradient: AppGradients.primaryHero),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primaryUltraLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.grass_outlined,
                      color: AppColors.primary, size: 16),
                  const SizedBox(width: 8),
                  Text(
                    widget.measurement.plotName,
                    style: AppTypography.labelMedium
                        .copyWith(color: AppColors.primary),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            _Section(
              title: context.l10n.measSoilNutrients,
              children: [
                _ReadingField(_n, context.l10n.measNitrogen, 'mg/kg', AppColors.nitrogenColor),
                const SizedBox(height: 12),
                _ReadingField(_p, context.l10n.measPhosphorus, 'mg/kg', AppColors.phosphorusColor),
                const SizedBox(height: 12),
                _ReadingField(_k, context.l10n.measPotassium, 'mg/kg', AppColors.potassiumColor),
              ],
            ),
            const SizedBox(height: 20),
            _Section(
              title: context.l10n.measSoilConditions,
              children: [
                _ReadingField(_ph, context.l10n.measPh, '', AppColors.phColor),
                const SizedBox(height: 12),
                _ReadingField(_moisture, context.l10n.measMoisture, '%', AppColors.moistureColor),
                const SizedBox(height: 12),
                _ReadingField(_temp, context.l10n.measTemperature, '°C', AppColors.temperatureColor),
                const SizedBox(height: 12),
                _ReadingField(_ec, context.l10n.measEc, 'mS/cm', AppColors.conductivityColor),
              ],
            ),
            const SizedBox(height: 20),
            _Section(
              title: context.l10n.measNotes,
              children: [
                TextField(
                  controller: _notes,
                  maxLines: 3,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                    hintText: context.l10n.measNotesHint,
                    border: InputBorder.none,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 36),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton.icon(
                onPressed: _isSaving ? null : _save,
                icon: _isSaving
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                            strokeWidth: 2.5, color: AppColors.white),
                      )
                    : const Icon(Icons.save_outlined),
                label: Text(_isSaving
                    ? context.l10n.actionSaving
                    : context.l10n.profileSaveChanges),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReadingField extends StatelessWidget {
  const _ReadingField(this.controller, this.label, this.unit, this.color);
  final TextEditingController controller;
  final String label;
  final String unit;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: TextField(
            controller: controller,
            keyboardType:
                const TextInputType.numberWithOptions(decimal: true),
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              labelText: label,
              suffixText: unit.isNotEmpty ? unit : null,
            ),
          ),
        ),
      ],
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.children});
  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title.toUpperCase(), style: AppTypography.overline),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surfaceCard,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.borderLight),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }
}
