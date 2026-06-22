import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/navigation_provider.dart';
import '../screens/dashboard/dashboard_screen.dart';
import '../screens/measurements/measurements_screen.dart';
import '../screens/plots/plots_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/reports/reports_screen.dart';

class MainShell extends StatelessWidget {
  const MainShell({super.key});

  @override
  Widget build(BuildContext context) {
    final nav = context.watch<NavigationProvider>();

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        final canPop =
            nav.navigatorKeys[nav.currentIndex].currentState?.canPop() ?? false;
        if (canPop) {
          nav.navigatorKeys[nav.currentIndex].currentState?.pop();
        }
      },
      child: Scaffold(
        body: IndexedStack(
          index: nav.currentIndex,
          children: [
            _TabNavigator(
              navKey: nav.navigatorKeys[0],
              child: const DashboardScreen(),
            ),
            _TabNavigator(
              navKey: nav.navigatorKeys[1],
              child: const PlotsScreen(),
            ),
            _TabNavigator(
              navKey: nav.navigatorKeys[2],
              child: const MeasurementsScreen(),
            ),
            _TabNavigator(
              navKey: nav.navigatorKeys[3],
              child: const ReportsScreen(),
            ),
            _TabNavigator(
              navKey: nav.navigatorKeys[4],
              child: const ProfileScreen(),
            ),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: nav.currentIndex,
          onTap: nav.switchTab,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home_rounded),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.grass_outlined),
              activeIcon: Icon(Icons.grass),
              label: 'Plots',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.science_outlined),
              activeIcon: Icon(Icons.science),
              label: 'Measurements',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart_outlined),
              activeIcon: Icon(Icons.bar_chart),
              label: 'Reports',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person_rounded),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}

class _TabNavigator extends StatelessWidget {
  const _TabNavigator({required this.navKey, required this.child});

  final GlobalKey<NavigatorState> navKey;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navKey,
      onGenerateRoute: (_) => MaterialPageRoute(builder: (_) => child),
    );
  }
}
