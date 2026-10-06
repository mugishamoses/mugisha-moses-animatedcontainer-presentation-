import 'package:flutter/material.dart';

import 'package:brew_lane/screens/menu_screen.dart';

void main() => runApp(const BrewLaneApp());

/// The café's brand colour. The whole Material 3 colour scheme is generated
/// from it, so every default colour in the app is a shade of coffee.
const Color _coffeeBrown = Color(0xFF6F4E37);

class BrewLaneApp extends StatelessWidget {
  const BrewLaneApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Brew Lane',
      // The DEBUG ribbon would otherwise cover the AppBar's cart action.
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: _coffeeBrown),
      ),
      home: const MenuScreen(),
    );
  }
}
