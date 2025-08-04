import 'package:flutter/material.dart';
import 'package:perfume_store/theme/colors.dart';
import 'package:perfume_store/views/pages/products/brands_page.dart';
import 'package:perfume_store/views/pages/products/notes_page.dart';
import 'package:perfume_store/views/pages/products/olfactory_page.dart';
import 'package:perfume_store/views/pages/products/products_page.dart';

final Map<String, Widget> pagesMap = {
  'products': ProductsPage(),
  'brands': BrandsPage(),
  'olfactory': OlfactoryPage(),
  'notes': NotesPage(),
};

class SeeMoreWidget extends StatelessWidget {
  const SeeMoreWidget({super.key, required this.title, required this.page});

  final String title;
  final String page;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, left: 20, right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.charcoal,
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (_, __, ___) => pagesMap[page] ?? ProductsPage(),
                  transitionsBuilder: (_, anim, __, child) {
                    return FadeTransition(opacity: anim, child: child);
                  },
                ),
              );
            },
            child: Text(
              'See more ->',
              style: TextStyle(fontSize: 14, color: AppColors.brown),
            ),
          ),
        ],
      ),
    );
  }
}
