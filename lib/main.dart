import 'package:flutter/material.dart';

import 'package:parcel_tracker/screens/tracking_screen.dart';

void main() => runApp(const ParcelTrackerApp());

class ParcelTrackerApp extends StatelessWidget {
  const ParcelTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Parcel Tracker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1B5E20)),
      ),
      home: const TrackingScreen(),
    );
  }
}
