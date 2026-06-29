import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_sw.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('sw'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Soil Management'**
  String get appName;

  /// No description provided for @actionSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get actionSave;

  /// No description provided for @actionCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get actionCancel;

  /// No description provided for @actionDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get actionDelete;

  /// No description provided for @actionEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get actionEdit;

  /// No description provided for @actionAdd.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get actionAdd;

  /// No description provided for @actionDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get actionDone;

  /// No description provided for @actionClear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get actionClear;

  /// No description provided for @actionSearch.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get actionSearch;

  /// No description provided for @actionRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get actionRetry;

  /// No description provided for @actionOk.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get actionOk;

  /// No description provided for @actionBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get actionBack;

  /// No description provided for @actionNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get actionNext;

  /// No description provided for @actionViewAll.
  ///
  /// In en, this message translates to:
  /// **'View all'**
  String get actionViewAll;

  /// No description provided for @actionRefresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get actionRefresh;

  /// No description provided for @actionGenerate.
  ///
  /// In en, this message translates to:
  /// **'Generate'**
  String get actionGenerate;

  /// No description provided for @labelOptional.
  ///
  /// In en, this message translates to:
  /// **'Optional'**
  String get labelOptional;

  /// No description provided for @labelAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get labelAll;

  /// No description provided for @labelLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading…'**
  String get labelLoading;

  /// No description provided for @comingSoon.
  ///
  /// In en, this message translates to:
  /// **'{feature} settings coming soon'**
  String comingSoon(Object feature);

  /// No description provided for @navDashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get navDashboard;

  /// No description provided for @navPlots.
  ///
  /// In en, this message translates to:
  /// **'Plots'**
  String get navPlots;

  /// No description provided for @navMeasurements.
  ///
  /// In en, this message translates to:
  /// **'Measurements'**
  String get navMeasurements;

  /// No description provided for @navReports.
  ///
  /// In en, this message translates to:
  /// **'Reports'**
  String get navReports;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// No description provided for @authWelcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back'**
  String get authWelcomeBack;

  /// No description provided for @authSignInToContinue.
  ///
  /// In en, this message translates to:
  /// **'Sign in to continue'**
  String get authSignInToContinue;

  /// No description provided for @authCreateAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get authCreateAccount;

  /// No description provided for @authSignUpSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Start managing your soil today'**
  String get authSignUpSubtitle;

  /// No description provided for @authEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get authEmail;

  /// No description provided for @authPassword.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get authPassword;

  /// No description provided for @authConfirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get authConfirmPassword;

  /// No description provided for @authFullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get authFullName;

  /// No description provided for @authSignIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get authSignIn;

  /// No description provided for @authSignUp.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get authSignUp;

  /// No description provided for @authSignOut.
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get authSignOut;

  /// No description provided for @authForgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get authForgotPassword;

  /// No description provided for @authResetPassword.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get authResetPassword;

  /// No description provided for @authSendResetLink.
  ///
  /// In en, this message translates to:
  /// **'Send Reset Link'**
  String get authSendResetLink;

  /// No description provided for @authResetSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your email to receive a reset link'**
  String get authResetSubtitle;

  /// No description provided for @authResetEmailSent.
  ///
  /// In en, this message translates to:
  /// **'Password reset email sent. Check your inbox.'**
  String get authResetEmailSent;

  /// No description provided for @authNoAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get authNoAccount;

  /// No description provided for @authHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get authHaveAccount;

  /// No description provided for @authSignOutConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to sign out?'**
  String get authSignOutConfirm;

  /// No description provided for @valEmailRequired.
  ///
  /// In en, this message translates to:
  /// **'Email is required'**
  String get valEmailRequired;

  /// No description provided for @valEmailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email address'**
  String get valEmailInvalid;

  /// No description provided for @valPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Password is required'**
  String get valPasswordRequired;

  /// No description provided for @valPasswordShort.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get valPasswordShort;

  /// No description provided for @valPasswordsMismatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get valPasswordsMismatch;

  /// No description provided for @valNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Name is required'**
  String get valNameRequired;

  /// No description provided for @valFieldRequired.
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get valFieldRequired;

  /// No description provided for @valNumberInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid number'**
  String get valNumberInvalid;

  /// No description provided for @dashGoodMorning.
  ///
  /// In en, this message translates to:
  /// **'Good Morning'**
  String get dashGoodMorning;

  /// No description provided for @dashGoodAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Good Afternoon'**
  String get dashGoodAfternoon;

  /// No description provided for @dashGoodEvening.
  ///
  /// In en, this message translates to:
  /// **'Good Evening'**
  String get dashGoodEvening;

  /// No description provided for @dashFarmer.
  ///
  /// In en, this message translates to:
  /// **'Farmer'**
  String get dashFarmer;

  /// No description provided for @dashStatPlots.
  ///
  /// In en, this message translates to:
  /// **'Plots'**
  String get dashStatPlots;

  /// No description provided for @dashStatReadings.
  ///
  /// In en, this message translates to:
  /// **'Readings'**
  String get dashStatReadings;

  /// No description provided for @dashStatHealth.
  ///
  /// In en, this message translates to:
  /// **'Health'**
  String get dashStatHealth;

  /// No description provided for @dashSoilHealth.
  ///
  /// In en, this message translates to:
  /// **'Soil Health'**
  String get dashSoilHealth;

  /// No description provided for @dashSoilHealthEmpty.
  ///
  /// In en, this message translates to:
  /// **'Add your first measurement to see soil health analysis.'**
  String get dashSoilHealthEmpty;

  /// No description provided for @dashHealthGood.
  ///
  /// In en, this message translates to:
  /// **'Good'**
  String get dashHealthGood;

  /// No description provided for @dashHealthFair.
  ///
  /// In en, this message translates to:
  /// **'Fair'**
  String get dashHealthFair;

  /// No description provided for @dashHealthPoor.
  ///
  /// In en, this message translates to:
  /// **'Poor'**
  String get dashHealthPoor;

  /// No description provided for @dashLatestReading.
  ///
  /// In en, this message translates to:
  /// **'Latest Reading'**
  String get dashLatestReading;

  /// No description provided for @dashMyPlots.
  ///
  /// In en, this message translates to:
  /// **'My Plots'**
  String get dashMyPlots;

  /// No description provided for @dashRecentActivity.
  ///
  /// In en, this message translates to:
  /// **'Recent Activity'**
  String get dashRecentActivity;

  /// No description provided for @dashAnalytics.
  ///
  /// In en, this message translates to:
  /// **'Analytics'**
  String get dashAnalytics;

  /// No description provided for @dashQuickActions.
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get dashQuickActions;

  /// No description provided for @dashSoilAdvisory.
  ///
  /// In en, this message translates to:
  /// **'Soil Advisory'**
  String get dashSoilAdvisory;

  /// No description provided for @actionAddPlot.
  ///
  /// In en, this message translates to:
  /// **'Add Plot'**
  String get actionAddPlot;

  /// No description provided for @dashRegisterLand.
  ///
  /// In en, this message translates to:
  /// **'Register new land'**
  String get dashRegisterLand;

  /// No description provided for @actionAddMeasurement.
  ///
  /// In en, this message translates to:
  /// **'Add\nMeasurement'**
  String get actionAddMeasurement;

  /// No description provided for @dashManualEntry.
  ///
  /// In en, this message translates to:
  /// **'Manual entry'**
  String get dashManualEntry;

  /// No description provided for @dashConnectSensor.
  ///
  /// In en, this message translates to:
  /// **'Connect\nSensor'**
  String get dashConnectSensor;

  /// No description provided for @dashBluetoothPairing.
  ///
  /// In en, this message translates to:
  /// **'Bluetooth pairing'**
  String get dashBluetoothPairing;

  /// No description provided for @dashLiveReading.
  ///
  /// In en, this message translates to:
  /// **'Live\nReading'**
  String get dashLiveReading;

  /// No description provided for @dashStartSensor.
  ///
  /// In en, this message translates to:
  /// **'Start sensor'**
  String get dashStartSensor;

  /// No description provided for @dashSoilAdvisoryAction.
  ///
  /// In en, this message translates to:
  /// **'Soil\nAdvisory'**
  String get dashSoilAdvisoryAction;

  /// No description provided for @dashRuleBasedAdvice.
  ///
  /// In en, this message translates to:
  /// **'Rule-based advice'**
  String get dashRuleBasedAdvice;

  /// No description provided for @dashViewAnalytics.
  ///
  /// In en, this message translates to:
  /// **'View analytics'**
  String get dashViewAnalytics;

  /// No description provided for @dashSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get dashSettings;

  /// No description provided for @dashAppPreferences.
  ///
  /// In en, this message translates to:
  /// **'App preferences'**
  String get dashAppPreferences;

  /// No description provided for @dashNeedMeasurement.
  ///
  /// In en, this message translates to:
  /// **'Add a measurement to get soil advice.'**
  String get dashNeedMeasurement;

  /// No description provided for @syncOnline.
  ///
  /// In en, this message translates to:
  /// **'Online'**
  String get syncOnline;

  /// No description provided for @syncOffline.
  ///
  /// In en, this message translates to:
  /// **'Offline'**
  String get syncOffline;

  /// No description provided for @syncSyncing.
  ///
  /// In en, this message translates to:
  /// **'Syncing'**
  String get syncSyncing;

  /// No description provided for @syncSynced.
  ///
  /// In en, this message translates to:
  /// **'Synced'**
  String get syncSynced;

  /// No description provided for @syncError.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get syncError;

  /// No description provided for @plotsTitle.
  ///
  /// In en, this message translates to:
  /// **'Plots'**
  String get plotsTitle;

  /// No description provided for @plotsSearch.
  ///
  /// In en, this message translates to:
  /// **'Search plots…'**
  String get plotsSearch;

  /// No description provided for @plotAdd.
  ///
  /// In en, this message translates to:
  /// **'Add Plot'**
  String get plotAdd;

  /// No description provided for @plotEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit Plot'**
  String get plotEdit;

  /// No description provided for @plotDetails.
  ///
  /// In en, this message translates to:
  /// **'Plot Details'**
  String get plotDetails;

  /// No description provided for @plotName.
  ///
  /// In en, this message translates to:
  /// **'Plot Name'**
  String get plotName;

  /// No description provided for @plotLocation.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get plotLocation;

  /// No description provided for @plotSize.
  ///
  /// In en, this message translates to:
  /// **'Size (acres)'**
  String get plotSize;

  /// No description provided for @plotCropType.
  ///
  /// In en, this message translates to:
  /// **'Crop Type'**
  String get plotCropType;

  /// No description provided for @plotDescription.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get plotDescription;

  /// No description provided for @plotSave.
  ///
  /// In en, this message translates to:
  /// **'Save Plot'**
  String get plotSave;

  /// No description provided for @plotUpdate.
  ///
  /// In en, this message translates to:
  /// **'Update Plot'**
  String get plotUpdate;

  /// No description provided for @plotSaved.
  ///
  /// In en, this message translates to:
  /// **'Plot saved'**
  String get plotSaved;

  /// No description provided for @plotUpdated.
  ///
  /// In en, this message translates to:
  /// **'Plot updated'**
  String get plotUpdated;

  /// No description provided for @plotDeleted.
  ///
  /// In en, this message translates to:
  /// **'Plot deleted'**
  String get plotDeleted;

  /// No description provided for @plotDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Plot'**
  String get plotDeleteTitle;

  /// No description provided for @plotDeleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'This plot and its measurements will be removed.'**
  String get plotDeleteConfirm;

  /// No description provided for @plotsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No Plots Yet'**
  String get plotsEmptyTitle;

  /// No description provided for @plotsEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Register your first plot to start recording soil measurements.'**
  String get plotsEmptyBody;

  /// No description provided for @plotMeasurementsCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No readings} =1{1 reading} other{{count} readings}}'**
  String plotMeasurementsCount(int count);

  /// No description provided for @plotAcres.
  ///
  /// In en, this message translates to:
  /// **'{count} acres'**
  String plotAcres(Object count);

  /// No description provided for @measTitle.
  ///
  /// In en, this message translates to:
  /// **'Measurements'**
  String get measTitle;

  /// No description provided for @measAdd.
  ///
  /// In en, this message translates to:
  /// **'Add Measurement'**
  String get measAdd;

  /// No description provided for @measEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit Measurement'**
  String get measEdit;

  /// No description provided for @measDetails.
  ///
  /// In en, this message translates to:
  /// **'Measurement'**
  String get measDetails;

  /// No description provided for @measNotFound.
  ///
  /// In en, this message translates to:
  /// **'Measurement not found'**
  String get measNotFound;

  /// No description provided for @measSoilNutrients.
  ///
  /// In en, this message translates to:
  /// **'Soil Nutrients'**
  String get measSoilNutrients;

  /// No description provided for @measSoilConditions.
  ///
  /// In en, this message translates to:
  /// **'Soil Conditions'**
  String get measSoilConditions;

  /// No description provided for @measNitrogen.
  ///
  /// In en, this message translates to:
  /// **'Nitrogen (N)'**
  String get measNitrogen;

  /// No description provided for @measPhosphorus.
  ///
  /// In en, this message translates to:
  /// **'Phosphorus (P)'**
  String get measPhosphorus;

  /// No description provided for @measPotassium.
  ///
  /// In en, this message translates to:
  /// **'Potassium (K)'**
  String get measPotassium;

  /// No description provided for @measPh.
  ///
  /// In en, this message translates to:
  /// **'pH Level'**
  String get measPh;

  /// No description provided for @measMoisture.
  ///
  /// In en, this message translates to:
  /// **'Moisture'**
  String get measMoisture;

  /// No description provided for @measTemperature.
  ///
  /// In en, this message translates to:
  /// **'Temperature'**
  String get measTemperature;

  /// No description provided for @measEc.
  ///
  /// In en, this message translates to:
  /// **'Electrical Conductivity'**
  String get measEc;

  /// No description provided for @measNotes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get measNotes;

  /// No description provided for @measSelectPlot.
  ///
  /// In en, this message translates to:
  /// **'Select Plot'**
  String get measSelectPlot;

  /// No description provided for @measSave.
  ///
  /// In en, this message translates to:
  /// **'Save Measurement'**
  String get measSave;

  /// No description provided for @measSaved.
  ///
  /// In en, this message translates to:
  /// **'Measurement saved'**
  String get measSaved;

  /// No description provided for @measUpdated.
  ///
  /// In en, this message translates to:
  /// **'Measurement updated'**
  String get measUpdated;

  /// No description provided for @measDeleted.
  ///
  /// In en, this message translates to:
  /// **'Measurement deleted'**
  String get measDeleted;

  /// No description provided for @measDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Measurement'**
  String get measDeleteTitle;

  /// No description provided for @measDeleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'This measurement will be removed from local storage.'**
  String get measDeleteConfirm;

  /// No description provided for @measEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No Measurements Yet'**
  String get measEmptyTitle;

  /// No description provided for @measEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Record your first soil reading to begin tracking soil health.'**
  String get measEmptyBody;

  /// No description provided for @measStatusOptimal.
  ///
  /// In en, this message translates to:
  /// **'Optimal'**
  String get measStatusOptimal;

  /// No description provided for @measStatusNear.
  ///
  /// In en, this message translates to:
  /// **'Near'**
  String get measStatusNear;

  /// No description provided for @measStatusOff.
  ///
  /// In en, this message translates to:
  /// **'Off range'**
  String get measStatusOff;

  /// No description provided for @measOptimalRange.
  ///
  /// In en, this message translates to:
  /// **'Optimal: {min} – {max}{unit}'**
  String measOptimalRange(Object min, Object max, Object unit);

  /// No description provided for @measDetailsSection.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get measDetailsSection;

  /// No description provided for @measFieldPlot.
  ///
  /// In en, this message translates to:
  /// **'Plot'**
  String get measFieldPlot;

  /// No description provided for @measFieldRecorded.
  ///
  /// In en, this message translates to:
  /// **'Recorded'**
  String get measFieldRecorded;

  /// No description provided for @measSyncStatus.
  ///
  /// In en, this message translates to:
  /// **'Sync Status'**
  String get measSyncStatus;

  /// No description provided for @measSyncedToCloud.
  ///
  /// In en, this message translates to:
  /// **'Synced to cloud'**
  String get measSyncedToCloud;

  /// No description provided for @measPendingSync.
  ///
  /// In en, this message translates to:
  /// **'Pending sync'**
  String get measPendingSync;

  /// No description provided for @histTitle.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get histTitle;

  /// No description provided for @histSummary.
  ///
  /// In en, this message translates to:
  /// **'Summary'**
  String get histSummary;

  /// No description provided for @histFilterTitle.
  ///
  /// In en, this message translates to:
  /// **'Filter History'**
  String get histFilterTitle;

  /// No description provided for @histSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search by plot or notes…'**
  String get histSearchHint;

  /// No description provided for @histDateRange.
  ///
  /// In en, this message translates to:
  /// **'Date Range'**
  String get histDateRange;

  /// No description provided for @histSelectDateRange.
  ///
  /// In en, this message translates to:
  /// **'Select Date Range'**
  String get histSelectDateRange;

  /// No description provided for @histClearDate.
  ///
  /// In en, this message translates to:
  /// **'Clear date'**
  String get histClearDate;

  /// No description provided for @histEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No History Yet'**
  String get histEmptyTitle;

  /// No description provided for @histEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Your measurement history will appear here after you add readings.'**
  String get histEmptyBody;

  /// No description provided for @histNoResults.
  ///
  /// In en, this message translates to:
  /// **'No results match your filters'**
  String get histNoResults;

  /// No description provided for @histReadingsCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 reading} other{{count} readings}}'**
  String histReadingsCount(int count);

  /// No description provided for @histAdviceBadge.
  ///
  /// In en, this message translates to:
  /// **'Advice'**
  String get histAdviceBadge;

  /// No description provided for @reportsTitle.
  ///
  /// In en, this message translates to:
  /// **'Reports'**
  String get reportsTitle;

  /// No description provided for @reportsAvailable.
  ///
  /// In en, this message translates to:
  /// **'AVAILABLE REPORTS'**
  String get reportsAvailable;

  /// No description provided for @reportsAdvisoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Soil Management Advisory'**
  String get reportsAdvisoryTitle;

  /// No description provided for @reportsAdvisorySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Rule-based recommendations for your latest reading'**
  String get reportsAdvisorySubtitle;

  /// No description provided for @reportsHistoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Measurement History'**
  String get reportsHistoryTitle;

  /// No description provided for @reportsHistorySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Browse all past soil readings across your plots'**
  String get reportsHistorySubtitle;

  /// No description provided for @reportsExportTitle.
  ///
  /// In en, this message translates to:
  /// **'Export Report'**
  String get reportsExportTitle;

  /// No description provided for @reportsExportSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Export to PDF or Excel with date & plot filters'**
  String get reportsExportSubtitle;

  /// No description provided for @reportsSensorNote.
  ///
  /// In en, this message translates to:
  /// **'Sensor integration (Phase 9) will add real-time reading exports from your ESP32.'**
  String get reportsSensorNote;

  /// No description provided for @reportsNeedMeasurement.
  ///
  /// In en, this message translates to:
  /// **'Add a measurement to generate soil advice.'**
  String get reportsNeedMeasurement;

  /// No description provided for @exportTitle.
  ///
  /// In en, this message translates to:
  /// **'Export Report'**
  String get exportTitle;

  /// No description provided for @exportFormat.
  ///
  /// In en, this message translates to:
  /// **'Format'**
  String get exportFormat;

  /// No description provided for @exportIncludeNotes.
  ///
  /// In en, this message translates to:
  /// **'Include notes'**
  String get exportIncludeNotes;

  /// No description provided for @exportFilterPlot.
  ///
  /// In en, this message translates to:
  /// **'Plot'**
  String get exportFilterPlot;

  /// No description provided for @exportFilterDate.
  ///
  /// In en, this message translates to:
  /// **'Date Range'**
  String get exportFilterDate;

  /// No description provided for @exportGenerate.
  ///
  /// In en, this message translates to:
  /// **'Generate Report'**
  String get exportGenerate;

  /// No description provided for @exportInProgress.
  ///
  /// In en, this message translates to:
  /// **'Generating report…'**
  String get exportInProgress;

  /// No description provided for @exportSuccess.
  ///
  /// In en, this message translates to:
  /// **'Report generated'**
  String get exportSuccess;

  /// No description provided for @exportFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not generate report'**
  String get exportFailed;

  /// No description provided for @exportEmpty.
  ///
  /// In en, this message translates to:
  /// **'No data to export for the selected filters.'**
  String get exportEmpty;

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTitle;

  /// No description provided for @profileEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get profileEdit;

  /// No description provided for @profileName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get profileName;

  /// No description provided for @profileEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get profileEmail;

  /// No description provided for @profileAccountInfo.
  ///
  /// In en, this message translates to:
  /// **'ACCOUNT'**
  String get profileAccountInfo;

  /// No description provided for @profileSaveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get profileSaveChanges;

  /// No description provided for @profileUpdated.
  ///
  /// In en, this message translates to:
  /// **'Profile updated'**
  String get profileUpdated;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsAppearance.
  ///
  /// In en, this message translates to:
  /// **'APPEARANCE'**
  String get settingsAppearance;

  /// No description provided for @settingsTheme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get settingsTheme;

  /// No description provided for @settingsThemeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get settingsThemeLight;

  /// No description provided for @settingsThemeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get settingsThemeDark;

  /// No description provided for @settingsThemeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get settingsThemeSystem;

  /// No description provided for @settingsSelectTheme.
  ///
  /// In en, this message translates to:
  /// **'Select Theme'**
  String get settingsSelectTheme;

  /// No description provided for @settingsSyncData.
  ///
  /// In en, this message translates to:
  /// **'SYNC & DATA'**
  String get settingsSyncData;

  /// No description provided for @settingsSyncSettings.
  ///
  /// In en, this message translates to:
  /// **'Sync Settings'**
  String get settingsSyncSettings;

  /// No description provided for @settingsExportSettings.
  ///
  /// In en, this message translates to:
  /// **'Export Settings'**
  String get settingsExportSettings;

  /// No description provided for @settingsGeneral.
  ///
  /// In en, this message translates to:
  /// **'GENERAL'**
  String get settingsGeneral;

  /// No description provided for @settingsLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguage;

  /// No description provided for @settingsSelectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get settingsSelectLanguage;

  /// No description provided for @settingsLangEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get settingsLangEnglish;

  /// No description provided for @settingsLangSwahili.
  ///
  /// In en, this message translates to:
  /// **'Kiswahili'**
  String get settingsLangSwahili;

  /// No description provided for @settingsNotifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get settingsNotifications;

  /// No description provided for @settingsConfigureAlerts.
  ///
  /// In en, this message translates to:
  /// **'Configure alerts'**
  String get settingsConfigureAlerts;

  /// No description provided for @settingsAbout.
  ///
  /// In en, this message translates to:
  /// **'ABOUT'**
  String get settingsAbout;

  /// No description provided for @settingsAboutApp.
  ///
  /// In en, this message translates to:
  /// **'About App'**
  String get settingsAboutApp;

  /// No description provided for @settingsVersion.
  ///
  /// In en, this message translates to:
  /// **'Version {version}'**
  String settingsVersion(Object version);

  /// No description provided for @settingsAutoSyncOn.
  ///
  /// In en, this message translates to:
  /// **'Auto sync on'**
  String get settingsAutoSyncOn;

  /// No description provided for @settingsManualOnly.
  ///
  /// In en, this message translates to:
  /// **'Manual only'**
  String get settingsManualOnly;

  /// No description provided for @settingsSyncingEllipsis.
  ///
  /// In en, this message translates to:
  /// **'Syncing…'**
  String get settingsSyncingEllipsis;

  /// No description provided for @settingsPendingCount.
  ///
  /// In en, this message translates to:
  /// **'{count} pending'**
  String settingsPendingCount(Object count);

  /// No description provided for @smTitle.
  ///
  /// In en, this message translates to:
  /// **'Soil Management'**
  String get smTitle;

  /// No description provided for @smHealthStatus.
  ///
  /// In en, this message translates to:
  /// **'Soil Health Status'**
  String get smHealthStatus;

  /// No description provided for @smOverallStatus.
  ///
  /// In en, this message translates to:
  /// **'Overall Status'**
  String get smOverallStatus;

  /// No description provided for @smRecommendations.
  ///
  /// In en, this message translates to:
  /// **'RECOMMENDATIONS'**
  String get smRecommendations;

  /// No description provided for @smItemsCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 item} other{{count} items}}'**
  String smItemsCount(int count);

  /// No description provided for @smGenerateAdvisory.
  ///
  /// In en, this message translates to:
  /// **'Generate Advisory'**
  String get smGenerateAdvisory;

  /// No description provided for @smNoAdvisoryTitle.
  ///
  /// In en, this message translates to:
  /// **'No Advisory Yet'**
  String get smNoAdvisoryTitle;

  /// No description provided for @smNoAdvisoryBody.
  ///
  /// In en, this message translates to:
  /// **'Generate a rule-based soil management advisory for this measurement to see tailored recommendations.'**
  String get smNoAdvisoryBody;

  /// No description provided for @smGenerating.
  ///
  /// In en, this message translates to:
  /// **'Generating soil advisory…'**
  String get smGenerating;

  /// No description provided for @smApplyingRules.
  ///
  /// In en, this message translates to:
  /// **'Applying rule-based soil management analysis.'**
  String get smApplyingRules;

  /// No description provided for @smUpdating.
  ///
  /// In en, this message translates to:
  /// **'Updating advisory…'**
  String get smUpdating;

  /// No description provided for @smGeneratingShort.
  ///
  /// In en, this message translates to:
  /// **'Generating recommendations…'**
  String get smGeneratingShort;

  /// No description provided for @smTapToGenerate.
  ///
  /// In en, this message translates to:
  /// **'Tap to generate rule-based advice'**
  String get smTapToGenerate;

  /// No description provided for @smLastGenerated.
  ///
  /// In en, this message translates to:
  /// **'Last generated {date}'**
  String smLastGenerated(Object date);

  /// No description provided for @smOfflineCached.
  ///
  /// In en, this message translates to:
  /// **'You appear to be offline. Showing the last saved advisory.'**
  String get smOfflineCached;

  /// No description provided for @smNoActionsHealthy.
  ///
  /// In en, this message translates to:
  /// **'No actions needed. Your soil is within healthy ranges.'**
  String get smNoActionsHealthy;

  /// No description provided for @smRecommendationCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 recommendation} other{{count} recommendations}}'**
  String smRecommendationCount(int count);

  /// No description provided for @smErrUnauthorized.
  ///
  /// In en, this message translates to:
  /// **'Session expired. Please sign in again.'**
  String get smErrUnauthorized;

  /// No description provided for @smErrServer.
  ///
  /// In en, this message translates to:
  /// **'The advisory service is temporarily unavailable.'**
  String get smErrServer;

  /// No description provided for @smErrBadResponse.
  ///
  /// In en, this message translates to:
  /// **'Received an unexpected response from the server.'**
  String get smErrBadResponse;

  /// No description provided for @smErrUnknown.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong while generating the advisory.'**
  String get smErrUnknown;

  /// No description provided for @authFillAllFields.
  ///
  /// In en, this message translates to:
  /// **'Please fill all fields'**
  String get authFillAllFields;

  /// No description provided for @authLoginFailed.
  ///
  /// In en, this message translates to:
  /// **'Login failed'**
  String get authLoginFailed;

  /// No description provided for @authRegisterFailed.
  ///
  /// In en, this message translates to:
  /// **'Registration failed'**
  String get authRegisterFailed;

  /// No description provided for @authLoginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in to continue managing your soil'**
  String get authLoginSubtitle;

  /// No description provided for @authRegisterSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Register to start managing your soil health'**
  String get authRegisterSubtitle;

  /// No description provided for @authEmailAddress.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get authEmailAddress;

  /// No description provided for @authLoginButton.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get authLoginButton;

  /// No description provided for @authPasswordMin.
  ///
  /// In en, this message translates to:
  /// **'Minimum 6 characters'**
  String get authPasswordMin;

  /// No description provided for @authResetIntro.
  ///
  /// In en, this message translates to:
  /// **'Enter your account email. We will send you a link to reset your password.'**
  String get authResetIntro;

  /// No description provided for @authEnterEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email address.'**
  String get authEnterEmail;

  /// No description provided for @authInvalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address.'**
  String get authInvalidEmail;

  /// No description provided for @authSomethingWrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong.'**
  String get authSomethingWrong;

  /// No description provided for @authCheckEmailTitle.
  ///
  /// In en, this message translates to:
  /// **'Check Your Email'**
  String get authCheckEmailTitle;

  /// No description provided for @authCheckEmailBody.
  ///
  /// In en, this message translates to:
  /// **'If an account exists for that email address, we\'ve sent a password reset link. Check your inbox and follow the instructions.'**
  String get authCheckEmailBody;

  /// No description provided for @authCheckEmailNote.
  ///
  /// In en, this message translates to:
  /// **'The link expires in 1 hour. Check your spam folder if you don\'t see it.'**
  String get authCheckEmailNote;

  /// No description provided for @authBackToLogin.
  ///
  /// In en, this message translates to:
  /// **'Back to Login'**
  String get authBackToLogin;

  /// No description provided for @actionSaving.
  ///
  /// In en, this message translates to:
  /// **'Saving…'**
  String get actionSaving;

  /// No description provided for @plotAddNewTitle.
  ///
  /// In en, this message translates to:
  /// **'Add New Plot'**
  String get plotAddNewTitle;

  /// No description provided for @plotInfoSection.
  ///
  /// In en, this message translates to:
  /// **'Plot Information'**
  String get plotInfoSection;

  /// No description provided for @plotNameRequiredLabel.
  ///
  /// In en, this message translates to:
  /// **'Plot Name *'**
  String get plotNameRequiredLabel;

  /// No description provided for @plotNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. North Field, Plot A'**
  String get plotNameHint;

  /// No description provided for @plotLocationVillage.
  ///
  /// In en, this message translates to:
  /// **'Location / Village'**
  String get plotLocationVillage;

  /// No description provided for @plotLocationHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Dodoma, Arusha'**
  String get plotLocationHint;

  /// No description provided for @plotAreaAcres.
  ///
  /// In en, this message translates to:
  /// **'Area (acres)'**
  String get plotAreaAcres;

  /// No description provided for @plotAreaHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. 2.5'**
  String get plotAreaHint;

  /// No description provided for @plotDescOptional.
  ///
  /// In en, this message translates to:
  /// **'Description (optional)'**
  String get plotDescOptional;

  /// No description provided for @plotDescHint.
  ///
  /// In en, this message translates to:
  /// **'Any notes about this plot…'**
  String get plotDescHint;

  /// No description provided for @plotPrimaryCrop.
  ///
  /// In en, this message translates to:
  /// **'Primary Crop'**
  String get plotPrimaryCrop;

  /// No description provided for @plotNameRequiredMsg.
  ///
  /// In en, this message translates to:
  /// **'Plot name is required'**
  String get plotNameRequiredMsg;

  /// No description provided for @plotSaveFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not save plot'**
  String get plotSaveFailed;

  /// No description provided for @plotAddFirst.
  ///
  /// In en, this message translates to:
  /// **'Add First Plot'**
  String get plotAddFirst;

  /// No description provided for @plotsNotFound.
  ///
  /// In en, this message translates to:
  /// **'No plots found'**
  String get plotsNotFound;

  /// No description provided for @plotsTryDifferent.
  ///
  /// In en, this message translates to:
  /// **'Try a different search term.'**
  String get plotsTryDifferent;

  /// No description provided for @plotSizeBadge.
  ///
  /// In en, this message translates to:
  /// **'{count} ac'**
  String plotSizeBadge(Object count);

  /// No description provided for @measSelectPlotRequired.
  ///
  /// In en, this message translates to:
  /// **'Select Plot *'**
  String get measSelectPlotRequired;

  /// No description provided for @measNoPlotsAvailable.
  ///
  /// In en, this message translates to:
  /// **'No plots available. Add a plot first.'**
  String get measNoPlotsAvailable;

  /// No description provided for @measNutrientReadings.
  ///
  /// In en, this message translates to:
  /// **'Soil Nutrient Readings'**
  String get measNutrientReadings;

  /// No description provided for @measConditionReadings.
  ///
  /// In en, this message translates to:
  /// **'Soil Condition Readings'**
  String get measConditionReadings;

  /// No description provided for @measNotesOptional.
  ///
  /// In en, this message translates to:
  /// **'Notes (optional)'**
  String get measNotesOptional;

  /// No description provided for @measNotesHint.
  ///
  /// In en, this message translates to:
  /// **'Observations, weather conditions, etc.'**
  String get measNotesHint;

  /// No description provided for @measSelectPlotMsg.
  ///
  /// In en, this message translates to:
  /// **'Please select a plot'**
  String get measSelectPlotMsg;

  /// No description provided for @measValidNumberField.
  ///
  /// In en, this message translates to:
  /// **'{field} must be a valid number'**
  String measValidNumberField(Object field);

  /// No description provided for @measSaveFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not save measurement'**
  String get measSaveFailed;

  /// No description provided for @measTypicalHint.
  ///
  /// In en, this message translates to:
  /// **'Typical: {range}'**
  String measTypicalHint(Object range);

  /// No description provided for @measSensorTip.
  ///
  /// In en, this message translates to:
  /// **'Connect your ESP32 sensor via Bluetooth for automatic readings.'**
  String get measSensorTip;

  /// No description provided for @measEcWithAbbr.
  ///
  /// In en, this message translates to:
  /// **'Electrical Conductivity (EC)'**
  String get measEcWithAbbr;

  /// No description provided for @measAddReading.
  ///
  /// In en, this message translates to:
  /// **'Add Reading'**
  String get measAddReading;

  /// No description provided for @measSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search by plot name or notes…'**
  String get measSearchHint;

  /// No description provided for @measFilters.
  ///
  /// In en, this message translates to:
  /// **'Filters'**
  String get measFilters;

  /// No description provided for @measClearAll.
  ///
  /// In en, this message translates to:
  /// **'Clear All'**
  String get measClearAll;

  /// No description provided for @measFilterByPlot.
  ///
  /// In en, this message translates to:
  /// **'Filter by Plot'**
  String get measFilterByPlot;

  /// No description provided for @measAllPlots.
  ///
  /// In en, this message translates to:
  /// **'All Plots'**
  String get measAllPlots;

  /// No description provided for @measFilterByDate.
  ///
  /// In en, this message translates to:
  /// **'Filter by Date Range'**
  String get measFilterByDate;

  /// No description provided for @measClearDateFilter.
  ///
  /// In en, this message translates to:
  /// **'Clear date filter'**
  String get measClearDateFilter;

  /// No description provided for @measApplyFilters.
  ///
  /// In en, this message translates to:
  /// **'Apply Filters'**
  String get measApplyFilters;

  /// No description provided for @measClearFilters.
  ///
  /// In en, this message translates to:
  /// **'Clear Filters'**
  String get measClearFilters;

  /// No description provided for @measFiltersActive.
  ///
  /// In en, this message translates to:
  /// **'Filters active'**
  String get measFiltersActive;

  /// No description provided for @measStatTotal.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get measStatTotal;

  /// No description provided for @measStatAvgPh.
  ///
  /// In en, this message translates to:
  /// **'Avg pH'**
  String get measStatAvgPh;

  /// No description provided for @measStatAvgMoisture.
  ///
  /// In en, this message translates to:
  /// **'Avg H₂O'**
  String get measStatAvgMoisture;

  /// No description provided for @measStatAvgN.
  ///
  /// In en, this message translates to:
  /// **'Avg N'**
  String get measStatAvgN;

  /// No description provided for @measAddFirstReading.
  ///
  /// In en, this message translates to:
  /// **'Add First Reading'**
  String get measAddFirstReading;

  /// No description provided for @measReadingsLabel.
  ///
  /// In en, this message translates to:
  /// **'Readings'**
  String get measReadingsLabel;

  /// No description provided for @plotNotFound.
  ///
  /// In en, this message translates to:
  /// **'Plot not found'**
  String get plotNotFound;

  /// No description provided for @plotAddedDate.
  ///
  /// In en, this message translates to:
  /// **'Added {date}'**
  String plotAddedDate(Object date);

  /// No description provided for @plotDeleteNamedConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete \"{name}\"? All measurements for this plot will remain.'**
  String plotDeleteNamedConfirm(Object name);

  /// No description provided for @plotNoReadingsYet.
  ///
  /// In en, this message translates to:
  /// **'No readings yet'**
  String get plotNoReadingsYet;

  /// No description provided for @plotAcresText.
  ///
  /// In en, this message translates to:
  /// **'{count} acres'**
  String plotAcresText(Object count);

  /// No description provided for @profilePreferences.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get profilePreferences;

  /// No description provided for @profileSupport.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get profileSupport;

  /// No description provided for @profileChangePassword.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get profileChangePassword;

  /// No description provided for @profileHelpFaq.
  ///
  /// In en, this message translates to:
  /// **'Help & FAQ'**
  String get profileHelpFaq;

  /// No description provided for @exportFiltersLabel.
  ///
  /// In en, this message translates to:
  /// **'FILTERS'**
  String get exportFiltersLabel;

  /// No description provided for @exportAllTime.
  ///
  /// In en, this message translates to:
  /// **'All time'**
  String get exportAllTime;

  /// No description provided for @exportAllPlots.
  ///
  /// In en, this message translates to:
  /// **'All plots'**
  String get exportAllPlots;

  /// No description provided for @exportFormatLabel.
  ///
  /// In en, this message translates to:
  /// **'FORMAT'**
  String get exportFormatLabel;

  /// No description provided for @exportPdfSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Share-ready document'**
  String get exportPdfSubtitle;

  /// No description provided for @exportExcelSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Spreadsheet (.xlsx)'**
  String get exportExcelSubtitle;

  /// No description provided for @exportPreparing.
  ///
  /// In en, this message translates to:
  /// **'Preparing…'**
  String get exportPreparing;

  /// No description provided for @exportShare.
  ///
  /// In en, this message translates to:
  /// **'Export & Share'**
  String get exportShare;

  /// No description provided for @exportNoMatch.
  ///
  /// In en, this message translates to:
  /// **'No measurements match your filters'**
  String get exportNoMatch;

  /// No description provided for @exportFailedMsg.
  ///
  /// In en, this message translates to:
  /// **'Export failed'**
  String get exportFailedMsg;

  /// No description provided for @exportPreviewCount.
  ///
  /// In en, this message translates to:
  /// **'{count} of {total} will be exported'**
  String exportPreviewCount(Object count, Object total);

  /// No description provided for @exportNoMatchFilters.
  ///
  /// In en, this message translates to:
  /// **'No measurements match the selected filters'**
  String get exportNoMatchFilters;

  /// No description provided for @plotUpdateFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not update plot'**
  String get plotUpdateFailed;

  /// No description provided for @measUpdateFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not update measurement'**
  String get measUpdateFailed;

  /// No description provided for @editProfileNameEmpty.
  ///
  /// In en, this message translates to:
  /// **'Name cannot be empty'**
  String get editProfileNameEmpty;

  /// No description provided for @editProfileEmailReadonly.
  ///
  /// In en, this message translates to:
  /// **'Email cannot be changed here.'**
  String get editProfileEmailReadonly;

  /// No description provided for @splashTagline.
  ///
  /// In en, this message translates to:
  /// **'Measure  •  Analyze  •  Manage'**
  String get splashTagline;

  /// No description provided for @themeAppearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get themeAppearance;

  /// No description provided for @themeLightDesc.
  ///
  /// In en, this message translates to:
  /// **'Always use light theme'**
  String get themeLightDesc;

  /// No description provided for @themeDarkDesc.
  ///
  /// In en, this message translates to:
  /// **'Always use dark theme'**
  String get themeDarkDesc;

  /// No description provided for @themeSystemTitle.
  ///
  /// In en, this message translates to:
  /// **'System Default'**
  String get themeSystemTitle;

  /// No description provided for @themeSystemDesc.
  ///
  /// In en, this message translates to:
  /// **'Follow device theme setting'**
  String get themeSystemDesc;

  /// No description provided for @themeNote.
  ///
  /// In en, this message translates to:
  /// **'The dashboard and auth screens always use the green gradient regardless of theme.'**
  String get themeNote;

  /// No description provided for @syncSettingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Sync & Data'**
  String get syncSettingsTitle;

  /// No description provided for @syncOptions.
  ///
  /// In en, this message translates to:
  /// **'SYNC OPTIONS'**
  String get syncOptions;

  /// No description provided for @syncAutoSync.
  ///
  /// In en, this message translates to:
  /// **'Auto Sync'**
  String get syncAutoSync;

  /// No description provided for @syncAutoSyncDesc.
  ///
  /// In en, this message translates to:
  /// **'Sync automatically when back online'**
  String get syncAutoSyncDesc;

  /// No description provided for @syncWifiOnly.
  ///
  /// In en, this message translates to:
  /// **'Wi-Fi Only'**
  String get syncWifiOnly;

  /// No description provided for @syncWifiOnlyDesc.
  ///
  /// In en, this message translates to:
  /// **'Skip sync on mobile data'**
  String get syncWifiOnlyDesc;

  /// No description provided for @syncManualSync.
  ///
  /// In en, this message translates to:
  /// **'MANUAL SYNC'**
  String get syncManualSync;

  /// No description provided for @syncNow.
  ///
  /// In en, this message translates to:
  /// **'Sync Now'**
  String get syncNow;

  /// No description provided for @syncConnected.
  ///
  /// In en, this message translates to:
  /// **'Connected'**
  String get syncConnected;

  /// No description provided for @syncAllSynced.
  ///
  /// In en, this message translates to:
  /// **'All data is synced'**
  String get syncAllSynced;

  /// No description provided for @syncPendingItems.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 item pending sync} other{{count} items pending sync}}'**
  String syncPendingItems(int count);

  /// No description provided for @syncLastSynced.
  ///
  /// In en, this message translates to:
  /// **'Last synced: {time}'**
  String syncLastSynced(Object time);

  /// No description provided for @syncJustNow.
  ///
  /// In en, this message translates to:
  /// **'just now'**
  String get syncJustNow;

  /// No description provided for @syncLastError.
  ///
  /// In en, this message translates to:
  /// **'Last error: {error}'**
  String syncLastError(Object error);

  /// No description provided for @exportDefaultFormat.
  ///
  /// In en, this message translates to:
  /// **'DEFAULT FORMAT'**
  String get exportDefaultFormat;

  /// No description provided for @exportPdfPrintable.
  ///
  /// In en, this message translates to:
  /// **'Printable document'**
  String get exportPdfPrintable;

  /// No description provided for @exportContent.
  ///
  /// In en, this message translates to:
  /// **'CONTENT'**
  String get exportContent;

  /// No description provided for @exportIncludeNotesTitle.
  ///
  /// In en, this message translates to:
  /// **'Include Notes'**
  String get exportIncludeNotesTitle;

  /// No description provided for @exportIncludeNotesDesc.
  ///
  /// In en, this message translates to:
  /// **'Append measurement notes to exported reports'**
  String get exportIncludeNotesDesc;

  /// No description provided for @aboutTitle.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get aboutTitle;

  /// No description provided for @aboutDeveloperSection.
  ///
  /// In en, this message translates to:
  /// **'DEVELOPER'**
  String get aboutDeveloperSection;

  /// No description provided for @aboutDeveloperLabel.
  ///
  /// In en, this message translates to:
  /// **'Developer'**
  String get aboutDeveloperLabel;

  /// No description provided for @aboutEngineer.
  ///
  /// In en, this message translates to:
  /// **'Engineer'**
  String get aboutEngineer;

  /// No description provided for @aboutTargetMarket.
  ///
  /// In en, this message translates to:
  /// **'Target Market'**
  String get aboutTargetMarket;

  /// No description provided for @aboutTargetMarketValue.
  ///
  /// In en, this message translates to:
  /// **'Tanzania, East Africa'**
  String get aboutTargetMarketValue;

  /// No description provided for @aboutTechnology.
  ///
  /// In en, this message translates to:
  /// **'TECHNOLOGY'**
  String get aboutTechnology;

  /// No description provided for @aboutFramework.
  ///
  /// In en, this message translates to:
  /// **'Framework'**
  String get aboutFramework;

  /// No description provided for @aboutCloud.
  ///
  /// In en, this message translates to:
  /// **'Cloud'**
  String get aboutCloud;

  /// No description provided for @aboutLocalStorage.
  ///
  /// In en, this message translates to:
  /// **'Local Storage'**
  String get aboutLocalStorage;

  /// No description provided for @aboutSensorLabel.
  ///
  /// In en, this message translates to:
  /// **'Sensor'**
  String get aboutSensorLabel;

  /// No description provided for @aboutLegal.
  ///
  /// In en, this message translates to:
  /// **'LEGAL'**
  String get aboutLegal;

  /// No description provided for @aboutLicenses.
  ///
  /// In en, this message translates to:
  /// **'Open Source Licenses'**
  String get aboutLicenses;

  /// No description provided for @aboutThirdParty.
  ///
  /// In en, this message translates to:
  /// **'Third-party packages'**
  String get aboutThirdParty;

  /// No description provided for @aboutCopyright.
  ///
  /// In en, this message translates to:
  /// **'© 2026 Shackytronics. All rights reserved.'**
  String get aboutCopyright;

  /// No description provided for @sensorConnectTitle.
  ///
  /// In en, this message translates to:
  /// **'Connect Sensor'**
  String get sensorConnectTitle;

  /// No description provided for @sensorMeasureTitle.
  ///
  /// In en, this message translates to:
  /// **'Live Measurement'**
  String get sensorMeasureTitle;

  /// No description provided for @sensorPairingTitle.
  ///
  /// In en, this message translates to:
  /// **'BLE Sensor Pairing'**
  String get sensorPairingTitle;

  /// No description provided for @sensorLiveTitle.
  ///
  /// In en, this message translates to:
  /// **'Live Soil Reading'**
  String get sensorLiveTitle;

  /// No description provided for @sensorConnectBody.
  ///
  /// In en, this message translates to:
  /// **'Bluetooth Low Energy module will be implemented in a future phase. Your ESP32 sensor will appear here.'**
  String get sensorConnectBody;

  /// No description provided for @sensorLiveBody.
  ///
  /// In en, this message translates to:
  /// **'Live measurement stream from the 7-in-1 soil sensor will be available once BLE is implemented.'**
  String get sensorLiveBody;

  /// No description provided for @sensorGoBack.
  ///
  /// In en, this message translates to:
  /// **'Go Back'**
  String get sensorGoBack;

  /// No description provided for @settingsBackend.
  ///
  /// In en, this message translates to:
  /// **'BACKEND'**
  String get settingsBackend;

  /// No description provided for @settingsBackendStatus.
  ///
  /// In en, this message translates to:
  /// **'Backend Status'**
  String get settingsBackendStatus;

  /// No description provided for @backendChecking.
  ///
  /// In en, this message translates to:
  /// **'Checking…'**
  String get backendChecking;

  /// No description provided for @backendUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Unavailable'**
  String get backendUnavailable;

  /// No description provided for @smHealthScore.
  ///
  /// In en, this message translates to:
  /// **'Soil Health Score'**
  String get smHealthScore;

  /// No description provided for @smScoreOutOf.
  ///
  /// In en, this message translates to:
  /// **'{score}/100'**
  String smScoreOutOf(Object score);

  /// No description provided for @priorityHigh.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get priorityHigh;

  /// No description provided for @priorityMedium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get priorityMedium;

  /// No description provided for @priorityLow.
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get priorityLow;

  /// No description provided for @unitMgkg.
  ///
  /// In en, this message translates to:
  /// **'mg/kg'**
  String get unitMgkg;

  /// No description provided for @unitPercent.
  ///
  /// In en, this message translates to:
  /// **'%'**
  String get unitPercent;

  /// No description provided for @unitCelsius.
  ///
  /// In en, this message translates to:
  /// **'°C'**
  String get unitCelsius;

  /// No description provided for @unitMscm.
  ///
  /// In en, this message translates to:
  /// **'mS/cm'**
  String get unitMscm;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'sw'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'sw':
      return AppLocalizationsSw();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
