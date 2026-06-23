import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_gradients.dart';
import '../../../core/theme/app_typography.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
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
                Text('AI Soil Management',
                    style: AppTypography.headingMedium),
                const SizedBox(height: 4),
                Text('Version 1.0.0 — Phase 8.5',
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
          Text('DEVELOPER', style: AppTypography.overline),
          const SizedBox(height: 10),
          _InfoCard(children: [
            _InfoRow(icon: Icons.developer_mode_rounded,
                label: 'Developer', value: 'Shackytronics'),
            const Divider(height: 1),
            _InfoRow(icon: Icons.person_rounded,
                label: 'Engineer', value: 'Meshaki Mpenda'),
            const Divider(height: 1),
            _InfoRow(icon: Icons.location_on_rounded,
                label: 'Target Market', value: 'Tanzania, East Africa'),
          ]),
          const SizedBox(height: 20),

          // Technical info
          Text('TECHNOLOGY', style: AppTypography.overline),
          const SizedBox(height: 10),
          _InfoCard(children: [
            _InfoRow(icon: Icons.phone_android_rounded,
                label: 'Framework', value: 'Flutter 3.x (Dart)'),
            const Divider(height: 1),
            _InfoRow(icon: Icons.cloud_rounded,
                label: 'Cloud', value: 'Firebase Auth + Firestore'),
            const Divider(height: 1),
            _InfoRow(icon: Icons.storage_rounded,
                label: 'Local Storage', value: 'Hive (offline-first)'),
            const Divider(height: 1),
            _InfoRow(icon: Icons.sensors_rounded,
                label: 'Sensor', value: 'ESP32 + 7-in-1 (Phase 9)'),
          ]),
          const SizedBox(height: 20),

          // Legal
          Text('LEGAL', style: AppTypography.overline),
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
              title: Text('Open Source Licenses',
                  style: AppTypography.labelMedium),
              subtitle:
                  Text('Third-party packages', style: AppTypography.bodySmall),
              trailing:
                  const Icon(Icons.chevron_right, color: AppColors.textHint),
              onTap: () => showLicensePage(
                context: context,
                applicationName: 'AI Soil Management',
                applicationVersion: '1.0.0',
                applicationLegalese: '© 2026 Shackytronics',
              ),
            ),
          ]),
          const SizedBox(height: 32),

          Center(
            child: Text(
              '© 2026 Shackytronics. All rights reserved.',
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
