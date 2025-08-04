import 'dart:convert';
import 'dart:typed_data';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:perfume_store/widgets/card_widget.dart';
import 'loader_widgets/home_page_carousel_load_widget.dart';

class ScrollableCardWidget extends StatefulWidget {
  const ScrollableCardWidget({super.key});

  @override
  State<ScrollableCardWidget> createState() => _ScrollableCardWidgetState();
}

class _ScrollableCardWidgetState extends State<ScrollableCardWidget>
    with AutomaticKeepAliveClientMixin {
  static final ValueNotifier<List<CardWidget>> _cardCache = ValueNotifier([]);
  static bool _hasFetched = false;

  List<HomePageCarouselLoadWidget> cachedLoads = [
    HomePageCarouselLoadWidget(),
    HomePageCarouselLoadWidget(),
    HomePageCarouselLoadWidget(),
  ];

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    if (!_hasFetched) {
      _fetchCards();
    }
  }

  Future<void> _fetchCards() async {
    _hasFetched = true;

    final productsSnapshot = await FirebaseFirestore.instance
        .collection('products')
        .orderBy('date', descending: true)
        .limit(7)
        .get();

    List<CardWidget> tempCards = [];

    for (var doc in productsSnapshot.docs) {
      final title = doc['title'];
      final priceString = doc['price'];
      final discount = doc['discount'];
      final description = doc['description'];
      final productId = doc.id;

      final imagesSnapshot = await FirebaseFirestore.instance
          .collection('products')
          .doc(productId)
          .collection('images')
          .get();

      List<Uint8List> cachedImages = [];

      for (var imgDoc in imagesSnapshot.docs) {
        final base64String = imgDoc['image'].toString();
        if (base64String.isNotEmpty && base64String != 'null') {
          try {
            cachedImages.add(base64Decode(base64String));
          } catch (_) {
            // handle invalid image
          }
        }
      }

      tempCards.add(
        CardWidget(
          cachedImages: cachedImages,
          description: description,
          title: title,
          priceString: priceString,
          discount: discount,
          fullStars: 3,
          hasHalfStar: true,
          rating: 5,
          id: productId,
        ),
      );
    }

    _cardCache.value = tempCards;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return ValueListenableBuilder<List<CardWidget>>(
      valueListenable: _cardCache,
      builder: (context, cards, _) {
        if (cards.isEmpty) {
          return SizedBox(
            height: 420,
            child: CarouselSlider(
              items: cachedLoads,
              options: CarouselOptions(
                height: 400,
                autoPlay: true,
                enlargeCenterPage: true,
              ),
            ),
          );
        }

        return SizedBox(
          height: 420,
          child: CarouselSlider(
            items: cards,
            options: CarouselOptions(
              height: 400,
              autoPlay: true,
              enlargeCenterPage: true,
            ),
          ),
        );
      },
    );
  }
}
