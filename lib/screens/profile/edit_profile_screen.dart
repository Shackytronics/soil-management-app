import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../core/l10n/l10n_extension.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_gradients.dart';
import '../../core/theme/app_typography.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late final TextEditingController _nameController;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    _nameController = TextEditingController(text: user?.displayName ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.editProfileNameEmpty)),
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      await FirebaseAuth.instance.currentUser?.updateDisplayName(name);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l10n.profileUpdated)),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${context.l10n.authSomethingWrong} $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(context.l10n.profileEdit),
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
          children: [
            const SizedBox(height: 24),

            // Avatar
            CircleAvatar(
              radius: 48,
              backgroundColor: AppColors.primaryUltraLight,
              child: Text(
                (user?.displayName?.isNotEmpty == true
                        ? user!.displayName![0]
                        : 'F')
                    .toUpperCase(),
                style: AppTypography.displayMedium.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ),

            const SizedBox(height: 32),

            TextField(
              controller: _nameController,
              textCapitalization: TextCapitalization.words,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _save(),
              decoration: InputDecoration(
                labelText: context.l10n.authFullName,
                prefixIcon: const Icon(Icons.person_outline),
              ),
            ),

            const SizedBox(height: 16),

            // Email (read-only)
            TextField(
              enabled: false,
              decoration: InputDecoration(
                labelText: context.l10n.authEmailAddress,
                hintText: user?.email ?? '',
                prefixIcon: const Icon(Icons.email_outlined),
                filled: true,
                fillColor: AppColors.surfaceTinted,
              ),
              controller: TextEditingController(text: user?.email ?? ''),
            ),

            const SizedBox(height: 8),

            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                context.l10n.editProfileEmailReadonly,
                style: AppTypography.caption,
              ),
            ),

            const SizedBox(height: 40),

            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _isSaving ? null : _save,
                child: _isSaving
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: AppColors.white,
                        ),
                      )
                    : Text(context.l10n.profileSaveChanges),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
