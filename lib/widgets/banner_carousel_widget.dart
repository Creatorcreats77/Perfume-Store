import 'package:flutter/material.dart';
import 'package:perfume_store/theme/colors.dart';

class BannerCarouselWidget extends StatefulWidget {
  const BannerCarouselWidget({super.key});

  @override
  State<BannerCarouselWidget> createState() => _BannerCarouselWidgetState();
}

class _BannerCarouselWidgetState extends State<BannerCarouselWidget> {
  late final PageController _controller; // ✅ Fixed here

  int _currentIndex = 0;

  final List<String> _imageAssets = [
    'assets/images/banners/banner_1.webp',
    'assets/images/banners/banner_2.png',
    'assets/images/banners/banner_1.webp',
    'assets/images/banners/banner_2.png',
    'assets/images/banners/banner_1.webp',
    'assets/images/banners/banner_2.png',
  ];

  @override
  void initState() {
    super.initState();
    _controller = PageController();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Banner
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Container(
              color: Colors.grey.shade200,
              height: 248,
              child: PageView.builder(
                controller: _controller,
                itemBuilder: (context, index) {
                  final actualIndex = index % _imageAssets.length;
                  return AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    child: Image.asset(
                      _imageAssets[actualIndex],
                      key: ValueKey(actualIndex),
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  );
                },
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index % _imageAssets.length;
                  });
                },
              ),
            ),
          ),
          SizedBox(height: 12),

          // Dots
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(_imageAssets.length, (index) {
              final isActive = index == _currentIndex;
              return AnimatedContainer(
                duration: Duration(milliseconds: 300),
                margin: EdgeInsets.symmetric(horizontal: 4),
                width: isActive ? 12 : 8,
                height: isActive ? 12 : 8,
                decoration: BoxDecoration(
                  color: isActive ? AppColors.amber : Colors.grey.shade400,
                  shape: BoxShape.circle,
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
