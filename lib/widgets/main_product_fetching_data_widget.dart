import 'dart:typed_data';
import 'dart:convert'; // For base64 decoding if needed

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:perfume_store/theme/colors.dart';
import 'package:perfume_store/widgets/loader_widgets/card_load_widget.dart';
import 'package:perfume_store/widgets/product_image_corousel_widget.dart';
import 'package:perfume_store/widgets/product_widgets/add_bag_button_widget.dart';
import 'package:perfume_store/widgets/product_widgets/favorite_button_widget.dart';

import 'app_bar_with_search_widget.dart';

class MainProductFetchingDataWidget extends StatefulWidget {
  final String id;
  final List<Uint8List> cachedImages;

  const MainProductFetchingDataWidget({
    Key? key,
    required this.id,
    required this.cachedImages,
  }) : super(key: key);

  @override
  State<MainProductFetchingDataWidget> createState() =>
      _MainProductFetchingDataWidgetState();
}

class _MainProductFetchingDataWidgetState
    extends State<MainProductFetchingDataWidget> {
  bool _loading = true;
  String? title;
  String? description;
  String? price;
  String? discount;

  List<Uint8List> imageBytesList = [];

  int fullStars = 0;
  bool hasHalfStar = false;
  double rating = 0.0;

  @override
  void initState() {
    super.initState();
    print("jhjkhjkhjkhkjh: ${widget.id}");
    _fetchMainProductAndImages();
  }

  Future<void> _fetchMainProductAndImages() async {
    try {
      // 1. Fetch product main document
      final docSnapshot = await FirebaseFirestore.instance
          .collection('products')
          .doc(widget.id)
          .get();

      if (docSnapshot.exists) {
        final data = docSnapshot.data()!;
        // Parse main product info
        title = data['title'] ?? 'No Title';
        description = data['description'] ?? '';
        price = data['price'];
        discount = data['discount']?.toString();

        // 2. Fetch images subcollection
        final imagesSnapshot = await FirebaseFirestore.instance
            .collection('products')
            .doc(widget.id)
            .collection('images')
            .get();

        List<Uint8List> images = [];

        for (var doc in imagesSnapshot.docs) {
          final imageData = doc.data()['image'];
          if (imageData != null) {
            // Assuming image is stored as base64 string in Firestore, decode it
            try {
              images.add(base64Decode(imageData));
            } catch (e) {
              print('Failed to decode image for doc ${doc.id}: $e');
            }
          }
        }

        setState(() {
          imageBytesList = images;
          _loading = false;
        });
      } else {
        setState(() {
          title = 'Product not found';
          _loading = false;
        });
      }
    } catch (e) {
      print('Error fetching product or images: $e');
      setState(() {
        title = 'Error loading product';
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWithSearchWidget(
        title: 'Profile',
        showBackButton: true,
        showSearch: true,
        // hideTitle: _isScrollingDown, // 🔥 fade out when scrolling
      ),
      body: SingleChildScrollView(
        // controller: _scrollController,
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 8,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Image Carousel with Favorite Icon
                      SizedBox(
                        height: 338,
                        width: double.infinity,
                        child: Stack(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: _loading
                                  ? Hero(
                                      tag: 'hero${widget.id}2',
                                      child: ProductImageCarousel(
                                        imageBytesList: widget.cachedImages,
                                      ),
                                    )
                                  : Hero(
                                      tag: 'hero${widget.id}2',
                                      child: ProductImageCarousel(
                                        imageBytesList: imageBytesList,
                                      ),
                                    ),
                            ),
                            Positioned(
                              top: 0,
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: const BoxDecoration(
                                  color: AppColors.lightBeige,
                                  shape: BoxShape.circle,
                                ),
                                child: FavoriteButtonWidget(
                                  productId: widget.id,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Product Info
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Text(
                                title ?? '...',
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
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    price != null ? 'TMT $price' : '...',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w200,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  if (discount != null)
                                    Text(
                                      discount!,
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
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Description',
                                  style: TextStyle(fontSize: 26),
                                ),
                                Row(
                                  children: [
                                    ...List.generate(
                                      fullStars,
                                      (_) => const Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                        size: 16,
                                      ),
                                    ),
                                    if (hasHalfStar)
                                      const Icon(
                                        Icons.star_half,
                                        color: Colors.amber,
                                        size: 16,
                                      ),
                                    ...List.generate(
                                      5 - fullStars - (hasHalfStar ? 1 : 0),
                                      (_) => const Icon(
                                        Icons.star_border,
                                        color: Colors.amber,
                                        size: 16,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(rating.toStringAsFixed(1)),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              description ?? '...',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w200,
                              ),
                            ),
                            const SizedBox(height: 8),
                            SizedBox(
                              width: double.infinity,
                              child: AddBagButtonWidget(productId: widget.id),
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
        ),
      ),
    );
  }
}
