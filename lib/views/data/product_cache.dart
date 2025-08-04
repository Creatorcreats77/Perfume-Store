import 'dart:typed_data';
import 'package:flutter/widgets.dart';

class ProductCache {
  /// Cache for product images (Base64-decoded Uint8List)
  static final Map<String, List<Uint8List>> imageCache = {};

  /// Cache for already-built product widgets (ProductCardFetchingDataWidget)
  static final Map<String, Widget> productCards = {};

  /// Cache for image loading futures (to prevent multiple loads)
  static final Map<String, Future<void>> imageLoaders = {};

  /// Clears all caches (optional utility method)
  static void clearAll() {
    imageCache.clear();
    productCards.clear();
    imageLoaders.clear();
  }

  /// Clears specific product data
  static void clearProduct(String productId) {
    imageCache.remove(productId);
    productCards.remove(productId);
    imageLoaders.remove(productId);
  }

  /// Checks if a product's image has already been loaded
  static bool isImageLoaded(String productId) {
    return imageCache.containsKey(productId);
  }

  /// Checks if a product card is cached
  static bool isProductCardCached(String productId) {
    return productCards.containsKey(productId);
  }
}
