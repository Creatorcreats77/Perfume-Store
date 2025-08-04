import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';


void navigatorBlurWidget(BuildContext context, Widget page, String replace) {
  if (replace  == 'push') {
    Navigator.push(
      context,
      PageRouteBuilder(
        opaque: false, // Important for blur to show
        transitionDuration: Duration(milliseconds: 300),
        pageBuilder: (_, __, ___) => page,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return Stack(
            children: [
              // Blur layer
              BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 5 * animation.value,
                  sigmaY: 5 * animation.value,
                ),
                child: Container(
                  color: Colors.black.withOpacity(0.1 * animation.value), // Optional tint
                ),
              ),

              // Fade in the new page
              FadeTransition(
                opacity: animation,
                child: child,
              ),
            ],
          );
        },
      ),
    );
  } else if(replace == 'pushReplacement') {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        opaque: false, // Important for blur to show
        transitionDuration: Duration(milliseconds: 700),
        pageBuilder: (_, __, ___) => page,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return Stack(
            children: [
              // Blur layer
              BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 5 * animation.value,
                  sigmaY: 5 * animation.value,
                ),
                child: Container(
                  color: Colors.black.withOpacity(0.1 * animation.value), // Optional tint
                ),
              ),

              // Fade in the new page
              FadeTransition(
                opacity: animation,
                child: child,
              ),
            ],
          );
        },
      ),
    );
  }
}
