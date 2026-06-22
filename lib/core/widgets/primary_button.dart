import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_gradients.dart';
import '../theme/app_typography.dart';

enum ButtonVariant { primary, secondary, success, danger, outline, ghost }

class PrimaryButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final ButtonVariant variant;
  final bool isLoading;
  final IconData? icon;
  final double? width;
  final double height;
  final double borderRadius;

  const PrimaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.variant = ButtonVariant.primary,
    this.isLoading = false,
    this.icon,
    this.width,
    this.height = 56,
    this.borderRadius = 16,
  });

  @override
  State<PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 90),
    );
    _scale = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  LinearGradient get _gradient => switch (widget.variant) {
        ButtonVariant.primary => AppGradients.primaryButton,
        ButtonVariant.secondary => const LinearGradient(
            colors: [AppColors.secondary, AppColors.secondaryMid],
          ),
        ButtonVariant.success => AppGradients.success,
        ButtonVariant.danger => AppGradients.danger,
        ButtonVariant.outline || ButtonVariant.ghost => const LinearGradient(
            colors: [Colors.transparent, Colors.transparent],
          ),
      };

  Color get _borderColor => switch (widget.variant) {
        ButtonVariant.outline => AppColors.primary,
        _ => Colors.transparent,
      };

  Color get _foregroundColor => switch (widget.variant) {
        ButtonVariant.outline || ButtonVariant.ghost => AppColors.primary,
        _ => AppColors.white,
      };

  List<BoxShadow>? get _shadow {
    final isFlatVariant = widget.variant == ButtonVariant.outline ||
        widget.variant == ButtonVariant.ghost;
    if (isFlatVariant || widget.onPressed == null) return null;

    final shadowColor = switch (widget.variant) {
      ButtonVariant.danger => AppColors.danger.withValues(alpha: 0.35),
      ButtonVariant.success => AppColors.success.withValues(alpha: 0.35),
      _ => AppColors.primary.withValues(alpha: 0.3),
    };

    return [
      BoxShadow(color: shadowColor, blurRadius: 14, offset: const Offset(0, 6)),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final isDisabled = widget.onPressed == null || widget.isLoading;

    return GestureDetector(
      onTapDown: isDisabled ? null : (_) => _controller.forward(),
      onTapUp: isDisabled ? null : (_) => _controller.reverse(),
      onTapCancel: isDisabled ? null : () => _controller.reverse(),
      onTap: isDisabled ? null : widget.onPressed,
      child: AnimatedBuilder(
        animation: _scale,
        builder: (context, child) =>
            Transform.scale(scale: _scale.value, child: child),
        child: AnimatedOpacity(
          opacity: isDisabled ? 0.55 : 1.0,
          duration: const Duration(milliseconds: 200),
          child: Container(
            width: widget.width ?? double.infinity,
            height: widget.height,
            decoration: BoxDecoration(
              gradient: isDisabled &&
                      widget.variant != ButtonVariant.outline &&
                      widget.variant != ButtonVariant.ghost
                  ? const LinearGradient(
                      colors: [Color(0xFFB0BEC5), Color(0xFF90A4AE)],
                    )
                  : _gradient,
              borderRadius: BorderRadius.circular(widget.borderRadius),
              border: Border.all(color: _borderColor, width: 1.5),
              boxShadow: isDisabled ? null : _shadow,
            ),
            child: Center(
              child: widget.isLoading
                  ? SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: _foregroundColor,
                      ),
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (widget.icon != null) ...[
                          Icon(widget.icon, color: _foregroundColor, size: 20),
                          const SizedBox(width: 10),
                        ],
                        Text(
                          widget.label,
                          style: AppTypography.labelLarge
                              .copyWith(color: _foregroundColor),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
