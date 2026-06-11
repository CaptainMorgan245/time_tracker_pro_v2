import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'presentation/screens/dashboard/dashboard_screen.dart';

void main() {
  // ProviderScope stores the state of all Riverpod providers. It must wrap the
  // entire app so any widget below can read/watch providers.
  runApp(const ProviderScope(child: TimeTrackerProApp()));
}

class TimeTrackerProApp extends StatelessWidget {
  const TimeTrackerProApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Time Tracker Pro',
      theme: ThemeData(
        // Match the original app's palette: a darker teal/blue-green
        // (Material's blueGrey) drives the seed and the headers.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
        useMaterial3: true,
        // Headers: solid blueGrey with white title + icons, as in the old app
        // (otherwise Material 3 tints the AppBar a light surface colour).
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blueGrey,
          foregroundColor: Colors.white,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: IconThemeData(color: Colors.white),
        ),
      ),
      home: const DashboardScreen(),
    );
  }
}
