import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:perfume_store/theme/colors.dart';
import 'package:perfume_store/views/data/notifiers.dart';

class BottomNavigationBarWidget extends StatefulWidget {
  const BottomNavigationBarWidget({super.key});

  @override
  State<BottomNavigationBarWidget> createState() =>
      _BottomNavigationBarWidgetState();
}

class _BottomNavigationBarWidgetState extends State<BottomNavigationBarWidget> {
  final List<IconData> _icons = [
    Icons.home,
    Icons.favorite_border,
    Icons.shopping_bag_outlined,
    Icons.person_outline,
  ];

  final List<String> _labels = ['Home', 'Wishlist', 'Bag', 'Profile'];

  Widget _buildNavItem(int index) {
    return ValueListenableBuilder(
      valueListenable: selectedPageNotifier,
      builder: (context, selectedPage, child) {
        final bool isSelected = selectedPage == index;

        return GestureDetector(
          onTap: () {
            selectedPageNotifier.value = index;
          },

          child: AnimatedContainer(
            duration: Duration(milliseconds: 300),
            padding: EdgeInsets.symmetric(horizontal: isSelected ? 16.0 : 0.0),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.brown : Colors.transparent,
              borderRadius: BorderRadius.circular(24.0),
              boxShadow: [
                if (isSelected)
                  BoxShadow(
                    color: AppColors.brown.withOpacity(0.3),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
              ],
            ),
            child: Row(
              children: [
                Padding(
                  padding: isSelected
                      ? EdgeInsets.symmetric(vertical: 10.0, horizontal: 4.0)
                      : EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
                  child: Icon(
                    _icons[index],
                    color: isSelected
                        ? AppColors.lightBeige
                        : AppColors.charcoal,
                  ),
                ),
                if (isSelected)
                  Padding(
                    padding: const EdgeInsets.only(left: 2.0),
                    child: Text(
                      _labels[index],
                      style: TextStyle(
                        color: AppColors.lightBeige,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 6),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10), // ⛅ Optional blur
            child: Container(
              color: Colors.white.withOpacity(0.05),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(
                  _icons.length,
                  (index) => _buildNavItem(index),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
