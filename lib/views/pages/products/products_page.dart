import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:perfume_store/widgets/app_bar_with_search_widget.dart';
import 'package:perfume_store/widgets/loader_widgets/card_load_widget.dart';

import '../../../widgets/card_internet/product_card_fetching_data_widget.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage>
    with AutomaticKeepAliveClientMixin {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  final Map<String, List<Uint8List>> _imageCache = {};
  final Map<String, Future<void>> _imageLoaders = {};
  final Map<String, Future<void>> _imageLoadingFutures = {};
  final Map<String, Widget> _cachedProductCards = {};
  final int _limit = 10;
  List<DocumentSnapshot> _products = [];
  DocumentSnapshot? _lastDocument;
  String _searchQuery = '';
  bool _isLoading = false;
  bool _hasMore = true;
  bool _isScrollingDown = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _fetchProducts();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !_isLoading &&
        _hasMore) {
      _fetchProducts();
    }
    if (_scrollController.position.userScrollDirection ==
        ScrollDirection.reverse) {
      if (!_isScrollingDown) {
        setState(() => _isScrollingDown = true);
      }
    } else if (_scrollController.position.userScrollDirection ==
        ScrollDirection.forward) {
      if (_isScrollingDown) {
        setState(() => _isScrollingDown = false);
      }
    }
  }

  void _onSearchChanged(String value) {
    setState(() {
      _searchQuery = value.trim();
    });
    _fetchProducts(reset: true);
  }

  Future<void> _fetchProducts({bool reset = false}) async {
    if (_isLoading) return;

    if (reset) {
      setState(() {
        _products.clear();
        _lastDocument = null;
        _hasMore = true;
        _cachedProductCards.clear();
        _imageLoadingFutures.clear();
        _imageLoaders.clear();
      });
    }

    setState(() => _isLoading = true);

    Query query;

    if (_searchQuery.isNotEmpty) {
      query = FirebaseFirestore.instance
          .collection('products')
          .orderBy('title')
          .where('title', isGreaterThanOrEqualTo: _searchQuery)
          .where('title', isLessThan: _searchQuery + 'z')
          .limit(_limit);
    } else {
      query = FirebaseFirestore.instance
          .collection('products')
          .orderBy('date', descending: true)
          .limit(_limit);
    }

    if (_lastDocument != null) {
      query = query.startAfterDocument(_lastDocument!);
    }

    final snapshot = await query.get();

    if (snapshot.docs.isNotEmpty) {
      _lastDocument = snapshot.docs.last;
      setState(() {
        _products.addAll(snapshot.docs);
      });
    }

    if (snapshot.docs.length < _limit) {
      _hasMore = false;
    }

    setState(() => _isLoading = false);
  }

  Future<void> fetchAndCacheImages(String productId) async {
    if (_imageCache.containsKey(productId)) return;

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('products')
          .doc(productId)
          .collection('images')
          .get();

      final images = <Uint8List>[];

      for (final doc in snapshot.docs) {
        final base64 = doc['image'] ?? '';
        if (base64 != null &&
            base64.toString().isNotEmpty &&
            base64 != 'null') {
          final bytes = base64Decode(base64);
          images.add(bytes);
        }
      }

      if (images.isNotEmpty) {
        _imageCache[productId] = images;
      }
    } catch (e) {
      print('Failed to load images for $productId: $e');
    }
  }

  Future<void> _getImageFuture(String productId) {
    return _imageLoadingFutures.putIfAbsent(
      productId,
      () => fetchAndCacheImages(productId),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      extendBody: true,
      appBar: AppBarWithSearchWidget(
        title: 'Products',
        showBackButton: true,
        showSearch: true,
        hideTitle: _isScrollingDown,
        searchController: _searchController,
        onChanged: _onSearchChanged,
      ),
      body: GridView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.only(top: 12, left: 4, right: 4, bottom: 68),
        itemCount: _products.length + (_hasMore ? 1 : 0),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 0,
          mainAxisSpacing: 2,
          childAspectRatio: screenWidth / 564,
        ),
        itemBuilder: (context, index) {
          if (index >= _products.length) {
            return const CardLoadWidget();
          }

          final doc = _products[index];
          final id = doc.id;
          final data = doc.data() as Map<String, dynamic>;

          final title = data['title']?.toString() ?? 'No Title';
          final price = data['price'];
          final priceString = price != null ? "$price TMT" : "No price";
          final discount = data['discount'];
          final description = data['description'];
          final rating = double.tryParse(data['rating'].toString()) ?? 0.0;
          final fullStars = rating.floor();
          final hasHalfStar = (rating - fullStars) >= 0.5;

          if (!_imageLoaders.containsKey(id)) {
            _imageLoaders[id] = fetchAndCacheImages(id);
          }

          return _cachedProductCards[id] ??
              FutureBuilder<void>(
                future: _getImageFuture(id),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CardLoadWidget();
                  }

                  final cachedImages = _imageCache[id] ?? [];

                  final productCard = ProductCardFetchingDataWidget(
                    cachedImages: cachedImages,
                    title: title,
                    description: description,
                    priceString: priceString,
                    discount: discount,
                    fullStars: fullStars,
                    hasHalfStar: hasHalfStar,
                    rating: rating,
                    id: id,
                  );

                  _cachedProductCards[id] = productCard;
                  return productCard;
                },
              );
        },
      ),
    );
  }
}
