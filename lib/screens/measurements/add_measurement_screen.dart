import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/l10n/l10n_extension.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_gradients.dart';
import '../../core/theme/app_typography.dart';
import '../../data/models/plot_model.dart';
import '../../providers/measurement_provider.dart';
import '../../providers/plot_provider.dart';

class AddMeasurementScreen extends StatefulWidget {
  const AddMeasurementScreen({super.key, this.preselectedPlot});
  final PlotModel? preselectedPlot;

  @override
  State<AddMeasurementScreen> createState() => _AddMeasurementScreenState();
}

class _AddMeasurementScreenState extends State<AddMeasurementScreen> {
  PlotModel? _selectedPlot;
  bool _isSaving = false;

  // 7 sensor fields
  final _n = TextEditingController();
  final _p = TextEditingController();
  final _k = TextEditingController();
  final _ph = TextEditingController();
  final _moisture = TextEditingController();
  final _temp = TextEditingController();
  final _ec = TextEditingController();
  final _notes = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedPlot = widget.preselectedPlot;
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
    if (_selectedPlot == null) {
      _snack(l10n.measSelectPlotMsg);
      return;
    }

    double? parse(TextEditingController c, String field) {
      final v = double.tryParse(c.text.trim());
      if (v == null) _snack(l10n.measValidNumberField(field));
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
      await context.read<MeasurementProvider>().addMeasurement(
            plotId: _selectedPlot!.id,
            plotName: _selectedPlot!.name,
            nitrogen: n!,
            phosphorus: p!,
            potassium: k!,
            ph: ph!,
            moisture: moisture!,
            temperature: temp!,
            ec: ec!,
            notes: _notes.text.trim().isEmpty ? null : _notes.text.trim(),
          );

      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      if (mounted) _snack('${context.l10n.measSaveFailed}: $e');
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  void _snack(String msg) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));

  @override
  Widget build(BuildContext context) {
    final plots = context.watch<PlotProvider>().plots;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(context.l10n.measAdd),
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

            // Plot selector
            _Section(
              title: context.l10n.measFieldPlot,
              children: [
                if (plots.isEmpty)
                  Text(
                    context.l10n.measNoPlotsAvailable,
                    style: AppTypography.bodyMedium
                        .copyWith(color: AppColors.textSecondary),
                  )
                else
                  DropdownButtonFormField<PlotModel>(
                    initialValue: _selectedPlot,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.grass_outlined),
                      labelText: context.l10n.measSelectPlotRequired,
                    ),
                    items: plots
                        .map((p) => DropdownMenuItem(
                              value: p,
                              child: Text(p.name),
                            ))
                        .toList(),
                    onChanged: (v) => setState(() => _selectedPlot = v),
                  ),
              ],
            ),

            const SizedBox(height: 20),

            // Sensor readings
            _Section(
              title: context.l10n.measNutrientReadings,
              children: [
                _ReadingField(
                  controller: _n,
                  label: context.l10n.measNitrogen,
                  unit: 'mg/kg',
                  hint: '10 – 30',
                  color: AppColors.nitrogenColor,
                  icon: Icons.science_outlined,
                ),
                const SizedBox(height: 12),
                _ReadingField(
                  controller: _p,
                  label: context.l10n.measPhosphorus,
                  unit: 'mg/kg',
                  hint: '5 – 30',
                  color: AppColors.phosphorusColor,
                  icon: Icons.science_outlined,
                ),
                const SizedBox(height: 12),
                _ReadingField(
                  controller: _k,
                  label: context.l10n.measPotassium,
                  unit: 'mg/kg',
                  hint: '100 – 300',
                  color: AppColors.potassiumColor,
                  icon: Icons.science_outlined,
                ),
              ],
            ),

            const SizedBox(height: 20),

            _Section(
              title: context.l10n.measConditionReadings,
              children: [
                _ReadingField(
                  controller: _ph,
                  label: context.l10n.measPh,
                  unit: '',
                  hint: '6.0 – 7.5',
                  color: AppColors.phColor,
                  icon: Icons.water_drop_outlined,
                ),
                const SizedBox(height: 12),
                _ReadingField(
                  controller: _moisture,
                  label: context.l10n.measMoisture,
                  unit: '%',
                  hint: '40 – 70',
                  color: AppColors.moistureColor,
                  icon: Icons.opacity_outlined,
                ),
                const SizedBox(height: 12),
                _ReadingField(
                  controller: _temp,
                  label: context.l10n.measTemperature,
                  unit: '°C',
                  hint: '15 – 35',
                  color: AppColors.temperatureColor,
                  icon: Icons.thermostat_outlined,
                ),
                const SizedBox(height: 12),
                _ReadingField(
                  controller: _ec,
                  label: context.l10n.measEcWithAbbr,
                  unit: 'mS/cm',
                  hint: '0.2 – 1.0',
                  color: AppColors.conductivityColor,
                  icon: Icons.bolt_outlined,
                ),
              ],
            ),

            const SizedBox(height: 20),

            _Section(
              title: context.l10n.measNotesOptional,
              children: [
                TextField(
                  controller: _notes,
                  maxLines: 3,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                    hintText: context.l10n.measNotesHint,
                    prefixIcon: const Icon(Icons.notes_outlined),
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
                label: Text(
                    _isSaving ? context.l10n.actionSaving : context.l10n.measSave),
              ),
            ),

            const SizedBox(height: 16),

            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.infoLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline,
                      color: AppColors.info, size: 18),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      context.l10n.measSensorTip,
                      style: AppTypography.bodySmall
                          .copyWith(color: AppColors.info),
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
}

class _ReadingField extends StatelessWidget {
  const _ReadingField({
    required this.controller,
    required this.label,
    required this.unit,
    required this.hint,
    required this.color,
    required this.icon,
  });
  final TextEditingController controller;
  final String label;
  final String unit;
  final String hint;
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color, size: 18),
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
              hintText: context.l10n.measTypicalHint(
                  '$hint${unit.isNotEmpty ? ' $unit' : ''}'),
              suffixText: unit.isNotEmpty ? unit : null,
              contentPadding: const EdgeInsets.symmetric(
                  horizontal: 14, vertical: 12),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children,
          ),
        ),
      ],
    );
  }
}
