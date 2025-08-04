import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';


void navigatorSimpleWidget(BuildContext context, Widget page, String replace) {
  if (replace  == 'push') {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  } else if(replace == 'pushReplacement') {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }
}
