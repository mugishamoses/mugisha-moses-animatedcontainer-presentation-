import 'package:flutter/material.dart';

import 'package:parcel_tracker/models/animation_settings.dart';
import 'package:parcel_tracker/models/parcel.dart';
import 'package:parcel_tracker/widgets/parcel_card.dart';
import 'package:parcel_tracker/widgets/property_panel.dart';

/// "My deliveries" screen: a list of parcel cards that expand when tapped,
/// plus a panel for changing the AnimatedContainer properties live.
class TrackingScreen extends StatefulWidget {
  const TrackingScreen({super.key});

  @override
  State<TrackingScreen> createState() => _TrackingScreenState();
}

class _TrackingScreenState extends State<TrackingScreen> {
  // Only one card is open at a time, like most tracking apps.
  String? _expandedId;

  // Shared by every card, so a change in the panel affects them all.
  AnimationSettings _settings = const AnimationSettings();

  void _toggle(String trackingId) {
    setState(() {
      _expandedId = _expandedId == trackingId ? null : trackingId;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My deliveries')),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                for (final parcel in sampleParcels)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: ParcelCard(
                      parcel: parcel,
                      expanded: _expandedId == parcel.trackingId,
                      settings: _settings,
                      onTap: () => _toggle(parcel.trackingId),
                    ),
                  ),
              ],
            ),
          ),
          PropertyPanel(
            settings: _settings,
            onChanged: (value) => setState(() => _settings = value),
            onReset: () =>
                setState(() => _settings = const AnimationSettings()),
          ),
        ],
      ),
    );
  }
}
