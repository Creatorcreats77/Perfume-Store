import 'package:flutter/material.dart';
import 'package:perfume_store/theme/colors.dart';
import 'package:perfume_store/views/widget_tree.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardLastPage extends StatefulWidget {
  const OnboardLastPage({super.key});

  @override
  State<OnboardLastPage> createState() => _OnboardLastPage2State();
}

class _OnboardLastPage2State extends State<OnboardLastPage> {
  bool showImage1 = true;
  bool showImage2 = false;
  bool showImage3 = false;
  bool isAnimating = false;

  Future<void> checkOnBoarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('checkOnBoarding', true);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          SizedBox(height: 50),
          Stack(
            children: [
              _buildImage('assets/images/parfume_without_cap.png', showImage1),
              _buildImage('assets/images/parfume_without_cap2.png', showImage2),
              _buildImage('assets/images/water_drop.png', showImage3),
            ],
          ),
          Text(
            textAlign: TextAlign.center,
            'Are you ready \n change air',
            style: TextStyle(
              fontSize: 42,
              fontWeight: FontWeight.bold,
              color: AppColors.charcoal,
            ),
          ),
          SizedBox(height: 8),
          Text(
            "You will like it do not afraid",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: AppColors.charcoalLight),
          ),
          SizedBox(height: 20),
          FractionallySizedBox(
            widthFactor: 0.8,
            child: ElevatedButton(
              onPressed: () {
                checkOnBoarding().then((_) {
                  _startAnimation();
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.charcoal,
                foregroundColor: AppColors.lightBeige,
                padding: EdgeInsets.symmetric(vertical: 14.0),
                // Controls height
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(26),
                ),
              ),
              child: Text('Start Animation'),
            ),
          ),
        ],
      ),
    );
    //  currentPage != 2 ?  DotIndicator(activeIndex: currentPage, lengthPage: pages.length): SizedBox.shrink(),
  }

  void _startAnimation() async {
    if (isAnimating) return;
    setState(() {
      isAnimating = true;
    });

    // Show Image 1
    setState(() {
      showImage1 = true;
    });
    await Future.delayed(Duration(milliseconds: 100));

    // Hide Image 1, show Image 2
    setState(() {
      showImage1 = false;
      showImage2 = true;
    });
    await Future.delayed(Duration(milliseconds: 100));

    // Show Image 3 on top of Image 2
    setState(() {
      showImage3 = true;
    });
    await Future.delayed(Duration(milliseconds: 1800));

    // Reset
    setState(() {
      showImage1 = true;
      showImage2 = false;
      showImage3 = false;
      isAnimating = false;
    });

    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => WidgetTree(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  Widget _buildImage(String asset, bool visible) {
    return AnimatedOpacity(
      opacity: visible ? 1.0 : 0.0,
      duration: Duration(milliseconds: 200),
      child: Container(
        width: 500,
        child: Image.asset(asset, fit: BoxFit.contain),
      ),
    );
  }
}
