import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class GlassCard extends StatelessWidget {
  final Widget child;
  final double blurSigma;
  final Color glassColor;
  final Color borderColor;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? width;
  final double? height;
  final VoidCallback? onTap;
  final BoxShadow? shadow;

  const GlassCard({
    super.key,
    required this.child,
    this.blurSigma = 10,
    this.glassColor = AppColors.glass20,
    this.borderColor = AppColors.glass30,
    this.borderRadius = 20,
    this.padding = const EdgeInsets.all(20),
    this.margin,
    this.width,
    this.height,
    this.onTap,
    this.shadow,
  });

  /// Lighter variant — thin glass layer over subtle backgrounds
  const GlassCard.light({
    super.key,
    required this.child,
    this.borderRadius = 20,
    this.padding = const EdgeInsets.all(20),
    this.margin,
    this.width,
    this.height,
    this.onTap,
    this.shadow,
  })  : blurSigma = 6,
        glassColor = AppColors.glass10,
        borderColor = AppColors.glass20;

  /// Strong variant — heavy blur for overlay panels
  const GlassCard.strong({
    super.key,
    required this.child,
    this.borderRadius = 20,
    this.padding = const EdgeInsets.all(20),
    this.margin,
    this.width,
    this.height,
    this.onTap,
    this.shadow,
  })  : blurSigma = 20,
        glassColor = AppColors.glass30,
        borderColor = const Color(0x66FFFFFF);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      decoration: shadow != null
          ? BoxDecoration(
              borderRadius: BorderRadius.circular(borderRadius),
              boxShadow: [shadow!],
            )
          : null,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
          child: GestureDetector(
            onTap: onTap,
            child: Container(
              padding: padding,
              decoration: BoxDecoration(
                color: glassColor,
                borderRadius: BorderRadius.circular(borderRadius),
                border: Border.all(color: borderColor, width: 1.5),
              ),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
