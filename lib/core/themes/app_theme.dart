import 'package:flutter/material.dart';
import '../constants/colors.dart';

ThemeData appTheme(BuildContext context) {
  return ThemeData(
    fontFamily: 'Nunito',
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.background,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white,
      elevation: 0,
    ),
  );
}