import 'package:flutter/material.dart';

// heigh & width

class Config {
  double deviceHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  double deviceWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }
}

//light Colors

Color primary = Colors.red;
Color accent = const Color(0xff1F1F1F);
Color secondary = Colors.blue.shade100;

Color white = Colors.black;
Color black = Colors.white;

// Color primary = Colors.red;
// Color secondary = const Color(0xff1F1F1F);
// Color accent = Colors.blue;
// Color black = Colors.black;
// Color white = Colors.white;

class MyTheme {
  Color primary;
  Color accent;
  Color secondary;
  Color white;
  Color black;

  MyTheme(
      {required this.accent,
      required this.black,
      required this.primary,
      required this.secondary,
      required this.white});
}

MyTheme lighttheme = MyTheme(
  primary: Colors.red,
  accent: const Color(0xff1F1F1F),
  secondary: Colors.blue.shade100,
  white: Colors.black,
  black: Colors.white,
);

MyTheme dark = MyTheme(
  primary: Colors.red,
  secondary: const Color(0xff1F1F1F),
  accent: Color(0xFF2196F3),
  black: Colors.black,
  white: Colors.white,
);
