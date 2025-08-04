import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:perfume_store/theme/colors.dart';
import 'package:perfume_store/widgets/loader_widgets/card_load_widget.dart';
import 'package:perfume_store/widgets/loader_widgets/card_load_widget.dart';
import 'package:perfume_store/widgets/product_image_corousel_widget.dart';


class HomePageCarouselLoadWidget extends StatelessWidget {
  const HomePageCarouselLoadWidget({
    super.key,

  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return SizedBox(
      width: screenWidth,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.beige,
          borderRadius: BorderRadius.circular(20),
        ),
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            SizedBox(height: 70),
             Center(child:
             CircularProgressIndicator(),
             ),
          ],
        ),
      ),
    );
  }
}
