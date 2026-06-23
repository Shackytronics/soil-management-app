import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/theme/app_theme.dart';
import 'data/local/hive_service.dart';
import 'providers/measurement_provider.dart';
import 'providers/navigation_provider.dart';
import 'providers/plot_provider.dart';
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

  runApp(SoilManagementApp(settings: settings, syncStatus: syncStatus));
}

class SoilManagementApp extends StatefulWidget {
  const SoilManagementApp({
    super.key,
    required this.settings,
    required this.syncStatus,
  });

  final SettingsProvider settings;
  final SyncStatusProvider syncStatus;

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
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: widget.settings),
        ChangeNotifierProvider.value(value: widget.syncStatus),
        ChangeNotifierProvider(create: (_) => NavigationProvider()),
        ChangeNotifierProvider(
          create: (ctx) => PlotProvider(
            ctx.read<SyncStatusProvider>(),
          ),
        ),
        ChangeNotifierProvider(
          create: (ctx) => MeasurementProvider(
            ctx.read<SyncStatusProvider>(),
          ),
        ),
      ],
      child: Consumer<SettingsProvider>(
        builder: (_, settings, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'AI Soil Management',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: settings.themeMode,
          home: const SplashScreen(),
        ),
      ),
    );
  }
}
