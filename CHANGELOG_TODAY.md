# Changelog — Session 2026-06-23

## Files Created

### Providers
- `lib/providers/sync_status_provider.dart` — ConnectivityStatus + SyncState enums, auto-sync on network restore, onDataWritten() trigger
- `lib/providers/settings_provider.dart` — SharedPreferences-backed theme/sync/export settings, async init()

### Screens — Auth
- `lib/screens/auth/forgot_password_screen.dart` — Email entry form, inline validation, Firebase sendPasswordResetEmail, confirmation view (no user enumeration disclosure)

### Screens — Dashboard Widgets
- `lib/screens/dashboard/widgets/chart_shared.dart` — Public ChartCard and ChartEmptyState widgets
- `lib/screens/dashboard/widgets/soil_health_trend_chart.dart` — LineChart, last 14 readings, coloured dots by health threshold
- `lib/screens/dashboard/widgets/nutrient_comparison_chart.dart` — BarChart, 7 nutrient scores (N/P/K/pH/H₂O/Temp/EC)
- `lib/screens/dashboard/widgets/monthly_measurement_chart.dart` — BarChart, last 6 calendar months

### Screens — Reports
- `lib/screens/reports/export_screen.dart` — Date range + plot filters, PDF/Excel toggle, preview count banner, Export & Share

### Screens — Settings Sub-screens
- `lib/screens/settings/sub_screens/theme_settings_screen.dart` — Custom animated radio (no deprecated RadioListTile)
- `lib/screens/settings/sub_screens/sync_settings_screen.dart` — Connectivity card, auto-sync toggle, wifi-only toggle, Sync Now
- `lib/screens/settings/sub_screens/export_settings_screen.dart` — Default format picker, include-notes toggle
- `lib/screens/settings/sub_screens/about_screen.dart` — App info, tech stack, showLicensePage()

### Services — Export
- `lib/services/export/pdf_export_service.dart` — A4 landscape PDF, header, 5-metric summary box, full data table, Printing.sharePdf()
- `lib/services/export/excel_export_service.dart` — .xlsx via excel package, Save to documents dir, Share via share_plus

### Session Artifacts
- `SESSION_HANDOFF.md` — Next-session context file
- `CHANGELOG_TODAY.md` — This file

---

## Files Modified

| File | Change |
|---|---|
| `pubspec.yaml` | Added: connectivity_plus ^6.0.0, fl_chart ^0.69.0, pdf ^3.11.0, printing ^5.13.0, excel ^4.0.4, path_provider ^2.1.3, share_plus ^10.1.0, shared_preferences ^2.3.0 |
| `pubspec.lock` | Updated lock file |
| `lib/main.dart` | Pre-init SettingsProvider + SyncStatusProvider before runApp(); WidgetsBindingObserver for app resume sync; provider injection via ctx.read<SyncStatusProvider>() |
| `lib/core/theme/app_theme.dart` | Added _Dark palette and AppTheme.darkTheme |
| `lib/providers/plot_provider.dart` | Constructor injection of SyncStatusProvider; _syncStatus.onDataWritten() after addPlot/updatePlot/deletePlot |
| `lib/providers/measurement_provider.dart` | Constructor injection of SyncStatusProvider; onDataWritten() after all writes; healthTrendPoints/nutrientScores/monthlyCountData chart getters |
| `lib/services/sync/sync_service.dart` | Fixed _markLocalSynced(): removed unsafe cast<dynamic>().firstWhere(orElse: null) pattern; replaced with typed .where().isEmpty guard |
| `lib/screens/auth/login_screen.dart` | Wired "Forgot Password?" TextButton to navigate to ForgotPasswordScreen |
| `lib/screens/dashboard/dashboard_screen.dart` | Added _SyncChip to AppBar; added _AnalyticsSection with 3 charts |
| `lib/screens/reports/reports_screen.dart` | Replaced ReportPlaceholderScreen import/navigation with ExportScreen |
| `lib/screens/settings/settings_screen.dart` | Full rewrite: navigates to 4 real sub-screens; live _SyncDot |
| `lib/services/auth_services.dart` | Added sendPasswordResetEmail(String email) method |
| Platform files (linux/macos/windows) | Auto-generated from pubspec dependency changes |

---

## Features Completed

### Phase 8.5A — Connectivity-aware Sync Infrastructure
- SyncStatusProvider with connectivity_plus stream subscription
- Online/offline state management with ConnectivityStatus and SyncState enums
- Auto-sync trigger on network restoration
- Auto-sync trigger on app resume (WidgetsBindingObserver)
- Dashboard _SyncChip indicator (online/offline/syncing/synced/pending count)

### Phase 8.5B — Dashboard Analytics
- Soil Health Trend Line Chart (last 14 measurements, colour-coded dots)
- Nutrient Comparison Bar Chart (7 parameters, scored 0–100)
- Monthly Measurement Count Bar Chart (last 6 calendar months)
- All chart data computed from real MeasurementProvider state — no mock data

### Phase 8.5C — Reports Export
- ExportScreen with date range and plot filters
- PDF export: A4 landscape, branded header, summary metrics, data table
- Excel export: .xlsx with full measurement columns
- Shared via share_plus 10.1.0 (Firebase-compatible)
- Empty-set guard prevents exporting 0 records

