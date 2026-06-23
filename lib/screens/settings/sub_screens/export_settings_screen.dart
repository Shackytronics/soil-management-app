import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_gradients.dart';
import '../../../core/theme/app_typography.dart';
import '../../../providers/settings_provider.dart';

class ExportSettingsScreen extends StatelessWidget {
  const ExportSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Export Settings'),
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.white,
        iconTheme: const IconThemeData(color: AppColors.white),
        flexibleSpace: Container(
          decoration: const BoxDecoration(gradient: AppGradients.primaryHero),
        ),
      ),
      backgroundColor: AppColors.background,
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const SizedBox(height: 8),

          // ── Default format ─────────────────────────────────────────────────
          Text('DEFAULT FORMAT', style: AppTypography.overline),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _FormatChip(
                  icon: Icons.picture_as_pdf_rounded,
                  label: 'PDF',
                  subtitle: 'Printable document',
                  selected: settings.defaultExportFormat == 'pdf',
                  onTap: () => settings.setDefaultExportFormat('pdf'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _FormatChip(
                  icon: Icons.table_chart_rounded,
                  label: 'Excel',
                  subtitle: 'Spreadsheet (.xlsx)',
                  selected: settings.defaultExportFormat == 'excel',
                  onTap: () => settings.setDefaultExportFormat('excel'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // ── Content options ────────────────────────────────────────────────
          Text('CONTENT', style: AppTypography.overline),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: AppColors.surfaceCard,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.borderLight),
            ),
            child: ListTile(
              leading: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.primaryUltraLight,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.notes_rounded,
                    color: AppColors.primary, size: 20),
              ),
              title: Text('Include Notes', style: AppTypography.labelMedium),
              subtitle: Text(
                'Append measurement notes to exported reports',
                style: AppTypography.bodySmall,
              ),
              trailing: Switch(
                value: settings.exportIncludesNotes,
                onChanged: settings.setExportIncludesNotes,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FormatChip extends StatelessWidget {
  const _FormatChip({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });
  final IconData icon;
  final String label;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: selected ? AppColors.primaryUltraLight : AppColors.surfaceCard,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.borderLight,
            width: selected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(icon,
                color: selected ? AppColors.primary : AppColors.textSecondary,
                size: 28),
            const SizedBox(height: 6),
            Text(
              label,
              style: AppTypography.labelLarge.copyWith(
                color: selected ? AppColors.primary : AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: AppTypography.caption.copyWith(
                color: selected ? AppColors.primaryMid : AppColors.textHint,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
