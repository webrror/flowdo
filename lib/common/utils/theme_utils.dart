import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

/// Method to get app's theme
/// 
/// Pass in [Brightness] to `brightness` param
/// 
/// Pass to `customFontFamily` if want to use different font, by default `GoogleFonts.outfit().fontFamily`
ThemeData getAppTheme(
  BuildContext context, {
  required Brightness brightness,
  String? customFontFamily,
  bool useMaterial3 = true,
}) {
  customFontFamily = customFontFamily ?? GoogleFonts.outfit().fontFamily;
  switch (brightness) {
    case Brightness.dark:
      return ThemeData(
        fontFamily: customFontFamily,
        brightness: brightness,
        colorSchemeSeed: Colors.blue,
        useMaterial3: useMaterial3,
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: const AppBarTheme(
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarIconBrightness: Brightness.light,
          ),
        ),
      );
    case Brightness.light:
      return ThemeData(
        brightness: brightness,
        fontFamily: customFontFamily,
        useMaterial3: useMaterial3,
        colorSchemeSeed: Colors.blue,
        appBarTheme: const AppBarTheme(
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarIconBrightness: Brightness.dark,
          ),
        ),
      );
  }
}

// Misc methods
Color getSurfaceColor(BuildContext context) {
  switch (Theme.of(context).brightness) {
    case Brightness.dark:
      return Colors.white.withOpacity(0.005);
    case Brightness.light:
      return Colors.white.withOpacity(0);
  }
}

Color getBarrierColor(BuildContext context) {
  switch (Theme.of(context).brightness) {
    case Brightness.dark:
      return Colors.black.withOpacity(0.15);
    case Brightness.light:
      return Colors.white.withOpacity(0.1);
  }
}

Color getBorderColor(BuildContext context) {
  switch (Theme.of(context).brightness) {
    case Brightness.dark:
      return Colors.white10;
    case Brightness.light:
      return Colors.black12;
  }
}

Color getSegmentButtonBgColor(BuildContext context) {
  switch (Theme.of(context).brightness) {
    case Brightness.dark:
      return Colors.white10;
    case Brightness.light:
      return Colors.white24;
  }
}