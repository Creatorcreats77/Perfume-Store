import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:perfume_store/theme/colors.dart';
import 'package:perfume_store/widgets/product_image_corousel_widget.dart';
import 'package:perfume_store/widgets/product_widgets/favorite_button_widget.dart';

import '../views/pages/app_pages/perfume_home_page.dart';

class CardWidget extends StatelessWidget {
  const CardWidget({
    super.key,
    required this.cachedImages,
    required this.title,
    required this.description,
    required this.priceString,
    this.discount,
    required this.fullStars,
    required this.hasHalfStar,
    required this.rating,
    required this.id,
  });

  final List<Uint8List> cachedImages;
  final String title;
  final String description;
  final String priceString;
  final String? discount;
  final int fullStars;
  final bool hasHalfStar;
  final double rating;
  final String id;

  @override
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return SizedBox(
      width: screenWidth,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.beige,
          borderRadius: BorderRadius.circular(20),
        ),
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Icon(Icons.star, color: Color(0xFFFFC107), size: 28),
              // Icon(Icons.favorite_border, color: AppColors.brown),
            ),
            Expanded(
              child: Hero(
                tag: 'hero${id}',
                child: ProductImageCarousel(imageBytesList: cachedImages),
              ),
            ),
            SizedBox(height: 10),

            Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        discount != ''
                            ? "TMT ${discount}"
                            : "TMT ${priceString}",
                        style: TextStyle(fontSize: 16, color: AppColors.brown),
                      ),
                    ],
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          transitionDuration: Duration(milliseconds: 700),
                          // 💡 Set custom duration here
                          pageBuilder: (_, __, ___) => PerfumeHomePage(
                            cachedImages: cachedImages,
                            description: description,
                            title: title,
                            priceString: priceString,
                            discount: discount,
                            fullStars: fullStars,
                            hasHalfStar: hasHalfStar,
                            rating: rating,
                            id: id,
                          ),
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(100),
                    // Ensures proper ripple shape
                    child: CircleAvatar(
                      backgroundColor: Colors.amber,
                      child: Icon(Icons.arrow_forward, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
