import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:perfume_store/views/pages/app_pages/perfume_home_page.dart';
import 'package:perfume_store/widgets/product_widgets/favorite_button_widget.dart';

import '../../theme/colors.dart';
import '../product_image_corousel_widget.dart';
import '../product_widgets/add_bag_button_widget.dart';

class ProductCardFetchingDataWidget extends StatefulWidget {
  const ProductCardFetchingDataWidget({
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
  State<ProductCardFetchingDataWidget> createState() =>
      _ProductCardFetchingDataWidgetState();
}

Future<void> deleteProductWithImages(String productId) async {
  final imagesRef = FirebaseFirestore.instance
      .collection('products')
      .doc(productId)
      .collection('images');

  final imagesSnapshot = await imagesRef.get();

  for (var doc in imagesSnapshot.docs) {
    await doc.reference.delete();
  }

  await FirebaseFirestore.instance
      .collection('products')
      .doc(productId)
      .delete();
}

class _ProductCardFetchingDataWidgetState
    extends State<ProductCardFetchingDataWidget> {
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
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          transitionDuration: Duration(milliseconds: 700),
                          // 💡 Set custom duration here
                          pageBuilder: (_, __, ___) => PerfumeHomePage(
                            cachedImages: widget.cachedImages,
                            description: widget.description,
                            title: widget.title,
                            priceString: widget.priceString,
                            discount: widget.discount,
                            fullStars: widget.fullStars,
                            hasHalfStar: widget.hasHalfStar,
                            rating: widget.rating,
                            id: widget.id,
                          ),
                        ),
                      );
                    },
                    child: Hero(tag: 'hero${widget.id}', child: ProductImageCarousel(
                      imageBytesList: widget.cachedImages,
                    ),),
                  ),
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: AppColors.lightBeige,
                      shape: BoxShape.circle,
                    ),
                    child: FavoriteButtonWidget(productId: widget.id),

                  ),
                ),
              ],
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
                      widget.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  // const SizedBox(height: 4),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          transitionDuration: Duration(milliseconds: 700),
                          // 💡 Set custom duration here
                          pageBuilder: (_, __, ___) => PerfumeHomePage(
                            cachedImages: widget.cachedImages,
                            description: widget.description,
                            title: widget.title,
                            priceString: widget.priceString,
                            discount: widget.discount,
                            fullStars: widget.fullStars,
                            hasHalfStar: widget.hasHalfStar,
                            rating: widget.rating,
                            id: widget.id,
                          ),
                        ),
                      );
                    },
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              widget.priceString,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            // const SizedBox(width: 8),
                            if (widget.discount != null &&
                                widget.discount != 0 &&
                                widget.discount.toString() != '0')
                              Text(
                                widget.discount.toString(),
                                // Ensures it's a string
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                          ],
                        ),
                        // const SizedBox(height: 4),
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
                  ),
                  // const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: AddBagButtonWidget(productId: widget.id,),
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
