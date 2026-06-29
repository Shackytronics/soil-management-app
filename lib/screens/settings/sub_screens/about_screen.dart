import 'package:flutter/material.dart';

import '../../../core/l10n/l10n_extension.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_gradients.dart';
import '../../../core/theme/app_typography.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.aboutTitle),
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
          const SizedBox(height: 12),

          // App identity
          Center(
            child: Column(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    gradient: AppGradients.primaryHero,
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: const Icon(
                    Icons.agriculture_rounded,
                    color: AppColors.white,
                    size: 44,
                  ),
                ),
                const SizedBox(height: 14),
                Text(l10n.appName, style: AppTypography.headingMedium),
                const SizedBox(height: 4),
                Text(l10n.settingsVersion('1.0.0'),
                    style: AppTypography.bodySmall),
                const SizedBox(height: 2),
                Text('com.shackytronics.soilmanagementapp',
                    style: AppTypography.caption
                        .copyWith(color: AppColors.textHint)),
              ],
            ),
          ),
          const SizedBox(height: 28),

          // Developer info
          Text(l10n.aboutDeveloperSection, style: AppTypography.overline),
          const SizedBox(height: 10),
          _InfoCard(children: [
            _InfoRow(icon: Icons.developer_mode_rounded,
                label: l10n.aboutDeveloperLabel, value: 'Shackytronics'),
            const Divider(height: 1),
            _InfoRow(icon: Icons.person_rounded,
                label: l10n.aboutEngineer, value: 'Meshaki Mpenda'),
            const Divider(height: 1),
            _InfoRow(icon: Icons.location_on_rounded,
                label: l10n.aboutTargetMarket,
                value: l10n.aboutTargetMarketValue),
          ]),
          const SizedBox(height: 20),

          // Technical info
          Text(l10n.aboutTechnology, style: AppTypography.overline),
          const SizedBox(height: 10),
          _InfoCard(children: [
            _InfoRow(icon: Icons.phone_android_rounded,
                label: l10n.aboutFramework, value: 'Flutter 3.x (Dart)'),
            const Divider(height: 1),
            _InfoRow(icon: Icons.cloud_rounded,
                label: l10n.aboutCloud, value: 'Firebase Auth + Firestore'),
            const Divider(height: 1),
            _InfoRow(icon: Icons.storage_rounded,
                label: l10n.aboutLocalStorage, value: 'Hive (offline-first)'),
            const Divider(height: 1),
            _InfoRow(icon: Icons.sensors_rounded,
                label: l10n.aboutSensorLabel, value: 'ESP32 + 7-in-1 (Phase 9)'),
          ]),
          const SizedBox(height: 20),

          // Legal
          Text(l10n.aboutLegal, style: AppTypography.overline),
          const SizedBox(height: 10),
          _InfoCard(children: [
            ListTile(
              leading: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.primaryUltraLight,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.description_rounded,
                    color: AppColors.primary, size: 20),
              ),
              title: Text(l10n.aboutLicenses,
                  style: AppTypography.labelMedium),
              subtitle:
                  Text(l10n.aboutThirdParty, style: AppTypography.bodySmall),
              trailing:
                  const Icon(Icons.chevron_right, color: AppColors.textHint),
              onTap: () => showLicensePage(
                context: context,
                applicationName: l10n.appName,
                applicationVersion: '1.0.0',
                applicationLegalese: '© 2026 Shackytronics',
              ),
            ),
          ]),
          const SizedBox(height: 32),

          Center(
            child: Text(
              l10n.aboutCopyright,
              style: AppTypography.caption
                  .copyWith(color: AppColors.textHint),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
          color: AppColors.surfaceCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.borderLight),
        ),
        child: Column(children: children),
      );
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });
  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => ListTile(
        leading: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: AppColors.primaryUltraLight,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: AppColors.primary, size: 20),
        ),
        title: Text(label, style: AppTypography.labelMedium),
        subtitle: Text(value, style: AppTypography.bodySmall),
      );
}
