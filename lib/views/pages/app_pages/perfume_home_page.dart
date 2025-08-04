import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:perfume_store/widgets/app_bar_with_search_widget.dart';
import 'package:perfume_store/widgets/card_internet/product_card_fetching_data_widget.dart';
import 'package:perfume_store/widgets/main_product_widget.dart';
import 'package:perfume_store/widgets/product_card_widget.dart';

class PerfumeHomePage extends StatefulWidget {
  const PerfumeHomePage({
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
  State<PerfumeHomePage> createState() => _PerfumeHomePageState();
}

class _PerfumeHomePageState extends State<PerfumeHomePage> {
  final ScrollController _scrollController = ScrollController();

  bool _isScrollingDown = false;

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.userScrollDirection ==
        ScrollDirection.reverse) {
      if (!_isScrollingDown) {
        setState(() {
          _isScrollingDown = true;
        });
        Text("Scrooled down");
      }
    }

    if (_scrollController.position.userScrollDirection ==
        ScrollDirection.forward) {
      if (_isScrollingDown) {
        setState(() {
          _isScrollingDown = false;
        });
        Text("Scrooled down");
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWithSearchWidget(
        title: 'Profile',
        showBackButton: true,
        showSearch: true,
        hideTitle: _isScrollingDown, // 🔥 fade out when scrolling
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: MainProductWidget(
                  cachedImages: widget.cachedImages,
                  title: widget.title,
                  description: widget.description,
                  price: widget.priceString,
                  discount: widget.discount,
                  fullStars: widget.fullStars,
                  hasHalfStar: widget.hasHalfStar,
                  rating: widget.rating,
                  id: widget.id,
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
