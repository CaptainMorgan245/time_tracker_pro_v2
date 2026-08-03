import 'package:flutter/material.dart';

/// App-wide tooltip wrapper — a low-friction, gradual help mechanism. Shows on
/// long-press (touch) or hover (desktop/web), so it never gets in the way of
/// normal taps. Use it to explain a control or concept without a forced tour.
///
/// Start in the timer area and expand elsewhere over time.
class AppTooltip extends StatelessWidget {
  const AppTooltip({super.key, required this.message, required this.child});

  final String message;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: message,
      waitDuration: const Duration(milliseconds: 400),
      showDuration: const Duration(seconds: 3),
      child: child,
    );
  }
}
