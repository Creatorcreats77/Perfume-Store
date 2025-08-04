import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';


void navigatorSlideBonusWidget(BuildContext context, Widget page, String replace) {
  if (replace  == 'push') {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionDuration: Duration(milliseconds: 600),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          // Define a Tween for sliding from right to left
          final offsetTween = Tween<Offset>(
            begin: Offset(1.2, 0.0), // Start slightly offscreen right
            end: Offset.zero,
          );

          // Use a CurvedAnimation with a bounce effect
          final curvedAnimation = CurvedAnimation(
            parent: animation,
            curve: Curves.elasticOut,  // Bounce curve
          );

          return SlideTransition(
            position: offsetTween.animate(curvedAnimation),
            child: child,
          );
        },
      ),
    );

  } else if(replace == 'pushReplacement') {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionDuration: Duration(milliseconds: 600),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          // Define a Tween for sliding from right to left
          final offsetTween = Tween<Offset>(
            begin: Offset(1.2, 0.0), // Start slightly offscreen right
            end: Offset.zero,
          );

          // Use a CurvedAnimation with a bounce effect
          final curvedAnimation = CurvedAnimation(
            parent: animation,
            curve: Curves.elasticOut,  // Bounce curve
          );

          return SlideTransition(
            position: offsetTween.animate(curvedAnimation),
            child: child,
          );
        },
      ),
    );
  }
}
