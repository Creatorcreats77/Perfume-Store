import 'package:flutter/material.dart';
import 'package:perfume_store/theme/colors.dart';

class OlfactoryUniverseWidget extends StatefulWidget {
  const OlfactoryUniverseWidget({super.key});

  @override
  State<OlfactoryUniverseWidget> createState() =>
      _OlfactoryUniverseWidgetState();
}

class _OlfactoryUniverseWidgetState extends State<OlfactoryUniverseWidget> {
  final List<String> images = [
    'assets/images/olfactory/acetaldehyde.png',
    'assets/images/olfactory/apple.png',
    'assets/images/olfactory/fougere.png',
    'assets/images/olfactory/marine.png',
    'assets/images/olfactory/apple.png',
    'assets/images/olfactory/acetaldehyde.png',
  ];

  final List<String> titles = [
    'acetaldehyde',
    'apple',
    'fougere',
    'marine',
    'apple',
    'acetaldehyde',
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 148,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: images.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {},
            child: Center(
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.beige,
                          blurRadius: 10,
                          offset: const Offset(1, 6),
                        ),
                      ],
                    ),
                    child: CircleAvatar(
                      radius: 48,
                      backgroundImage: AssetImage(images[index]),
                      backgroundColor: Colors.white, // or transparent
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    titles[index],
                    style: TextStyle(
                      color: AppColors.charcoal,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
