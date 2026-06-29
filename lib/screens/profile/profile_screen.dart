import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/l10n/l10n_extension.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_gradients.dart';
import '../../core/theme/app_typography.dart';
import '../../providers/language_provider.dart';
import '../../services/auth_services.dart';
import '../settings/sub_screens/language_settings_screen.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final l10n = context.l10n;
    final displayName = user?.displayName ?? l10n.dashFarmer;
    final email = user?.email ?? '';
    final initials = displayName.isNotEmpty
        ? displayName.trim().split(' ').map((w) => w[0]).take(2).join().toUpperCase()
        : 'F';

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.white,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: AppGradients.primaryHero,
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 40),
                      CircleAvatar(
                        radius: 44,
                        backgroundColor: AppColors.glass30,
                        child: Text(
                          initials,
                          style: AppTypography.onDarkHeadingLarge,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(displayName, style: AppTypography.onDarkHeadingSmall),
                      const SizedBox(height: 4),
                      Text(email, style: AppTypography.onDarkBodyMedium),
                    ],
                  ),
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),

                  _ProfileSection(
                    title: l10n.profileAccountInfo,
                    tiles: [
                      _ProfileTile(
                        icon: Icons.edit_outlined,
                        title: l10n.profileEdit,
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const EditProfileScreen(),
                          ),
                        ),
                      ),
                      _ProfileTile(
                        icon: Icons.lock_outline,
                        title: l10n.profileChangePassword,
                        onTap: () {},
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  _ProfileSection(
                    title: l10n.profilePreferences,
                    tiles: [
                      _ProfileTile(
                        icon: Icons.language_outlined,
                        title: l10n.settingsLanguage,
                        trailing: context.watch<LanguageProvider>().isSwahili
                            ? l10n.settingsLangSwahili
                            : l10n.settingsLangEnglish,
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const LanguageSettingsScreen(),
                          ),
                        ),
                      ),
                      _ProfileTile(
                        icon: Icons.notifications_outlined,
                        title: l10n.settingsNotifications,
                        onTap: () {},
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  _ProfileSection(
                    title: l10n.profileSupport,
                    tiles: [
                      _ProfileTile(
                        icon: Icons.help_outline,
                        title: l10n.profileHelpFaq,
                        onTap: () {},
                      ),
                      _ProfileTile(
                        icon: Icons.info_outline,
                        title: l10n.settingsAboutApp,
                        trailing: 'v1.0.0',
                        onTap: () {},
                      ),
                    ],
                  ),

                  const SizedBox(height: 28),

                  // Sign out
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: OutlinedButton.icon(
                      onPressed: () => _signOut(context),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.danger,
                        side: const BorderSide(color: AppColors.danger),
                      ),
                      icon: const Icon(Icons.logout_rounded),
                      label: Text(
                        l10n.authSignOut,
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _signOut(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      // Use the dialog's own context to pop. The dialog is pushed on the root
      // navigator, while `context` here belongs to the tab's nested navigator
      // (see MainShell._TabNavigator). Popping with the wrong context closes
      // the nested navigator instead of the dialog, so the dialog never
      // returns and sign-out never runs.
      builder: (dialogContext) => AlertDialog(
        title: Text(context.l10n.authSignOut),
        content: Text(context.l10n.authSignOutConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(context.l10n.actionCancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.danger),
            child: Text(context.l10n.authSignOut),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await AuthService().logout();
      // AuthGate detects authStateChanges (user = null) and routes to LoginScreen.
    }
  }
}

class _ProfileSection extends StatelessWidget {
  const _ProfileSection({required this.title, required this.tiles});

  final String title;
  final List<Widget> tiles;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(title.toUpperCase(), style: AppTypography.overline),
        ),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surfaceCard,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.borderLight),
          ),
          child: Column(children: tiles),
        ),
      ],
    );
  }
}

class _ProfileTile extends StatelessWidget {
  const _ProfileTile({
    required this.icon,
    required this.title,
    this.trailing,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String? trailing;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: AppColors.primaryUltraLight,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: AppColors.primary, size: 20),
      ),
      title: Text(title, style: AppTypography.bodyMedium),
      trailing: trailing != null
          ? Text(
              trailing!,
              style: AppTypography.bodySmall,
            )
          : const Icon(Icons.chevron_right, color: AppColors.textHint),
      onTap: onTap,
    );
  }
}
