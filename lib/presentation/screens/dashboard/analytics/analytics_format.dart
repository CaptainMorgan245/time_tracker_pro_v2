import 'package:intl/intl.dart';

/// Small display helpers shared by the analytics hub widgets. The provider layer
/// keeps money in integer **cents**; formatting (and the cents→dollars divide)
/// lives here in the widget layer.

final NumberFormat _money =
    NumberFormat.currency(locale: 'en_US', symbol: '\$', decimalDigits: 2);

/// Formats integer cents as currency (e.g. `123456` → `$1,234.56`).
String formatMoneyCents(int cents) => _money.format(cents / 100);

/// Formats hours to one decimal place (e.g. `12.5 h`).
String formatHours(double hours) => '${hours.toStringAsFixed(1)} h';
