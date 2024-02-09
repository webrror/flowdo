import 'package:flutter/material.dart';

/// Method to get screen's width 
double getScreenWidth(BuildContext context) {
  return MediaQuery.of(context).size.width;
}

/// Method to get screen's height 
double getScreenHeight(BuildContext context) {
  return MediaQuery.of(context).size.height;
}

/// Method to get bottom insets
double getBottomInsets(BuildContext context) {
  return MediaQuery.of(context).viewInsets.bottom;
}