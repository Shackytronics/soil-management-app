import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_gradients.dart';
import '../../core/theme/app_typography.dart';
import '../../providers/settings_provider.dart';
import '../../providers/sync_status_provider.dart';
import 'sub_screens/about_screen.dart';
import 'sub_screens/export_settings_screen.dart';
import 'sub_screens/sync_settings_screen.dart';
import 'sub_screens/theme_settings_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    final sync = context.watch<SyncStatusProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
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

          // ── Appearance ─────────────────────────────────────────────────────
          _SectionLabel('APPEARANCE'),
          const SizedBox(height: 10),
          _SettingsCard(
            children: [
              _NavTile(
                icon: Icons.palette_outlined,
                title: 'Theme',
                subtitle: settings.themeModeLabel,
                onTap: () => _push(context, const ThemeSettingsScreen()),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // ── Sync & Data ────────────────────────────────────────────────────
          _SectionLabel('SYNC & DATA'),
          const SizedBox(height: 10),
          _SettingsCard(
            children: [
              _NavTile(
                icon: Icons.cloud_sync_outlined,
                title: 'Sync Settings',
                subtitle: _syncSubtitle(sync, settings),
                onTap: () => _push(context, const SyncSettingsScreen()),
                trailing: _SyncDot(sync: sync),
              ),
              const Divider(height: 1),
              _NavTile(
                icon: Icons.download_rounded,
                title: 'Export Settings',
                subtitle: settings.defaultExportFormat.toUpperCase(),
                onTap: () => _push(context, const ExportSettingsScreen()),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // ── General ─────────────────────────────────────────────────────────
          _SectionLabel('GENERAL'),
          const SizedBox(height: 10),
          _SettingsCard(
            children: [
              _NavTile(
                icon: Icons.language_outlined,
                title: 'Language',
                subtitle: 'English (default)',
                onTap: () => _showComingSoon(context, 'Language'),
              ),
              const Divider(height: 1),
              _NavTile(
                icon: Icons.notifications_outlined,
                title: 'Notifications',
                subtitle: 'Configure alerts',
                onTap: () => _showComingSoon(context, 'Notifications'),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // ── About ──────────────────────────────────────────────────────────
          _SectionLabel('ABOUT'),
          const SizedBox(height: 10),
          _SettingsCard(
            children: [
              _NavTile(
                icon: Icons.info_outline,
                title: 'About App',
                subtitle: 'Version 1.0.0 — Phase 8.5',
                onTap: () => _push(context, const AboutScreen()),
              ),
            ],
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  String _syncSubtitle(SyncStatusProvider sync, SettingsProvider settings) {
    if (!sync.isOnline) return 'Offline';
    if (sync.syncState == SyncState.syncing) return 'Syncing…';
    if (sync.pendingCount > 0) {
      return '${sync.pendingCount} pending';
    }
    return settings.autoSync ? 'Auto sync on' : 'Manual only';
  }

  void _push(BuildContext context, Widget screen) =>
      Navigator.of(context).push(MaterialPageRoute(builder: (_) => screen));

  void _showComingSoon(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$feature settings coming soon')),
    );
  }
}

// ─── Sub-widgets ─────────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) => Text(text, style: AppTypography.overline);
}

class _SettingsCard extends StatelessWidget {
  const _SettingsCard({required this.children});
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

class _NavTile extends StatelessWidget {
  const _NavTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.trailing,
  });
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final Widget? trailing;

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
        title: Text(title, style: AppTypography.labelMedium),
        subtitle: Text(subtitle, style: AppTypography.bodySmall),
        trailing:
            trailing ?? const Icon(Icons.chevron_right, color: AppColors.textHint),
        onTap: onTap,
      );
}

class _SyncDot extends StatelessWidget {
  const _SyncDot({required this.sync});
  final SyncStatusProvider sync;

  @override
  Widget build(BuildContext context) {
    final color = switch (sync.syncState) {
      SyncState.syncing => AppColors.warning,
      SyncState.error => AppColors.danger,
      SyncState.synced => AppColors.success,
      _ => sync.isOnline ? AppColors.success : AppColors.textHint,
    };
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}
