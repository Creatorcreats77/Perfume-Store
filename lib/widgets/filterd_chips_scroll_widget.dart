import 'package:flutter/material.dart';
import 'package:perfume_store/theme/colors.dart';

class FilterdChipsScrollWidget extends StatefulWidget {
  const FilterdChipsScrollWidget({super.key});

  @override
  FilterChipsScrollState createState() => FilterChipsScrollState();
}

class FilterChipsScrollState extends State<FilterdChipsScrollWidget> {
  final List<String> categories = [
    'All',
    'Woody',
    'Floral',
    'Fresh',
    'Citrus',
    'Something',
    'Money',
  ];
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final bool isSelected = index == selectedIndex;
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedIndex = index;
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.brown : AppColors.beige,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Center(
                child: Text(
                  categories[index],
                  style: TextStyle(
                    color: isSelected ? Colors.white : AppColors.brown,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
