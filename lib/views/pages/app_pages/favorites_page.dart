import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:perfume_store/theme/colors.dart';
import 'package:perfume_store/widgets/app_bar_without_login_widget.dart';
import 'package:lottie/lottie.dart';
import 'package:perfume_store/widgets/product_widgets/favorite_button_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../widgets/main_product_fetching_data_widget.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  bool isUser = false;
  String userId = '';
  bool loading = true;
  String favoriteId = '';

  List<Map<String, dynamic>> favoriteProducts = [];

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final loggedIn = prefs.getBool('is_logged_in') ?? false;
    final id = prefs.getString('user_id') ?? '';

    setState(() {
      isUser = loggedIn;
      userId = id;
    });

    await _fetchFavoriteProducts();
  }

  Future<void> _fetchFavoriteProducts() async {
    if (!isUser) {
      setState(() {
        loading = false;
      });
      return;
    }

    final favoritesSnapshot = await FirebaseFirestore.instance
        .collection('phoneNumber')
        .doc(userId)
        .collection('favorites')
        .get();

    List<String> productIds = favoritesSnapshot.docs
        .map((doc) => doc.id)
        .toList();

    if (productIds.isEmpty) {
      setState(() {
        favoriteProducts = [];
        loading = false;
      });
      return;
    }

    List<Map<String, dynamic>> products = [];

    for (String id in productIds) {
      final productSnapshot = await FirebaseFirestore.instance
          .collection('products')
          .doc(id)
          .get();

      final imagesSnapshot = await FirebaseFirestore.instance
          .collection('products')
          .doc(id)
          .collection('images')
          .limit(1)
          .get();

      String? firstImageUrl;
      if (imagesSnapshot.docs.isNotEmpty) {
        firstImageUrl = imagesSnapshot.docs.first.data()['image'];
      }

      if (productSnapshot.exists) {
        final data = productSnapshot.data()!;
        products.add({
          'id': id,
          'title': data['title'],
          'price': data['price'],
          'discount': data['discount'],
          'imageString': firstImageUrl ?? '',
        });
      }
    }

    if (!mounted) return;

    setState(() {
      favoriteProducts = products;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWithoutLoginWidget(
        title: 'Favorites',
        showBackButton: false,
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : favoriteProducts.isEmpty
          ? _buildEmptyState()
          : _buildFavoritesList(),
    );
  }

  Widget _buildEmptyState() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 40),
        child: Column(
          children: [
            const SizedBox(height: 80),
            Center(child: Lottie.asset('assets/lotties/empty_box_girl.json')),
            const SizedBox(height: 24),
            Text(
              'No Favorites yet!',
              style: TextStyle(fontSize: 24, color: AppColors.brown),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _buildFavoritesList() {
    return ListView.builder(
      padding: const EdgeInsets.only(bottom:80,top: 16, left: 12, right: 12),
      itemCount: favoriteProducts.length,
      itemBuilder: (context, index) {
        final product = favoriteProducts[index];

        return Card(
          key: ValueKey(product['id']),
          elevation: 3,
          margin: const EdgeInsets.symmetric(vertical: 8,),
          child: InkWell(
            onTap: () {
              // Navigate to detail page when anywhere except favorite icon is tapped
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => MainProductFetchingDataWidget(
                    id: product['id'],
                    cachedImages: [base64Decode(product['imageString'])],
                  ),
                ),
              );
            },
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),

              // Product image on the left
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child:
                    product['imageString'] != null &&
                        product['imageString'] != ''
                    ? Hero(
                        tag: 'hero${product['id']}2',
                        child: Image.memory(
                          base64Decode(product['imageString']),
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Icon(
                        Icons.image_not_supported,
                        size: 60,
                        color: Colors.grey,
                      ),
              ),

              // Title and price in center
              title: Text(product['title'] ?? 'No Title'),
              subtitle: Text('Price: \$${product['price'].toString()}'),

              // Favorite icon on the right - handle tap separately
              trailing: FavoriteButtonWidget(
                productId: product['id'],
                onRemoved: () {
                  setState(() {
                    favoriteProducts.removeWhere((p) => p['id'] == product['id']);
                  });
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
