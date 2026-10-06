import 'package:flutter/material.dart';

/// The café's logo and name, used as the AppBar's title.
///
/// The icon and text pick up the AppBar's foreground colour automatically, so
/// they stay readable whatever background colour the AppBar is given.
class BrandTitle extends StatelessWidget {
  const BrandTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.local_cafe_rounded),
        SizedBox(width: 8),
        Text('Brew Lane', style: TextStyle(fontWeight: FontWeight.w700)),
      ],
    );
  }
}
