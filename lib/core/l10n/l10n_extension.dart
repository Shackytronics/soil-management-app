import 'package:flutter/widgets.dart';

import '../../l10n/app_localizations.dart';

/// Concise access to localized strings: `context.l10n.navDashboard`.
extension L10nExtension on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}
