import 'package:flutter/material.dart';

/// Home screen of the Clipo video editor.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: EdgeInsets.only(top: 14),
            child: Text(
              'Home',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
            ),
          ),
        ),
      ),
    );
  }
}
