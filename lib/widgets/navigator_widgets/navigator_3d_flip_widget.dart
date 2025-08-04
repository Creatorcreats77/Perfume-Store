import 'dart:math';
import 'package:flutter/material.dart';


void navigator3dFlipWidget(BuildContext context, Widget page, String replace) {
  if (replace  == 'push') {
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: Duration(milliseconds: 700),
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final rotateAnim = Tween(begin: pi, end: 0.0).animate(
            CurvedAnimation(parent: animation, curve: Curves.easeInOut),
          );

          return AnimatedBuilder(
            animation: rotateAnim,
            child: child,
            builder: (context, child) {
              final isUnder = rotateAnim.value > pi / 2;
              final value = isUnder ? pi - rotateAnim.value : rotateAnim.value;

              final transform = Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..rotateY(value);

              return Transform(
                alignment: Alignment.center,
                transform: transform,
                child: child,
              );
            },
          );
        },
      ),
    );
  } else if(replace == 'pushReplacement') {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        transitionDuration: Duration(milliseconds: 700),
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final rotateAnim = Tween(begin: pi, end: 0.0).animate(
            CurvedAnimation(parent: animation, curve: Curves.easeInOut),
          );

          return AnimatedBuilder(
            animation: rotateAnim,
            child: child,
            builder: (context, child) {
              final isUnder = rotateAnim.value > pi / 2;
              final value = isUnder ? pi - rotateAnim.value : rotateAnim.value;

              final transform = Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..rotateY(value);

              return Transform(
                alignment: Alignment.center,
                transform: transform,
                child: child,
              );
            },
          );
        },
      ),
    );
  }
}
