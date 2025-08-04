import 'package:flutter/material.dart';
import 'package:perfume_store/views/pages/on_boarding_pages/onboard_last_page.dart';
import 'package:perfume_store/views/pages/on_boarding_pages/onboard_page.dart';
import 'package:perfume_store/widgets/dot_indicator.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnBoardingScreen> {
  int currentPage = 0;

  final List<Widget> pages = [
    OnBoardPage(
      title: "Welcome to\n PerfumeStore",
      description: "Discover our exclusive fragrances.",
    ),
    OnBoardPage(
      title: "Choose \n like a dream",
      description: "Browse and buy your favorite perfumes.",
    ),
    OnboardLastPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Background Image
            Image.asset(
              'assets/icons/icon_bg.png', // Replace with your image path
              fit: BoxFit.cover,
            ),
            // Content
            Column(
              children: [
                Expanded(
                  child: PageView.builder(
                    itemCount: pages.length,
                    onPageChanged: _onPageChanged,
                    itemBuilder: (_, index) => pages[index],
                  ),
                ),
                const SizedBox(height: 20),
                DotIndicator(
                  activeIndex: currentPage,
                  lengthPage: pages.length,
                ),
                const SizedBox(height: 40),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _onPageChanged(int index) {
    setState(() {
      currentPage = index;
    });
  }
}
