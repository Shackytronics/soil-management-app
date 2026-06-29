import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/theme/app_theme.dart';
import 'data/local/hive_service.dart';
import 'l10n/app_localizations.dart';
import 'providers/backend_status_provider.dart';
import 'providers/language_provider.dart';
import 'providers/measurement_provider.dart';
import 'providers/navigation_provider.dart';
import 'providers/plot_provider.dart';
import 'providers/recommendation_provider.dart';
import 'providers/settings_provider.dart';
import 'providers/sync_status_provider.dart';
import 'screens/splash/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await HiveService.init();

  final settings = SettingsProvider();
  await settings.init();

  final syncStatus = SyncStatusProvider();
  await syncStatus.init();

  final language = LanguageProvider()..init();

  // Probe the Django backend on startup (fire-and-forget).
  final backendStatus = BackendStatusProvider();
  unawaited(backendStatus.check());

  runApp(SoilManagementApp(
    settings: settings,
    syncStatus: syncStatus,
    language: language,
    backendStatus: backendStatus,
  ));
}

class SoilManagementApp extends StatefulWidget {
  const SoilManagementApp({
    super.key,
    required this.settings,
    required this.syncStatus,
    required this.language,
    required this.backendStatus,
  });

  final SettingsProvider settings;
  final SyncStatusProvider syncStatus;
  final LanguageProvider language;
  final BackendStatusProvider backendStatus;

  @override
  State<SoilManagementApp> createState() => _SoilManagementAppState();
}

class _SoilManagementAppState extends State<SoilManagementApp>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      widget.syncStatus.triggerSync();
      unawaited(widget.backendStatus.check());
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: widget.settings),
        ChangeNotifierProvider.value(value: widget.syncStatus),
        ChangeNotifierProvider.value(value: widget.language),
        ChangeNotifierProvider.value(value: widget.backendStatus),
        ChangeNotifierProvider(create: (_) => NavigationProvider()),
        ChangeNotifierProvider(
          create: (ctx) => PlotProvider(
            ctx.read<SyncStatusProvider>(),
          ),
        ),
        // RecommendationProvider must be created before MeasurementProvider,
        // which reads it to trigger advisory generation after a save.
        ChangeNotifierProvider(
          create: (ctx) => RecommendationProvider(
            ctx.read<SyncStatusProvider>(),
          ),
        ),
        ChangeNotifierProvider(
          create: (ctx) => MeasurementProvider(
            ctx.read<SyncStatusProvider>(),
            ctx.read<RecommendationProvider>(),
          ),
        ),
      ],
      child: Consumer2<SettingsProvider, LanguageProvider>(
        builder: (_, settings, language, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Soil Management',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: settings.themeMode,
          locale: language.locale,
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: const SplashScreen(),
        ),
      ),
    );
  }
}
