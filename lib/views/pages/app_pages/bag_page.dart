import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:perfume_store/theme/colors.dart';
import 'package:perfume_store/widgets/app_bar_without_login_widget.dart';
import 'package:lottie/lottie.dart';
import 'package:perfume_store/widgets/main_product_fetching_data_widget.dart';
import 'package:perfume_store/widgets/product_widgets/add_bag_button_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class BagPage extends StatefulWidget {
  const BagPage({super.key});

  @override
  State<BagPage> createState() => _BagPageState();
}

class _BagPageState extends State<BagPage> {
  bool isUser = false;
  String userId = '';
  bool loading = true;

  List<Map<String, dynamic>> bagProducts = [];
  Map<String, int> quantities = {};

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

    await _fetchBagProducts();
  }

  Future<void> _fetchBagProducts() async {
    if (!isUser) {
      setState(() {
        loading = false;
      });
      return;
    }

    final bagSnapshot = await FirebaseFirestore.instance
        .collection('phoneNumber')
        .doc(userId)
        .collection('storeBag')
        .get();

    List<String> productIds = bagSnapshot.docs.map((doc) => doc.id).toList();

    if (productIds.isEmpty) {
      setState(() {
        bagProducts = [];
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

        quantities[id] = 1; // Default quantity = 1
      }
    }

    if (!mounted) return;

    setState(() {
      bagProducts = products;
      loading = false;
    });
  }

  double _calculateTotal() {
    double total = 0;
    for (var product in bagProducts) {
      final price = int.tryParse(product['price']) ?? 0;
      final qty = quantities[product['id']] ?? 1;
      total += price * qty;
    }
    return total;
  }

  void _incrementQuantity(String id) {
    setState(() {
      quantities[id] = (quantities[id] ?? 1) + 1;
    });
  }

  void _decrementQuantity(String id) {
    if ((quantities[id] ?? 1) > 1) {
      setState(() {
        quantities[id] = quantities[id]! - 1;
      });
    }
  }

  void _placeOrder() async {
    if (bagProducts.isEmpty) return;

    String adminPhoneNumber =
        "+99371334340"; // Replace with admin's real number

    StringBuffer message = StringBuffer();
    message.writeln("🛍 Order Details:");

    for (var product in bagProducts) {
      final title = product['title'] ?? 'Unknown';
      final price = int.tryParse(product['price']) ?? 0;
      final qty = quantities[product['id']] ?? 1;
      final totalPrice = price * qty;

      message.writeln("- $title x$qty = $totalPrice TMT");
    }

    message.writeln("--------");
    message.writeln("Total: ${_calculateTotal().toStringAsFixed(2)} TMT");

    final smsUri = Uri.parse(
      "sms:$adminPhoneNumber?body=${Uri.encodeComponent(message.toString())}",
    );

    if (await canLaunchUrl(smsUri)) {
      await launchUrl(smsUri);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Could not open SMS app")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWithoutLoginWidget(title: 'My bag', showBackButton: false),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : bagProducts.isEmpty
          ? _buildEmptyState()
          : Column(
              children: [
                Expanded(child: _buildBagList()),
                _buildSummarySection(),
              ],
            ),
    );
  }

  Widget _buildSummarySection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.lightBeige.withOpacity(0.9),
        border: const Border(top: BorderSide(color: Colors.grey, width: 0.5)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                'TMT ${_calculateTotal().toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _placeOrder,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.brown,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: const Text(
                'Order it',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildBagList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      itemCount: bagProducts.length,
      itemBuilder: (context, index) {
        final product = bagProducts[index];
        final qty = quantities[product['id']] ?? 1;

        return Card(
          elevation: 3,
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: ListTile(
            contentPadding: const EdgeInsets.all(12),
            leading: GestureDetector(
              onTap: () {
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
              child: ClipRRect(
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
                    : const Icon(
                        Icons.image_not_supported,
                        size: 60,
                        color: Colors.grey,
                      ),
              ),
            ),
            title: Text(product['title'] ?? 'No Title'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Price: TMT ${product['price'].toString()}'),
                const SizedBox(height: 4),
                Row(
                  children: [
                    IconButton(
                      onPressed: () => _decrementQuantity(product['id']),
                      icon: const Icon(Icons.remove_circle_outline),
                    ),
                    Text(
                      qty.toString(),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      onPressed: () => _incrementQuantity(product['id']),
                      icon: const Icon(Icons.add_circle_outline),
                    ),
                  ],
                ),
              ],
            ),
            trailing: AddBagButtonWidget(
              productId: product['id'],
              icon: 'icon',
              onRemoved: () {
                setState(() {
                  bagProducts.removeWhere((p) => p['id'] == product['id']);
                  quantities.remove(product['id']);
                });
              },
            ),
          ),
        );
      },
    );
  }
}

Widget _buildEmptyState() {
  return SingleChildScrollView(
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40),
      child: Column(
        children: [
          const SizedBox(height: 80),
          Center(child: Lottie.asset('assets/lotties/empty_box.json')),
          const SizedBox(height: 12),
          Text(
            'Buy something!',
            style: TextStyle(fontSize: 24, color: AppColors.brown),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 120),
        ],
      ),
    ),
  );
}
