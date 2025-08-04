import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:perfume_store/theme/colors.dart';
import 'package:perfume_store/widgets/product_image_corousel_widget.dart';

class HomePageProductWidget extends StatefulWidget {
  const HomePageProductWidget({
    super.key,
    required this.cachedImages,
    required this.title,
    required this.description,
    required this.price,
    this.discount,
    required this.fullStars,
    required this.hasHalfStar,
    required this.rating,
    required this.id,
  });

  final List<Uint8List> cachedImages;
  final String title;
  final String description;
  final String price;
  final String? discount;
  final int fullStars;
  final bool hasHalfStar;
  final double rating;
  final String id;

  @override
  State<HomePageProductWidget> createState() => _HomePageProductWidgetState();
}

class _HomePageProductWidgetState extends State<HomePageProductWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 8,
      child: Column(
        mainAxisSize: MainAxisSize.min, // <--- Add this line
        children: [
          // Image Slider with Favorite Icon and Dots
          SizedBox(
            height: 338,
            width: double.infinity,
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Hero(
                    tag: 'hero${widget.id}',
                    child: ProductImageCarousel(
                      imageBytesList: widget.cachedImages,
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: const BoxDecoration(
                      color: AppColors.lightBeige,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(16),
                        bottomLeft: Radius.circular(16),
                      ),
                    ),
                    child: const Icon(
                      Icons.favorite_border,
                      color: AppColors.brown,
                      size: 24,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Product Info
          SizedBox(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      widget.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Center(
                    child: Column(
                      children: [
                        Text(
                          'TMT ${widget.price}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w200,
                          ),
                        ),
                        const SizedBox(width: 8),
                        if (widget.discount != null)
                          Text(
                            widget.discount!,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w300,
                              color: AppColors.charcoal,
                              decoration: TextDecoration.lineThrough,
                              decorationColor: Colors.red,
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Description', style: TextStyle(fontSize: 26)),
                            Row(
                              children: [
                                ...List.generate(
                                  widget.fullStars,
                                  (_) => const Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                    size: 16,
                                  ),
                                ),
                                if (widget.hasHalfStar)
                                  const Icon(
                                    Icons.star_half,
                                    color: Colors.amber,
                                    size: 16,
                                  ),
                                ...List.generate(
                                  5 -
                                      widget.fullStars -
                                      (widget.hasHalfStar ? 1 : 0),
                                  (_) => const Icon(
                                    Icons.star_border,
                                    color: Colors.amber,
                                    size: 16,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Text(widget.rating.toStringAsFixed(1)),
                                // Show number like 4.5
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 2.0),
                        Text(
                          widget.description,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w200,
                          ),
                        ),
                        const SizedBox(height: 8),
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
                              'Add to bag',
                              style: TextStyle(color: AppColors.beige),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
