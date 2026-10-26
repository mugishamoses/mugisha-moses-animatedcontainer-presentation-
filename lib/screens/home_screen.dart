import 'package:flutter/material.dart';

import 'package:clipo/widgets/recent_projects.dart';

/// Home screen of the Clipo video editor.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            SizedBox(
              height: 52,
              child: Center(
                child: Text(
                  'Home',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                ),
              ),
            ),
            SizedBox(height: 12),
            RecentProjects(),
          ],
        ),
      ),
    );
  }
}
