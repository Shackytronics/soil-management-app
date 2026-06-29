import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../core/l10n/l10n_extension.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_gradients.dart';
import '../../core/theme/app_typography.dart';
import '../../services/auth_services.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = AuthService();

  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    final name = _fullNameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      _showSnack(context.l10n.authFillAllFields);
      return;
    }

    if (password.length < 6) {
      _showSnack(context.l10n.valPasswordShort);
      return;
    }

    setState(() => _isLoading = true);

    try {
      final credential = await _authService.registerUser(
        email: email,
        password: password,
      );

      // Update display name on the Firebase user profile.
      await credential.user?.updateDisplayName(name);

      // Firebase automatically signs in the user after createUserWithEmailAndPassword.
      // AuthGate detects authStateChanges and routes to MainShell. No manual navigation.
    } on FirebaseAuthException catch (e) {
      if (mounted) _showSnack(e.message ?? context.l10n.authRegisterFailed);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _goToLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),

              // Logo mark
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  gradient: AppGradients.primaryHero,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.agriculture_rounded,
                  color: AppColors.white,
                  size: 32,
                ),
              ),

              const SizedBox(height: 32),

              Text(context.l10n.authCreateAccount,
                  style: AppTypography.headingLarge),

              const SizedBox(height: 6),

              Text(
                context.l10n.authRegisterSubtitle,
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),

              const SizedBox(height: 40),

              // Full name field
              TextField(
                controller: _fullNameController,
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  labelText: context.l10n.authFullName,
                  prefixIcon: const Icon(Icons.person_outline),
                ),
              ),

              const SizedBox(height: 16),

              // Email field
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  labelText: context.l10n.authEmailAddress,
                  prefixIcon: const Icon(Icons.email_outlined),
                ),
              ),

              const SizedBox(height: 16),

              // Password field
              TextField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => _register(),
                decoration: InputDecoration(
                  labelText: context.l10n.authPassword,
                  hintText: context.l10n.authPasswordMin,
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                    ),
                    onPressed: () =>
                        setState(() => _obscurePassword = !_obscurePassword),
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Register button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _register,
                  child: _isLoading
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: AppColors.white,
                          ),
                        )
                      : Text(context.l10n.authCreateAccount),
                ),
              ),

              const SizedBox(height: 28),

              // Login link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    context.l10n.authHaveAccount,
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  TextButton(
                    onPressed: _goToLogin,
                    child: Text(context.l10n.authLoginButton),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
