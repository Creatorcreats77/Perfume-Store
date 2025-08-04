import 'dart:typed_data';
import 'package:flutter/material.dart';

import '../theme/colors.dart';

class ProductImageCarousel extends StatefulWidget {
  final List<Uint8List> imageBytesList;

  const ProductImageCarousel({super.key, required this.imageBytesList});

  @override
  State<ProductImageCarousel> createState() => _ProductImageCarouselState();
}

class _ProductImageCarouselState extends State<ProductImageCarousel> {
  late final PageController _pageController;
  static const int _initialPage = 1000;
  int _currentPage = _initialPage;

  @override
  void initState() {
    _pageController = PageController(initialPage: _initialPage);
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final imageCount = widget.imageBytesList.length;

    if (imageCount == 0) {
      return const Center(
        child: Icon(
          Icons.image_not_supported,
          size: 82,
          color: AppColors.brown,
        ),
      );
    }
    final activeIndex = _currentPage % imageCount;

    return Stack(
      children: [
        PageView.builder(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              _currentPage = index;
            });
          },

          // itemCount: imageCount + 1,
          itemBuilder: (context, index) {
            final actualIndex = index % imageCount;
            return ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(24),
              ),
              child: Image.memory(
                widget.imageBytesList[actualIndex],
                fit: BoxFit.contain,
                width: double.infinity,
              ),
            );
          },
        ),
        Positioned(
          bottom: 4,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(imageCount, (index) {
              final isActive = index == activeIndex;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: isActive ? 10 : 6,
                height: isActive ? 10 : 6,
                decoration: BoxDecoration(
                  color: isActive ? AppColors.amber : Colors.grey.shade400,
                  shape: BoxShape.circle,
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}
