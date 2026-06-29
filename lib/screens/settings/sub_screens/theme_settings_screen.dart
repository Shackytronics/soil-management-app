import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/l10n/l10n_extension.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_gradients.dart';
import '../../../core/theme/app_typography.dart';
import '../../../providers/settings_provider.dart';

class ThemeSettingsScreen extends StatelessWidget {
  const ThemeSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.themeAppearance),
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
          Text(
            l10n.settingsTheme.toUpperCase(),
            style: AppTypography.overline,
          ),
          const SizedBox(height: 12),
          _ThemeOption(
            icon: Icons.light_mode_rounded,
            title: l10n.settingsThemeLight,
            subtitle: l10n.themeLightDesc,
            value: ThemeMode.light,
            groupValue: settings.themeMode,
            onChanged: settings.setThemeMode,
          ),
          _ThemeOption(
            icon: Icons.dark_mode_rounded,
            title: l10n.settingsThemeDark,
            subtitle: l10n.themeDarkDesc,
            value: ThemeMode.dark,
            groupValue: settings.themeMode,
            onChanged: settings.setThemeMode,
          ),
          _ThemeOption(
            icon: Icons.brightness_auto_rounded,
            title: l10n.themeSystemTitle,
            subtitle: l10n.themeSystemDesc,
            value: ThemeMode.system,
            groupValue: settings.themeMode,
            onChanged: settings.setThemeMode,
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.infoLight,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                  color: AppColors.info.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline,
                    color: AppColors.info, size: 18),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    l10n.themeNote,
                    style: AppTypography.bodySmall
                        .copyWith(color: AppColors.info),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ThemeOption extends StatelessWidget {
  const _ThemeOption({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.groupValue,
    required this.onChanged,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final ThemeMode value;
  final ThemeMode groupValue;
  final ValueChanged<ThemeMode> onChanged;

  @override
  Widget build(BuildContext context) {
    final selected = value == groupValue;
    return GestureDetector(
      onTap: () => onChanged(value),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: selected ? AppColors.primaryUltraLight : AppColors.surfaceCard,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.borderLight,
            width: selected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: selected ? AppColors.primary : AppColors.textSecondary,
              size: 22,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTypography.labelMedium.copyWith(
                      color: selected
                          ? AppColors.primary
                          : AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(subtitle, style: AppTypography.bodySmall),
                ],
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: selected ? AppColors.primary : AppColors.border,
                  width: 2,
                ),
                color: selected ? AppColors.primary : Colors.transparent,
              ),
              child: selected
                  ? const Icon(Icons.check,
                      color: AppColors.white, size: 12)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
