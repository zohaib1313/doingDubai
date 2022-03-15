import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppColors {
  static Color kPrimary = Color(0xffba9b27);
  // static Color yellowColorDark = const Color(0xffFFD700);
  // static Color yellowColorLight = const Color(0xffFCC201);
  // static Color scaffoldColor = const Color(0xffE5E5E5);

  static Color error = Colors.red[700]!;
  static final Color primaryColor = const Color(0xffba9b27);
  static final Color primaryColorLite = Color(0xffffee58);
  static final Color primarySwatchColor = Colors.yellow;
  static final Color primaryDarkColor = Colors.yellow;
  static final Color blackColor = Colors.black;
  static final Color whiteColor = Colors.white;

  static final ThemeData knarkzThemeData = ThemeData(
    fontFamily: 'roboto',
    brightness: Brightness.light,
    primarySwatch: Colors.red,
    primaryColor: primaryDarkColor,
    primaryColorDark: primarySwatchColor,
    accentColor: primaryColor,
  );
}
