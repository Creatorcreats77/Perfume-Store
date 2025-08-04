import 'package:flutter/material.dart';
import 'package:perfume_store/views/data/notifiers.dart';
import 'package:perfume_store/views/pages/app_pages/bag_page.dart';
import 'package:perfume_store/views/pages/app_pages/favorites_page.dart';
import 'package:perfume_store/views/pages/app_pages/home_page.dart';
import 'package:perfume_store/views/pages/app_pages/profile_page.dart';
import 'package:perfume_store/widgets/bottom_navigation_bar_widget.dart';

List<Widget> pages = [HomePage(), FavoritesPage(), BagPage(), ProfilePage()];

class WidgetTree extends StatelessWidget {
  const WidgetTree({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          ValueListenableBuilder(
            valueListenable: selectedPageNotifier,
            builder: (context, value, child) {
              return pages.elementAt(value);
            },
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: BottomNavigationBarWidget(),
          ),
        ],
      ),
    );
  }
}
