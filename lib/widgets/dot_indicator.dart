import 'package:flutter/material.dart';

class DotIndicator extends StatelessWidget {
  const DotIndicator({
    super.key,
    required this.activeIndex,
    required this.lengthPage,
  });

  final int activeIndex;

  final int lengthPage;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(lengthPage, (index) {
        return Container(
          width: 12,
          height: 12,
          margin: EdgeInsets.symmetric(horizontal: 6),
          decoration: BoxDecoration(
            color: index == activeIndex ? Colors.black : Colors.black38,
            shape: BoxShape.circle,
          ),
        );
      }),
    );
  }
}
