import 'package:intl/intl.dart';
import 'package:track_route_pro/utils/common_import.dart';

AppLocalizations? getAppLocalizations(BuildContext context) {
  return AppLocalizations.of(context);
}

Future<AppLocalizations> loadLocalization() async {
  final parts = Intl.getCurrentLocale().split('_');
  final locale = Locale(parts.first, parts.last);
  return AppLocalizations.delegate.load(locale);
}
