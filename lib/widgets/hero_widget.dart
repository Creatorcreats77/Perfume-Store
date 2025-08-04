import 'package:flutter/material.dart';

class HeroWidget extends StatelessWidget {
  const HeroWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'hero_image',
      child: ClipRRect(
        child: Image.asset('assets/images/parfume_bg.png', width: 500),
      ),
    );
  }
}
