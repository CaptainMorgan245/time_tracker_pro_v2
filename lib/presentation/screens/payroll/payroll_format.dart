import 'package:intl/intl.dart';

/// Display helpers for the payroll screens. Providers keep money in integer
/// **cents**; the cents→dollars divide lives here in the widget layer.

final NumberFormat _money =
    NumberFormat.currency(locale: 'en_US', symbol: '\$', decimalDigits: 2);

/// Formats integer cents as currency (e.g. `123456` → `$1,234.56`).
String payrollMoney(int cents) => _money.format(cents / 100);

/// Formats hours to two decimals (e.g. `12.50`).
String payrollHours(double hours) => hours.toStringAsFixed(2);