### Phase 8.5D — Settings
- SettingsProvider persisted via SharedPreferences
- Live theme switching (Light / Dark / System) via Consumer<SettingsProvider>
- AppTheme.darkTheme fully defined
- SyncSettingsScreen, ExportSettingsScreen, AboutScreen functional
- Language + Notifications: "coming soon" SnackBar

### Phase 8.6A — Connectivity Sync Gap Fix
- onDataWritten() now called in PlotProvider and MeasurementProvider after every write
- Writes while online now trigger immediate Firestore sync
- SyncStatusProvider injected via ctx.read<>() in MultiProvider — no singleton or global locator

### Phase 8.6B — Password Reset Flow
- ForgotPasswordScreen: email validation, Firebase sendPasswordResetEmail, confirmation view
- Security: same confirmation message regardless of whether account exists (no user enumeration)
- LoginScreen "Forgot Password?" button wired (was previously a no-op)
- Navigation: push (not replace) — back button returns to Login

---

## Bugs Fixed

| ID | Location | Description | Fix Applied |
|---|---|---|---|
| QA-C1/C2 | chart widgets | Private _ChartCard/_EmptyState imported with show — illegal in Dart | Extracted to public chart_shared.dart |
| QA-C3 | pdf_export_service.dart | List<int> vs Uint8List type mismatch | Changed return type to Future<Uint8List> |
| QA-C4–C7 | pdf_export_service.dart | PdfColors.white70/white54 don't exist | Replaced with const PdfColor(1, 1, 1, 0.7/0.54) |
| QA-I1–I4 | main.dart, chart files | __ and ___ double-underscore wildcard lint | Changed to _ (Dart 3 wildcard) |
| QA-I5–I6 | theme_settings_screen.dart | RadioListTile deprecated in Flutter 3.32+ | Replaced with custom GestureDetector + AnimatedContainer |
| QA-I7 | stat_card.dart | ?trailing syntax flagged by stale build_runner cache | Confirmed valid Dart 3 syntax; build_runner cache refreshed |
| SYNC-NULL | sync_service.dart | _markLocalSynced used unsafe cast<dynamic>().firstWhere(orElse: null) | Replaced with typed where().isNotEmpty guard |
| EXPORT-TYPE | export_screen.dart | _filteredMeasurements returned List<dynamic> with double cast | Changed return type to List<MeasurementModel>; removed all .cast() calls |
| F2 | plot_provider/measurement_provider | onDataWritten() not called after writes — no immediate sync while online | Added calls after all 6 CRUD write operations |

---

## Known Issues

### BUG-01 — HIGH PRIORITY — Must Fix Before Phase 8.6C
**File:** `lib/screens/reports/export_screen.dart:70`
**Code:**
```dart
plots.firstWhere((p) => p.id == _selectedPlotId).name
```
**Risk:** This runs during every build() call. If a plot is selected as a filter and then deleted from the Plots tab (IndexedStack keeps ExportScreen alive), the next frame rebuild throws StateError: No element — crash.
**Fix needed:** Add `orElse: () => plots.first` or clear `_selectedPlotId` when PlotProvider notifies of deletion.

### BUG-02 — MEDIUM PRIORITY — Must Fix Before Phase 8.6C
**File:** `lib/screens/reports/export_screen.dart:229`
**Code:**
```dart
context.read<PlotProvider>().plots.firstWhere((p) => p.id == _selectedPlotId).name
```
**Risk:** Same pattern, triggered on Export button tap. Lower frequency than BUG-01 but same root cause.
**Fix needed:** Same guard as BUG-01.

### GAP-01 — Profile: Change Password
"Change Password" tile in ProfileScreen is a no-op tap handler. No sendPasswordResetEmail call.

### GAP-02 — Settings: Language + Notifications
Both tiles show "coming soon" SnackBar. Not wired to any functionality.

### GAP-03 — Dark Theme Visual Inconsistency
ThemeMode switching works (MaterialApp.themeMode is live-bound). However most Scaffold widgets use hardcoded AppColors.background rather than Theme.of(context).colorScheme.surface. Visual effect of dark mode is partial.

### GAP-04 — OnboardingScreen Orphaned
OnboardingScreen exists and compiles but SplashScreen navigates directly to AuthGate. No first-run flag.

### GAP-05 — Dates in Firestore as ISO Strings
recordedAt, createdAt, updatedAt stored as ISO 8601 strings, not Firestore Timestamps. Functionally correct for current read-from-Hive architecture but would break server-side date queries.

---

## Pending Tasks

1. **Fix BUG-01 and BUG-02** in export_screen.dart before next feature phase
2. **Complete device testing** on TECNO KG5j using Mobile Testing Checklist
3. **Verify sync behaviour** on physical device (Offline → Online → sync chip transitions)
4. **Verify export** on physical device (PDF opens correctly; Excel opens in WPS/Sheets)
5. **Phase 8.6C** — Dashboard Analytics (verify existing chart implementation or rebuild to spec)
6. **Phase 8.6D** — Reports Export (verify existing export implementation or rebuild to spec)
7. **Phase 9** — BLE / ESP32 integration (after production readiness confirmed)

---

## flutter analyze
```
Analyzing soil_management_app...
No issues found! (ran in 43.3s)
```
