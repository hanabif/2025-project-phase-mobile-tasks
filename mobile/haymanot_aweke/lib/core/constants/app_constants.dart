import 'package:flutter/material.dart';

class AppConstants {
  // Colors
  static const Color primaryColor = Color(0xFF3F51F3);
  static const Color backgroundColor = Colors.white;
  static const Color textPrimaryColor = Color(0xFF3E3E3E);
  static const Color textSecondaryColor = Color(0xFFAAAAAA);
  static const Color starColor = Color(0xFFFFD700);
  static const Color shadowColor = Color(0x08000000);
  
  // Dimensions
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 20.0;
  static const double cardBorderRadius = 16.0;
  static const double productCardHeight = 240.0;
  static const double productCardWidth = 366.0;
  static const double productImageHeight = 160.0;
  
  // Font sizes
  static const double titleFontSize = 20.0;
  static const double subtitleFontSize = 14.0;
  static const double bodyFontSize = 12.0;
  
  // Shadows
  static const List<BoxShadow> defaultShadow = [
    BoxShadow(
      color: shadowColor,
      blurRadius: 4,
      offset: Offset(0, 4),
    ),
  ];
  
  // Border radius
  static const BorderRadius defaultBorderRadius = BorderRadius.all(
    Radius.circular(cardBorderRadius),
  );
} 