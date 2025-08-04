import 'package:flutter/material.dart';
import 'package:perfume_store/theme/colors.dart';

class BrandsWidget extends StatefulWidget {
  const BrandsWidget({super.key});

  @override
  State<BrandsWidget> createState() => _BrandsWidgetState();
}

class _BrandsWidgetState extends State<BrandsWidget> {
  final List<String> images = [
    'assets/images/brands/1.png',
    'assets/images/brands/2.png',
    'assets/images/brands/3.png',
    'assets/images/brands/4.png',
    'assets/images/brands/5.png',
    'assets/images/brands/6.png',
  ];
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: images.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {},
            child: Center(
              child: Container(
                width: 168,
                decoration: BoxDecoration(
                  color: AppColors.beige,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Image.asset(images[index], fit: BoxFit.fitWidth),
              ),
            ),
          );
        },
      ),
    );
  }
}
