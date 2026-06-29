// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Soil Management';

  @override
  String get actionSave => 'Save';

  @override
  String get actionCancel => 'Cancel';

  @override
  String get actionDelete => 'Delete';

  @override
  String get actionEdit => 'Edit';

  @override
  String get actionAdd => 'Add';

  @override
  String get actionDone => 'Done';

  @override
  String get actionClear => 'Clear';

  @override
  String get actionSearch => 'Search';

  @override
  String get actionRetry => 'Retry';

  @override
  String get actionOk => 'OK';

  @override
  String get actionBack => 'Back';

  @override
  String get actionNext => 'Next';

  @override
  String get actionViewAll => 'View all';

  @override
  String get actionRefresh => 'Refresh';

  @override
  String get actionGenerate => 'Generate';

  @override
  String get labelOptional => 'Optional';

  @override
  String get labelAll => 'All';

  @override
  String get labelLoading => 'Loading…';

  @override
  String comingSoon(Object feature) {
    return '$feature settings coming soon';
  }

  @override
  String get navDashboard => 'Dashboard';

  @override
  String get navPlots => 'Plots';

  @override
  String get navMeasurements => 'Measurements';

  @override
  String get navReports => 'Reports';

  @override
  String get navProfile => 'Profile';

  @override
  String get authWelcomeBack => 'Welcome Back';

  @override
  String get authSignInToContinue => 'Sign in to continue';

  @override
  String get authCreateAccount => 'Create Account';

  @override
  String get authSignUpSubtitle => 'Start managing your soil today';

  @override
  String get authEmail => 'Email';

  @override
  String get authPassword => 'Password';

  @override
  String get authConfirmPassword => 'Confirm Password';

  @override
  String get authFullName => 'Full Name';

  @override
  String get authSignIn => 'Sign In';

  @override
  String get authSignUp => 'Sign Up';

  @override
  String get authSignOut => 'Sign Out';

  @override
  String get authForgotPassword => 'Forgot Password?';

  @override
  String get authResetPassword => 'Reset Password';

  @override
  String get authSendResetLink => 'Send Reset Link';

  @override
  String get authResetSubtitle => 'Enter your email to receive a reset link';

  @override
  String get authResetEmailSent =>
      'Password reset email sent. Check your inbox.';

  @override
  String get authNoAccount => 'Don\'t have an account?';

  @override
  String get authHaveAccount => 'Already have an account?';

  @override
  String get authSignOutConfirm => 'Are you sure you want to sign out?';

  @override
  String get valEmailRequired => 'Email is required';

  @override
  String get valEmailInvalid => 'Enter a valid email address';

  @override
  String get valPasswordRequired => 'Password is required';

  @override
  String get valPasswordShort => 'Password must be at least 6 characters';

  @override
  String get valPasswordsMismatch => 'Passwords do not match';

  @override
  String get valNameRequired => 'Name is required';

  @override
  String get valFieldRequired => 'This field is required';

  @override
  String get valNumberInvalid => 'Enter a valid number';

  @override
  String get dashGoodMorning => 'Good Morning';

  @override
  String get dashGoodAfternoon => 'Good Afternoon';

  @override
  String get dashGoodEvening => 'Good Evening';

  @override
  String get dashFarmer => 'Farmer';

  @override
  String get dashStatPlots => 'Plots';

  @override
  String get dashStatReadings => 'Readings';

  @override
  String get dashStatHealth => 'Health';

  @override
  String get dashSoilHealth => 'Soil Health';

  @override
  String get dashSoilHealthEmpty =>
      'Add your first measurement to see soil health analysis.';

  @override
  String get dashHealthGood => 'Good';

  @override
  String get dashHealthFair => 'Fair';

  @override
  String get dashHealthPoor => 'Poor';

  @override
  String get dashLatestReading => 'Latest Reading';

  @override
  String get dashMyPlots => 'My Plots';

  @override
  String get dashRecentActivity => 'Recent Activity';

  @override
  String get dashAnalytics => 'Analytics';

  @override
  String get dashQuickActions => 'Quick Actions';

  @override
  String get dashSoilAdvisory => 'Soil Advisory';

  @override
  String get actionAddPlot => 'Add Plot';

  @override
  String get dashRegisterLand => 'Register new land';

  @override
  String get actionAddMeasurement => 'Add\nMeasurement';

  @override
  String get dashManualEntry => 'Manual entry';

  @override
  String get dashConnectSensor => 'Connect\nSensor';

  @override
  String get dashBluetoothPairing => 'Bluetooth pairing';

  @override
  String get dashLiveReading => 'Live\nReading';

  @override
  String get dashStartSensor => 'Start sensor';

  @override
  String get dashSoilAdvisoryAction => 'Soil\nAdvisory';

  @override
  String get dashRuleBasedAdvice => 'Rule-based advice';

  @override
  String get dashViewAnalytics => 'View analytics';

  @override
  String get dashSettings => 'Settings';

  @override
  String get dashAppPreferences => 'App preferences';

  @override
  String get dashNeedMeasurement => 'Add a measurement to get soil advice.';

  @override
  String get syncOnline => 'Online';

  @override
  String get syncOffline => 'Offline';

  @override
  String get syncSyncing => 'Syncing';

  @override
  String get syncSynced => 'Synced';

  @override
  String get syncError => 'Error';

  @override
  String get plotsTitle => 'Plots';

  @override
  String get plotsSearch => 'Search plots…';

  @override
  String get plotAdd => 'Add Plot';

  @override
  String get plotEdit => 'Edit Plot';

  @override
  String get plotDetails => 'Plot Details';

  @override
  String get plotName => 'Plot Name';

  @override
  String get plotLocation => 'Location';

  @override
  String get plotSize => 'Size (acres)';

  @override
  String get plotCropType => 'Crop Type';

  @override
  String get plotDescription => 'Description';

  @override
  String get plotSave => 'Save Plot';

  @override
  String get plotUpdate => 'Update Plot';

  @override
  String get plotSaved => 'Plot saved';

  @override
  String get plotUpdated => 'Plot updated';

  @override
  String get plotDeleted => 'Plot deleted';

  @override
  String get plotDeleteTitle => 'Delete Plot';

  @override
  String get plotDeleteConfirm =>
      'This plot and its measurements will be removed.';

  @override
  String get plotsEmptyTitle => 'No Plots Yet';

  @override
  String get plotsEmptyBody =>
      'Register your first plot to start recording soil measurements.';

  @override
  String plotMeasurementsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count readings',
      one: '1 reading',
      zero: 'No readings',
    );
    return '$_temp0';
  }

  @override
  String plotAcres(Object count) {
    return '$count acres';
  }

  @override
  String get measTitle => 'Measurements';

  @override
  String get measAdd => 'Add Measurement';

  @override
  String get measEdit => 'Edit Measurement';

  @override
  String get measDetails => 'Measurement';

  @override
  String get measNotFound => 'Measurement not found';

  @override
  String get measSoilNutrients => 'Soil Nutrients';

  @override
  String get measSoilConditions => 'Soil Conditions';

  @override
  String get measNitrogen => 'Nitrogen (N)';

  @override
  String get measPhosphorus => 'Phosphorus (P)';

  @override
  String get measPotassium => 'Potassium (K)';

  @override
  String get measPh => 'pH Level';

  @override
  String get measMoisture => 'Moisture';

  @override
  String get measTemperature => 'Temperature';

  @override
  String get measEc => 'Electrical Conductivity';

  @override
  String get measNotes => 'Notes';

  @override
  String get measSelectPlot => 'Select Plot';

  @override
  String get measSave => 'Save Measurement';

  @override
  String get measSaved => 'Measurement saved';

  @override
  String get measUpdated => 'Measurement updated';

  @override
  String get measDeleted => 'Measurement deleted';

  @override
  String get measDeleteTitle => 'Delete Measurement';

  @override
  String get measDeleteConfirm =>
      'This measurement will be removed from local storage.';

  @override
  String get measEmptyTitle => 'No Measurements Yet';

  @override
  String get measEmptyBody =>
      'Record your first soil reading to begin tracking soil health.';

  @override
  String get measStatusOptimal => 'Optimal';

  @override
  String get measStatusNear => 'Near';

  @override
  String get measStatusOff => 'Off range';

  @override
  String measOptimalRange(Object min, Object max, Object unit) {
    return 'Optimal: $min – $max$unit';
  }

  @override
  String get measDetailsSection => 'Details';

  @override
  String get measFieldPlot => 'Plot';

  @override
  String get measFieldRecorded => 'Recorded';

  @override
  String get measSyncStatus => 'Sync Status';

  @override
  String get measSyncedToCloud => 'Synced to cloud';

  @override
  String get measPendingSync => 'Pending sync';

  @override
  String get histTitle => 'History';

  @override
  String get histSummary => 'Summary';

  @override
  String get histFilterTitle => 'Filter History';

  @override
  String get histSearchHint => 'Search by plot or notes…';

  @override
  String get histDateRange => 'Date Range';

  @override
  String get histSelectDateRange => 'Select Date Range';

  @override
  String get histClearDate => 'Clear date';

  @override
  String get histEmptyTitle => 'No History Yet';

  @override
  String get histEmptyBody =>
      'Your measurement history will appear here after you add readings.';

  @override
  String get histNoResults => 'No results match your filters';

  @override
  String histReadingsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count readings',
      one: '1 reading',
    );
    return '$_temp0';
  }

  @override
  String get histAdviceBadge => 'Advice';

  @override
  String get reportsTitle => 'Reports';

  @override
  String get reportsAvailable => 'AVAILABLE REPORTS';

  @override
  String get reportsAdvisoryTitle => 'Soil Management Advisory';

  @override
  String get reportsAdvisorySubtitle =>
      'Rule-based recommendations for your latest reading';

  @override
  String get reportsHistoryTitle => 'Measurement History';

  @override
  String get reportsHistorySubtitle =>
      'Browse all past soil readings across your plots';

  @override
  String get reportsExportTitle => 'Export Report';

  @override
  String get reportsExportSubtitle =>
      'Export to PDF or Excel with date & plot filters';

  @override
  String get reportsSensorNote =>
      'Sensor integration (Phase 9) will add real-time reading exports from your ESP32.';

  @override
  String get reportsNeedMeasurement =>
      'Add a measurement to generate soil advice.';

  @override
  String get exportTitle => 'Export Report';

  @override
  String get exportFormat => 'Format';

  @override
  String get exportIncludeNotes => 'Include notes';

  @override
  String get exportFilterPlot => 'Plot';

  @override
  String get exportFilterDate => 'Date Range';

  @override
  String get exportGenerate => 'Generate Report';

  @override
  String get exportInProgress => 'Generating report…';

  @override
  String get exportSuccess => 'Report generated';

  @override
  String get exportFailed => 'Could not generate report';

  @override
  String get exportEmpty => 'No data to export for the selected filters.';

  @override
  String get profileTitle => 'Profile';

  @override
  String get profileEdit => 'Edit Profile';

  @override
  String get profileName => 'Name';

  @override
  String get profileEmail => 'Email';

  @override
  String get profileAccountInfo => 'ACCOUNT';

  @override
  String get profileSaveChanges => 'Save Changes';

  @override
  String get profileUpdated => 'Profile updated';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsAppearance => 'APPEARANCE';

  @override
  String get settingsTheme => 'Theme';

  @override
  String get settingsThemeLight => 'Light';

  @override
  String get settingsThemeDark => 'Dark';

  @override
  String get settingsThemeSystem => 'System';

  @override
  String get settingsSelectTheme => 'Select Theme';

  @override
  String get settingsSyncData => 'SYNC & DATA';

  @override
  String get settingsSyncSettings => 'Sync Settings';

  @override
  String get settingsExportSettings => 'Export Settings';

  @override
  String get settingsGeneral => 'GENERAL';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsSelectLanguage => 'Select Language';

  @override
  String get settingsLangEnglish => 'English';

  @override
  String get settingsLangSwahili => 'Kiswahili';

  @override
  String get settingsNotifications => 'Notifications';

  @override
  String get settingsConfigureAlerts => 'Configure alerts';

  @override
  String get settingsAbout => 'ABOUT';

  @override
  String get settingsAboutApp => 'About App';

  @override
  String settingsVersion(Object version) {
    return 'Version $version';
  }

  @override
  String get settingsAutoSyncOn => 'Auto sync on';

  @override
  String get settingsManualOnly => 'Manual only';

  @override
  String get settingsSyncingEllipsis => 'Syncing…';

  @override
  String settingsPendingCount(Object count) {
    return '$count pending';
  }

  @override
  String get smTitle => 'Soil Management';

  @override
  String get smHealthStatus => 'Soil Health Status';

  @override
  String get smOverallStatus => 'Overall Status';

  @override
  String get smRecommendations => 'RECOMMENDATIONS';

  @override
  String smItemsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count items',
      one: '1 item',
    );
    return '$_temp0';
  }

  @override
  String get smGenerateAdvisory => 'Generate Advisory';

  @override
  String get smNoAdvisoryTitle => 'No Advisory Yet';

  @override
  String get smNoAdvisoryBody =>
      'Generate a rule-based soil management advisory for this measurement to see tailored recommendations.';

  @override
  String get smGenerating => 'Generating soil advisory…';

  @override
  String get smApplyingRules => 'Applying rule-based soil management analysis.';

  @override
  String get smUpdating => 'Updating advisory…';

  @override
  String get smGeneratingShort => 'Generating recommendations…';

  @override
  String get smTapToGenerate => 'Tap to generate rule-based advice';

  @override
  String smLastGenerated(Object date) {
    return 'Last generated $date';
  }

  @override
  String get smOfflineCached =>
      'You appear to be offline. Showing the last saved advisory.';

  @override
  String get smNoActionsHealthy =>
      'No actions needed. Your soil is within healthy ranges.';

  @override
  String smRecommendationCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count recommendations',
      one: '1 recommendation',
    );
    return '$_temp0';
  }

  @override
  String get smErrUnauthorized => 'Session expired. Please sign in again.';

  @override
  String get smErrServer => 'The advisory service is temporarily unavailable.';

  @override
  String get smErrBadResponse =>
      'Received an unexpected response from the server.';

  @override
  String get smErrUnknown =>
      'Something went wrong while generating the advisory.';

  @override
  String get authFillAllFields => 'Please fill all fields';

  @override
  String get authLoginFailed => 'Login failed';

  @override
  String get authRegisterFailed => 'Registration failed';

  @override
  String get authLoginSubtitle => 'Sign in to continue managing your soil';

  @override
  String get authRegisterSubtitle =>
      'Register to start managing your soil health';

  @override
  String get authEmailAddress => 'Email Address';

  @override
  String get authLoginButton => 'Login';

  @override
  String get authPasswordMin => 'Minimum 6 characters';

  @override
  String get authResetIntro =>
      'Enter your account email. We will send you a link to reset your password.';

  @override
  String get authEnterEmail => 'Please enter your email address.';

  @override
  String get authInvalidEmail => 'Please enter a valid email address.';

  @override
  String get authSomethingWrong => 'Something went wrong.';

  @override
  String get authCheckEmailTitle => 'Check Your Email';

  @override
  String get authCheckEmailBody =>
      'If an account exists for that email address, we\'ve sent a password reset link. Check your inbox and follow the instructions.';

  @override
  String get authCheckEmailNote =>
      'The link expires in 1 hour. Check your spam folder if you don\'t see it.';

  @override
  String get authBackToLogin => 'Back to Login';

  @override
  String get actionSaving => 'Saving…';

  @override
  String get plotAddNewTitle => 'Add New Plot';

  @override
  String get plotInfoSection => 'Plot Information';

  @override
  String get plotNameRequiredLabel => 'Plot Name *';

  @override
  String get plotNameHint => 'e.g. North Field, Plot A';

  @override
  String get plotLocationVillage => 'Location / Village';

  @override
  String get plotLocationHint => 'e.g. Dodoma, Arusha';

  @override
  String get plotAreaAcres => 'Area (acres)';

  @override
  String get plotAreaHint => 'e.g. 2.5';

  @override
  String get plotDescOptional => 'Description (optional)';

  @override
  String get plotDescHint => 'Any notes about this plot…';

  @override
  String get plotPrimaryCrop => 'Primary Crop';

  @override
  String get plotNameRequiredMsg => 'Plot name is required';

  @override
  String get plotSaveFailed => 'Could not save plot';

  @override
  String get plotAddFirst => 'Add First Plot';

  @override
  String get plotsNotFound => 'No plots found';

  @override
  String get plotsTryDifferent => 'Try a different search term.';

  @override
  String plotSizeBadge(Object count) {
    return '$count ac';
  }

  @override
  String get measSelectPlotRequired => 'Select Plot *';

  @override
  String get measNoPlotsAvailable => 'No plots available. Add a plot first.';

  @override
  String get measNutrientReadings => 'Soil Nutrient Readings';

  @override
  String get measConditionReadings => 'Soil Condition Readings';

  @override
  String get measNotesOptional => 'Notes (optional)';

  @override
  String get measNotesHint => 'Observations, weather conditions, etc.';

  @override
  String get measSelectPlotMsg => 'Please select a plot';

  @override
  String measValidNumberField(Object field) {
    return '$field must be a valid number';
  }

  @override
  String get measSaveFailed => 'Could not save measurement';

  @override
  String measTypicalHint(Object range) {
    return 'Typical: $range';
  }

  @override
  String get measSensorTip =>
      'Connect your ESP32 sensor via Bluetooth for automatic readings.';

  @override
  String get measEcWithAbbr => 'Electrical Conductivity (EC)';

  @override
  String get measAddReading => 'Add Reading';

  @override
  String get measSearchHint => 'Search by plot name or notes…';

  @override
  String get measFilters => 'Filters';

  @override
  String get measClearAll => 'Clear All';

  @override
  String get measFilterByPlot => 'Filter by Plot';

  @override
  String get measAllPlots => 'All Plots';

  @override
  String get measFilterByDate => 'Filter by Date Range';

  @override
  String get measClearDateFilter => 'Clear date filter';

  @override
  String get measApplyFilters => 'Apply Filters';

  @override
  String get measClearFilters => 'Clear Filters';

  @override
  String get measFiltersActive => 'Filters active';

  @override
  String get measStatTotal => 'Total';

  @override
  String get measStatAvgPh => 'Avg pH';

  @override
  String get measStatAvgMoisture => 'Avg H₂O';

  @override
  String get measStatAvgN => 'Avg N';

  @override
  String get measAddFirstReading => 'Add First Reading';

  @override
  String get measReadingsLabel => 'Readings';

  @override
  String get plotNotFound => 'Plot not found';

  @override
  String plotAddedDate(Object date) {
    return 'Added $date';
  }

  @override
  String plotDeleteNamedConfirm(Object name) {
    return 'Delete \"$name\"? All measurements for this plot will remain.';
  }

  @override
  String get plotNoReadingsYet => 'No readings yet';

  @override
  String plotAcresText(Object count) {
    return '$count acres';
  }

  @override
  String get profilePreferences => 'Preferences';

  @override
  String get profileSupport => 'Support';

  @override
  String get profileChangePassword => 'Change Password';

  @override
  String get profileHelpFaq => 'Help & FAQ';

  @override
  String get exportFiltersLabel => 'FILTERS';

  @override
  String get exportAllTime => 'All time';

  @override
  String get exportAllPlots => 'All plots';

  @override
  String get exportFormatLabel => 'FORMAT';

  @override
  String get exportPdfSubtitle => 'Share-ready document';

  @override
  String get exportExcelSubtitle => 'Spreadsheet (.xlsx)';

  @override
  String get exportPreparing => 'Preparing…';

  @override
  String get exportShare => 'Export & Share';

  @override
  String get exportNoMatch => 'No measurements match your filters';

  @override
  String get exportFailedMsg => 'Export failed';

  @override
  String exportPreviewCount(Object count, Object total) {
    return '$count of $total will be exported';
  }

  @override
  String get exportNoMatchFilters =>
      'No measurements match the selected filters';

  @override
  String get plotUpdateFailed => 'Could not update plot';

  @override
  String get measUpdateFailed => 'Could not update measurement';

  @override
  String get editProfileNameEmpty => 'Name cannot be empty';

  @override
  String get editProfileEmailReadonly => 'Email cannot be changed here.';

  @override
  String get splashTagline => 'Measure  •  Analyze  •  Manage';

  @override
  String get themeAppearance => 'Appearance';

  @override
  String get themeLightDesc => 'Always use light theme';

  @override
  String get themeDarkDesc => 'Always use dark theme';

  @override
  String get themeSystemTitle => 'System Default';

  @override
  String get themeSystemDesc => 'Follow device theme setting';

  @override
  String get themeNote =>
      'The dashboard and auth screens always use the green gradient regardless of theme.';

  @override
  String get syncSettingsTitle => 'Sync & Data';

  @override
  String get syncOptions => 'SYNC OPTIONS';

  @override
  String get syncAutoSync => 'Auto Sync';

  @override
  String get syncAutoSyncDesc => 'Sync automatically when back online';

  @override
  String get syncWifiOnly => 'Wi-Fi Only';

  @override
  String get syncWifiOnlyDesc => 'Skip sync on mobile data';

  @override
  String get syncManualSync => 'MANUAL SYNC';

  @override
  String get syncNow => 'Sync Now';

  @override
  String get syncConnected => 'Connected';

  @override
  String get syncAllSynced => 'All data is synced';

  @override
  String syncPendingItems(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count items pending sync',
      one: '1 item pending sync',
    );
    return '$_temp0';
  }

  @override
  String syncLastSynced(Object time) {
    return 'Last synced: $time';
  }

  @override
  String get syncJustNow => 'just now';

  @override
  String syncLastError(Object error) {
    return 'Last error: $error';
  }

  @override
  String get exportDefaultFormat => 'DEFAULT FORMAT';

  @override
  String get exportPdfPrintable => 'Printable document';

  @override
  String get exportContent => 'CONTENT';

  @override
  String get exportIncludeNotesTitle => 'Include Notes';

  @override
  String get exportIncludeNotesDesc =>
      'Append measurement notes to exported reports';

  @override
  String get aboutTitle => 'About';

  @override
  String get aboutDeveloperSection => 'DEVELOPER';

  @override
  String get aboutDeveloperLabel => 'Developer';

  @override
  String get aboutEngineer => 'Engineer';

  @override
  String get aboutTargetMarket => 'Target Market';

  @override
  String get aboutTargetMarketValue => 'Tanzania, East Africa';

  @override
  String get aboutTechnology => 'TECHNOLOGY';

  @override
  String get aboutFramework => 'Framework';

  @override
  String get aboutCloud => 'Cloud';

  @override
  String get aboutLocalStorage => 'Local Storage';

  @override
  String get aboutSensorLabel => 'Sensor';

  @override
  String get aboutLegal => 'LEGAL';

  @override
  String get aboutLicenses => 'Open Source Licenses';

  @override
  String get aboutThirdParty => 'Third-party packages';

  @override
  String get aboutCopyright => '© 2026 Shackytronics. All rights reserved.';

  @override
  String get sensorConnectTitle => 'Connect Sensor';

  @override
  String get sensorMeasureTitle => 'Live Measurement';

  @override
  String get sensorPairingTitle => 'BLE Sensor Pairing';

  @override
  String get sensorLiveTitle => 'Live Soil Reading';

  @override
  String get sensorConnectBody =>
      'Bluetooth Low Energy module will be implemented in a future phase. Your ESP32 sensor will appear here.';

  @override
  String get sensorLiveBody =>
      'Live measurement stream from the 7-in-1 soil sensor will be available once BLE is implemented.';

  @override
  String get sensorGoBack => 'Go Back';

  @override
  String get settingsBackend => 'BACKEND';

  @override
  String get settingsBackendStatus => 'Backend Status';

  @override
  String get backendChecking => 'Checking…';

  @override
  String get backendUnavailable => 'Unavailable';

  @override
  String get smHealthScore => 'Soil Health Score';

  @override
  String smScoreOutOf(Object score) {
    return '$score/100';
  }

  @override
  String get priorityHigh => 'High';

  @override
  String get priorityMedium => 'Medium';

  @override
  String get priorityLow => 'Low';

  @override
  String get unitMgkg => 'mg/kg';

  @override
  String get unitPercent => '%';

  @override
  String get unitCelsius => '°C';

  @override
  String get unitMscm => 'mS/cm';
}
