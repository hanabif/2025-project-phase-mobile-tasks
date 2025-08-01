import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

class AppTextStyles {
  static const TextStyle title = TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: AppConstants.titleFontSize,
    color: AppConstants.textPrimaryColor,
  );
  
  static const TextStyle subtitle = TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: AppConstants.subtitleFontSize,
    color: AppConstants.textPrimaryColor,
  );
  
  static const TextStyle body = TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: AppConstants.bodyFontSize,
    color: AppConstants.textSecondaryColor,
  );
  
  static const TextStyle price = TextStyle(
    fontSize: AppConstants.subtitleFontSize,
    fontWeight: FontWeight.w500,
  );
  
  static const TextStyle rating = TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: AppConstants.bodyFontSize,
  );
  
  static const TextStyle header = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppConstants.textPrimaryColor,
  );
} 