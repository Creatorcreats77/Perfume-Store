import 'package:flutter/material.dart';

import '../../theme/colors.dart';

class CardLoadWidget extends StatefulWidget {
  const CardLoadWidget({super.key});

  @override
  State<CardLoadWidget> createState() => _CardLoadWidgetState();
}

class _CardLoadWidgetState extends State<CardLoadWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 8,
      child: Column(
        // mainAxisSize: MainAxisSize.min, // <--- Add this line
        children: [
          // Image Slider with Favorite Icon and Dots
          SizedBox(
            height: 148,
            width: double.infinity,
            child: Stack(
              children: [Center(child: CircularProgressIndicator())],
            ),
          ),
          // Product Info
          SizedBox(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FittedBox(
                    child: Text(
                      'xxxxxxxxx',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '0.0',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      ...List.generate(
                        5,
                        (_) => const Icon(
                          Icons.star,
                          color: Colors.amber,
                          size: 16,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(0.toStringAsFixed(1)),
                      // Show number like 4.5
                    ],
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.brown,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'xxx xx xxx',
                        style: TextStyle(color: AppColors.lightBeige),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
    ;
  }
}
