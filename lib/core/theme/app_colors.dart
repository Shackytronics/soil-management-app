import 'package:flutter/material.dart';

class AppColors {
  // Primary family — deep agricultural green
  static const Color primary = Color(0xFF1B6B3A);
  static const Color primaryMid = Color(0xFF2E7D52);
  static const Color primaryLight = Color(0xFF4CAF7A);
  static const Color primaryUltraLight = Color(0xFFE8F5EE);

  // Secondary family — earthy brown
  static const Color secondary = Color(0xFF8B5E3C);
  static const Color secondaryMid = Color(0xFFA0714F);
  static const Color secondaryLight = Color(0xFFC49A6C);
  static const Color secondaryUltraLight = Color(0xFFF5EDE6);

  // Surface family
  static const Color white = Color(0xFFFFFFFF);
  static const Color background = Color(0xFFF8FAF7);
  static const Color surfaceTinted = Color(0xFFEFF5EE);
  static const Color surfaceCard = Color(0xFFFFFFFF);

  // Semantic colors
  static const Color success = Color(0xFF2E7D52);
  static const Color warning = Color(0xFFF5A623);
  static const Color danger = Color(0xFFD32F2F);
  static const Color info = Color(0xFF1976D2);

  // Semantic light variants (chip/badge backgrounds)
  static const Color successLight = Color(0xFFE8F5EE);
  static const Color warningLight = Color(0xFFFFF8E1);
  static const Color dangerLight = Color(0xFFFFEBEE);
  static const Color infoLight = Color(0xFFE3F2FD);

  // Text hierarchy
  static const Color textPrimary = Color(0xFF1A1A2E);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textHint = Color(0xFF9CA3AF);
  static const Color textOnDark = Color(0xFFFFFFFF);
  static const Color textOnDarkSecondary = Color(0xB3FFFFFF); // 70% white

  // Glass / transparent layers (used on gradient backgrounds)
  static const Color glass10 = Color(0x1AFFFFFF); // white 10%
  static const Color glass20 = Color(0x33FFFFFF); // white 20%
  static const Color glass30 = Color(0x4DFFFFFF); // white 30%
  static const Color primaryGlass10 = Color(0x1A1B6B3A);
  static const Color primaryGlass20 = Color(0x331B6B3A);

  // Borders
  static const Color border = Color(0xFFE5E7EB);
  static const Color borderLight = Color(0xFFF3F4F6);

  // Soil nutrient palette (sensor readings)
  static const Color nitrogenColor = Color(0xFF3B82F6);
  static const Color phosphorusColor = Color(0xFFF59E0B);
  static const Color potassiumColor = Color(0xFF8B5CF6);
  static const Color phColor = Color(0xFF10B981);
  static const Color moistureColor = Color(0xFF06B6D4);
  static const Color temperatureColor = Color(0xFFEF4444);
  static const Color conductivityColor = Color(0xFFF97316);
}
