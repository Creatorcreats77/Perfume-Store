import 'package:flutter/material.dart';
import 'package:perfume_store/widgets/app_bar_after_login_widget.dart';
import 'package:perfume_store/widgets/app_bar_without_login_widget.dart';
import 'package:perfume_store/widgets/banner_widget.dart';
import 'package:perfume_store/widgets/brands_widget.dart';
import 'package:perfume_store/widgets/filterd_chips_scroll_widget.dart';
import 'package:perfume_store/widgets/notes_widget.dart';
import 'package:perfume_store/widgets/olfactory_universe_widget.dart';
import 'package:perfume_store/widgets/scrollable_card_widget.dart';
import 'package:perfume_store/widgets/search_widget.dart';
import 'package:perfume_store/widgets/see_more_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {


  final categories = [
    {'label': 'All', 'icon': Icons.blur_on},
    {'label': 'Woody', 'icon': Icons.park},
    {'label': 'Floral', 'icon': Icons.local_florist},
    {'label': 'Fresh', 'icon': Icons.grass},
    {'label': 'Marine', 'icon': Icons.waves},
    {'label': 'Green', 'icon': Icons.eco},
    {'label': 'Musky', 'icon': Icons.pets},
  ];



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWithoutLoginWidget(
              title: 'Shop with us',
              showBackButton: false,
            ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const SizedBox(
              child: Column(children: [FilterdChipsScrollWidget()]),
            ),
            const SizedBox(height: 20),
            const BannerWidget(
              imageAssetPath: 'assets/images/banners/banner_1.webp',
              message: 'Discount just for you do!',
            ),
            const SeeMoreWidget(title: 'Buy Parfumes', page: 'products'),
            const SizedBox(child: ScrollableCardWidget()),
            const SizedBox(height: 10),
            const SeeMoreWidget(title: 'Explore by brands', page: 'brands'),
            const BrandsWidget(),
            const SizedBox(height: 20),
            const BannerWidget(
              imageAssetPath: 'assets/images/banners/banner_2.png',
              message: 'Perfume from PerfumeStore!',
            ),
            const SeeMoreWidget(title: 'Explore by notes', page: "notes"),
            const NotesWidget(),
            const SeeMoreWidget(title: 'Olfactory universe', page: 'olfactory'),
            const SizedBox(height: 10),
            const OlfactoryUniverseWidget(),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}
