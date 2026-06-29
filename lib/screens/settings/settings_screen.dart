import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/l10n/l10n_extension.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_gradients.dart';
import '../../core/theme/app_typography.dart';
import '../../providers/backend_status_provider.dart';
import '../../providers/language_provider.dart';
import '../../providers/settings_provider.dart';
import '../../providers/sync_status_provider.dart';
import 'sub_screens/about_screen.dart';
import 'sub_screens/export_settings_screen.dart';
import 'sub_screens/language_settings_screen.dart';
import 'sub_screens/sync_settings_screen.dart';
import 'sub_screens/theme_settings_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    final sync = context.watch<SyncStatusProvider>();
    final language = context.watch<LanguageProvider>();
    final backend = context.watch<BackendStatusProvider>();
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settingsTitle),
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
          _SectionLabel(l10n.settingsAppearance),
          const SizedBox(height: 10),
          _SettingsCard(
            children: [
              _NavTile(
                icon: Icons.palette_outlined,
                title: l10n.settingsTheme,
                subtitle: _themeLabel(context, settings.themeMode),
                onTap: () => _push(context, const ThemeSettingsScreen()),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // ── Sync & Data ────────────────────────────────────────────────────
          _SectionLabel(l10n.settingsSyncData),
          const SizedBox(height: 10),
          _SettingsCard(
            children: [
              _NavTile(
                icon: Icons.cloud_sync_outlined,
                title: l10n.settingsSyncSettings,
                subtitle: _syncSubtitle(context, sync, settings),
                onTap: () => _push(context, const SyncSettingsScreen()),
                trailing: _SyncDot(sync: sync),
              ),
              const Divider(height: 1),
              _NavTile(
                icon: Icons.download_rounded,
                title: l10n.settingsExportSettings,
                subtitle: settings.defaultExportFormat.toUpperCase(),
                onTap: () => _push(context, const ExportSettingsScreen()),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // ── Backend ─────────────────────────────────────────────────────────
          _SectionLabel(l10n.settingsBackend),
          const SizedBox(height: 10),
          _SettingsCard(
            children: [
              _NavTile(
                icon: Icons.dns_outlined,
                title: l10n.settingsBackendStatus,
                subtitle: _backendSubtitle(context, backend),
                trailing: _BackendDot(state: backend.state),
                onTap: backend.check,
              ),
            ],
          ),
          const SizedBox(height: 20),

          // ── General ─────────────────────────────────────────────────────────
          _SectionLabel(l10n.settingsGeneral),
          const SizedBox(height: 10),
          _SettingsCard(
            children: [
              _NavTile(
                icon: Icons.language_outlined,
                title: l10n.settingsLanguage,
                subtitle: language.isSwahili
                    ? l10n.settingsLangSwahili
                    : l10n.settingsLangEnglish,
                onTap: () => _push(context, const LanguageSettingsScreen()),
              ),
              const Divider(height: 1),
              _NavTile(
                icon: Icons.notifications_outlined,
                title: l10n.settingsNotifications,
                subtitle: l10n.settingsConfigureAlerts,
                onTap: () => _showComingSoon(context, l10n.settingsNotifications),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // ── About ──────────────────────────────────────────────────────────
          _SectionLabel(l10n.settingsAbout),
          const SizedBox(height: 10),
          _SettingsCard(
            children: [
              _NavTile(
                icon: Icons.info_outline,
                title: l10n.settingsAboutApp,
                subtitle: l10n.settingsVersion('1.0.0'),
                onTap: () => _push(context, const AboutScreen()),
              ),
            ],
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  String _themeLabel(BuildContext context, ThemeMode mode) {
    final l10n = context.l10n;
    return switch (mode) {
      ThemeMode.light => l10n.settingsThemeLight,
      ThemeMode.dark => l10n.settingsThemeDark,
      ThemeMode.system => l10n.settingsThemeSystem,
    };
  }

  String _backendSubtitle(BuildContext context, BackendStatusProvider backend) {
    final l10n = context.l10n;
    final label = switch (backend.state) {
      BackendConnectivity.online => l10n.syncConnected,
      BackendConnectivity.checking => l10n.backendChecking,
      _ => l10n.backendUnavailable,
    };
    final version = backend.apiVersion;
    final suffix = (backend.isOnline && version != null && version.isNotEmpty)
        ? ' · ${l10n.settingsVersion(version)}'
        : '';
    return '${backend.environment} · $label$suffix';
  }

  String _syncSubtitle(
    BuildContext context,
    SyncStatusProvider sync,
    SettingsProvider settings,
  ) {
    final l10n = context.l10n;
    if (!sync.isOnline) return l10n.syncOffline;
    if (sync.syncState == SyncState.syncing) return l10n.settingsSyncingEllipsis;
    if (sync.pendingCount > 0) {
      return l10n.settingsPendingCount(sync.pendingCount);
    }
    return settings.autoSync ? l10n.settingsAutoSyncOn : l10n.settingsManualOnly;
  }

  void _push(BuildContext context, Widget screen) =>
      Navigator.of(context).push(MaterialPageRoute(builder: (_) => screen));

  void _showComingSoon(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(context.l10n.comingSoon(feature))),
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

class _BackendDot extends StatelessWidget {
  const _BackendDot({required this.state});
  final BackendConnectivity state;

  @override
  Widget build(BuildContext context) {
    if (state == BackendConnectivity.checking) {
      return const SizedBox(
        width: 14,
        height: 14,
        child: CircularProgressIndicator(strokeWidth: 2),
      );
    }
    final color = switch (state) {
      BackendConnectivity.online => AppColors.success,
      BackendConnectivity.offline => AppColors.danger,
      _ => AppColors.textHint,
    };
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
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
