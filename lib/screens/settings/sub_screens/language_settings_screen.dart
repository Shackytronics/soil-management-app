import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/l10n/l10n_extension.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_gradients.dart';
import '../../../core/theme/app_typography.dart';
import '../../../providers/language_provider.dart';

class LanguageSettingsScreen extends StatelessWidget {
  const LanguageSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final language = context.watch<LanguageProvider>();
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settingsLanguage),
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
          Text(l10n.settingsSelectLanguage, style: AppTypography.overline),
          const SizedBox(height: 12),
          _LanguageOption(
            flag: '🇹🇿',
            title: l10n.settingsLangSwahili,
            subtitle: 'Kiswahili',
            selected: language.isSwahili,
            onTap: () => language.setLanguageCode('sw'),
          ),
          _LanguageOption(
            flag: '🇬🇧',
            title: l10n.settingsLangEnglish,
            subtitle: 'English',
            selected: language.isEnglish,
            onTap: () => language.setLanguageCode('en'),
          ),
        ],
      ),
    );
  }
}

class _LanguageOption extends StatelessWidget {
  const _LanguageOption({
    required this.flag,
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  final String flag;
  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
            Text(flag, style: const TextStyle(fontSize: 26)),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTypography.labelMedium.copyWith(
                      color:
                          selected ? AppColors.primary : AppColors.textPrimary,
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
                  ? const Icon(Icons.check, color: AppColors.white, size: 12)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
