import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/theme/app_theme.dart';
import 'data/local/hive_service.dart';
import 'providers/measurement_provider.dart';
import 'providers/navigation_provider.dart';
import 'providers/plot_provider.dart';
import 'screens/splash/splash_screen.dart';
import 'services/sync/sync_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await HiveService.init();
  runApp(const SoilManagementApp());
}

class SoilManagementApp extends StatefulWidget {
  const SoilManagementApp({super.key});

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
      SyncService.instance.syncPending();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NavigationProvider()),
        ChangeNotifierProvider(create: (_) => PlotProvider()),
        ChangeNotifierProvider(create: (_) => MeasurementProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'AI Soil Management',
        theme: AppTheme.lightTheme,
        home: const SplashScreen(),
      ),
    );
  }
}
