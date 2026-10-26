import 'package:flutter/material.dart';

void main() => runApp(const ClipoApp());

class ClipoApp extends StatelessWidget {
  const ClipoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Clipo',
      debugShowCheckedModeBanner: false,
      home: Scaffold(body: Center(child: Text('Clipo'))),
    );
  }
}
