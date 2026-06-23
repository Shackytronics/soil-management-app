import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_gradients.dart';
import '../../../core/theme/app_typography.dart';
import '../../../providers/settings_provider.dart';
import '../../../providers/sync_status_provider.dart';

class SyncSettingsScreen extends StatelessWidget {
  const SyncSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    final sync = context.watch<SyncStatusProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sync & Data'),
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
          // ── Status card ────────────────────────────────────────────────────
          const SizedBox(height: 8),
          _StatusCard(sync: sync),
          const SizedBox(height: 24),

          // ── Sync options ───────────────────────────────────────────────────
          Text('SYNC OPTIONS', style: AppTypography.overline),
          const SizedBox(height: 12),
          _SettingsCard(
            children: [
              _SwitchTile(
                icon: Icons.sync_rounded,
                title: 'Auto Sync',
                subtitle: 'Sync automatically when back online',
                value: settings.autoSync,
                onChanged: settings.setAutoSync,
              ),
              const Divider(height: 1),
              _SwitchTile(
                icon: Icons.wifi_rounded,
                title: 'Wi-Fi Only',
                subtitle: 'Skip sync on mobile data',
                value: settings.syncOnWifiOnly,
                onChanged: settings.setSyncOnWifiOnly,
              ),
            ],
          ),
          const SizedBox(height: 24),

          // ── Manual sync ────────────────────────────────────────────────────
          Text('MANUAL SYNC', style: AppTypography.overline),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: OutlinedButton.icon(
              onPressed: sync.syncState == SyncState.syncing
                  ? null
                  : sync.triggerSync,
              icon: sync.syncState == SyncState.syncing
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.primary,
                      ),
                    )
                  : const Icon(Icons.cloud_upload_outlined),
              label: Text(
                sync.syncState == SyncState.syncing
                    ? 'Syncing…'
                    : 'Sync Now',
              ),
            ),
          ),
          if (sync.lastSyncedAt != null) ...[
            const SizedBox(height: 10),
            Center(
              child: Text(
                'Last synced: ${_formatTime(sync.lastSyncedAt!)}',
                style: AppTypography.caption.copyWith(color: AppColors.textHint),
              ),
            ),
          ],
          if (sync.syncState == SyncState.error &&
              sync.lastError != null) ...[
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.dangerLight,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                    color: AppColors.danger.withValues(alpha: 0.3)),
              ),
              child: Text(
                'Last error: ${sync.lastError}',
                style: AppTypography.caption
                    .copyWith(color: AppColors.danger),
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _formatTime(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inMinutes < 1) return 'just now';
    if (diff.inHours < 1) return '${diff.inMinutes}m ago';
    if (diff.inDays < 1) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }
}

class _StatusCard extends StatelessWidget {
  const _StatusCard({required this.sync});
  final SyncStatusProvider sync;

  @override
  Widget build(BuildContext context) {
    final isOnline = sync.isOnline;
    final pending = sync.pendingCount;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isOnline ? AppColors.successLight : AppColors.warningLight,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isOnline
              ? AppColors.success.withValues(alpha: 0.3)
              : AppColors.warning.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            isOnline ? Icons.cloud_done_rounded : Icons.cloud_off_rounded,
            color: isOnline ? AppColors.success : AppColors.warning,
            size: 32,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isOnline ? 'Connected' : 'Offline',
                  style: AppTypography.labelLarge.copyWith(
                    color:
                        isOnline ? AppColors.success : AppColors.warning,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  pending == 0
                      ? 'All data is synced'
                      : '$pending item${pending == 1 ? '' : 's'} pending sync',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textSecondary,
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

class _SwitchTile extends StatelessWidget {
  const _SwitchTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });
  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

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
        trailing: Switch(value: value, onChanged: onChanged),
      );
}
