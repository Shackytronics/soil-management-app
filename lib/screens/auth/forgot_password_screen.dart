import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../core/l10n/l10n_extension.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_gradients.dart';
import '../../core/theme/app_typography.dart';
import '../../services/auth_services.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  final _authService = AuthService();

  bool _isLoading = false;
  bool _emailSent = false;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final email = _emailController.text.trim();

    if (email.isEmpty) {
      setState(() => _errorMessage = context.l10n.authEnterEmail);
      return;
    }

    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
      setState(() => _errorMessage = context.l10n.authInvalidEmail);
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await _authService.sendPasswordResetEmail(email);
      if (mounted) setState(() => _emailSent = true);
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        setState(() => _errorMessage = e.message ?? context.l10n.authSomethingWrong);
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.white,
        iconTheme: const IconThemeData(color: AppColors.primary),
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: _emailSent ? _ConfirmationView() : _FormView(
            emailController: _emailController,
            isLoading: _isLoading,
            errorMessage: _errorMessage,
            onSubmit: _submit,
          ),
        ),
      ),
    );
  }
}

// ─── Form View ────────────────────────────────────────────────────────────────

class _FormView extends StatelessWidget {
  const _FormView({
    required this.emailController,
    required this.isLoading,
    required this.errorMessage,
    required this.onSubmit,
  });

  final TextEditingController emailController;
  final bool isLoading;
  final String? errorMessage;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),

        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            gradient: AppGradients.primaryHero,
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Icon(
            Icons.lock_reset_rounded,
            color: AppColors.white,
            size: 30,
          ),
        ),

        const SizedBox(height: 28),

        Text(context.l10n.authResetPassword, style: AppTypography.headingLarge),

        const SizedBox(height: 8),

        Text(
          context.l10n.authResetIntro,
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),

        const SizedBox(height: 36),

        TextField(
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.done,
          onSubmitted: (_) => onSubmit(),
          autofocus: true,
          decoration: InputDecoration(
            labelText: context.l10n.authEmailAddress,
            prefixIcon: const Icon(Icons.email_outlined),
            errorText: null,
          ),
        ),

        if (errorMessage != null) ...[
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.dangerLight,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: AppColors.danger.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.error_outline,
                    color: AppColors.danger, size: 18),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    errorMessage!,
                    style: AppTypography.bodySmall
                        .copyWith(color: AppColors.danger),
                  ),
                ),
              ],
            ),
          ),
        ],

        const SizedBox(height: 28),

        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: isLoading ? null : onSubmit,
            child: isLoading
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: AppColors.white,
                    ),
                  )
                : Text(context.l10n.authSendResetLink),
          ),
        ),
      ],
    );
  }
}

// ─── Confirmation View ────────────────────────────────────────────────────────

class _ConfirmationView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 48),

        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            gradient: AppGradients.primaryHero,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.mark_email_read_rounded,
            color: AppColors.white,
            size: 40,
          ),
        ),

        const SizedBox(height: 28),

        Text(
          context.l10n.authCheckEmailTitle,
          style: AppTypography.headingLarge,
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: 12),

        Text(
          context.l10n.authCheckEmailBody,
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: 12),

        Text(
          context.l10n.authCheckEmailNote,
          style: AppTypography.bodySmall.copyWith(
            color: AppColors.textHint,
          ),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: 40),

        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(context.l10n.authBackToLogin),
          ),
        ),
      ],
    );
  }
}
