import 'package:flutter/material.dart';

class GlowingBackground extends StatelessWidget {
  const GlowingBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: RadialGradient(
          colors: [Colors.black, Colors.greenAccent],
          radius: 1.5,
        ),
      ),
    );
  }
}
