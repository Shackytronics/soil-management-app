import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppGradients {
  // Hero gradient — dashboard header, splash, onboarding
  static const LinearGradient primaryHero = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      AppColors.primary,
      AppColors.primaryMid,
      Color(0xFF1A5C32),
    ],
    stops: [0.0, 0.55, 1.0],
  );

  // Secondary hero — plot cards, earthy sections
  static const LinearGradient secondaryHero = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppColors.secondary, AppColors.secondaryMid],
  );

  // Subtle card gradient — stat cards, surface cards
  static const LinearGradient cardSubtle = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppColors.white, AppColors.surfaceTinted],
  );

  // Full-screen background (top to bottom tint)
  static const LinearGradient backgroundPage = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [AppColors.background, AppColors.surfaceTinted, AppColors.background],
    stops: [0.0, 0.5, 1.0],
  );

  // Primary button gradient
  static const LinearGradient primaryButton = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [AppColors.primary, AppColors.primaryMid],
  );

  // Semantic gradients — status indicators, chips, mini-cards
  static const LinearGradient success = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppColors.success, Color(0xFF43A069)],
  );

  static const LinearGradient warning = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppColors.warning, Color(0xFFFFC94D)],
  );

  static const LinearGradient danger = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppColors.danger, Color(0xFFE57373)],
  );

  static const LinearGradient info = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppColors.info, Color(0xFF42A5F5)],
  );

  // Soil nutrient gradients — sensor result cards
  static const LinearGradient nitrogen = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF1E40AF), AppColors.nitrogenColor],
  );

  static const LinearGradient phosphorus = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFD97706), AppColors.phosphorusColor],
  );

  static const LinearGradient potassium = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF6D28D9), AppColors.potassiumColor],
  );

  static const LinearGradient ph = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF059669), AppColors.phColor],
  );

  static const LinearGradient moisture = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF0891B2), AppColors.moistureColor],
  );

  static const LinearGradient temperature = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFB91C1C), AppColors.temperatureColor],
  );

  static const LinearGradient conductivity = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFEA580C), AppColors.conductivityColor],
  );
}
