import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_gradients.dart';
import '../../core/theme/app_typography.dart';
import '../../data/models/plot_model.dart';
import '../../providers/plot_provider.dart';

class EditPlotScreen extends StatefulWidget {
  const EditPlotScreen({super.key, required this.plot});
  final PlotModel plot;

  @override
  State<EditPlotScreen> createState() => _EditPlotScreenState();
}

class _EditPlotScreenState extends State<EditPlotScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _locationController;
  late final TextEditingController _areaController;
  late final TextEditingController _descriptionController;
  late String _selectedCrop;
  bool _isSaving = false;

  static const _crops = [
    'Maize', 'Beans', 'Cassava', 'Rice', 'Sunflower',
    'Cotton', 'Vegetables', 'Sorghum', 'Millet', 'Other',
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.plot.name);
    _locationController = TextEditingController(text: widget.plot.location);
    _areaController =
        TextEditingController(text: widget.plot.sizeAcres.toString());
    _descriptionController =
        TextEditingController(text: widget.plot.description);
    _selectedCrop = _crops.contains(widget.plot.cropType)
        ? widget.plot.cropType
        : 'Other';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    _areaController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      _snack('Plot name is required');
      return;
    }

    setState(() => _isSaving = true);

    try {
      final updated = widget.plot.copyWith(
        name: name,
        location: _locationController.text.trim(),
        sizeAcres: double.tryParse(_areaController.text.trim()) ??
            widget.plot.sizeAcres,
        description: _descriptionController.text.trim(),
        cropType: _selectedCrop,
      );

      await context.read<PlotProvider>().updatePlot(updated);
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      if (mounted) _snack('Failed to update: $e');
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  void _snack(String msg) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Edit Plot'),
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
            _Section(
              title: 'Plot Information',
              children: [
                TextField(
                  controller: _nameController,
                  textCapitalization: TextCapitalization.words,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: 'Plot Name *',
                    prefixIcon: Icon(Icons.grass_outlined),
                  ),
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: _locationController,
                  textCapitalization: TextCapitalization.words,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: 'Location / Village',
                    prefixIcon: Icon(Icons.location_on_outlined),
                  ),
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: _areaController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: 'Area (acres)',
                    prefixIcon: Icon(Icons.straighten_outlined),
                  ),
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: _descriptionController,
                  textCapitalization: TextCapitalization.sentences,
                  maxLines: 2,
                  textInputAction: TextInputAction.done,
                  decoration: const InputDecoration(
                    labelText: 'Description (optional)',
                    prefixIcon: Icon(Icons.notes_outlined),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _Section(
              title: 'Primary Crop',
              children: [
                DropdownButtonFormField<String>(
                  initialValue: _selectedCrop,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.eco_outlined),
                    labelText: 'Crop Type',
                  ),
                  items: _crops
                      .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                      .toList(),
                  onChanged: (v) =>
                      setState(() => _selectedCrop = v ?? _selectedCrop),
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
                label: Text(_isSaving ? 'Saving...' : 'Save Changes'),
              ),
            ),
          ],
        ),
      ),
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
