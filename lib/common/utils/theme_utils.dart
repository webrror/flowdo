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
        colorSchemeSeed: Colors.indigo,
        useMaterial3: useMaterial3,
        scaffoldBackgroundColor: Colors.black,
        segmentedButtonTheme: SegmentedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: MaterialStateColor.resolveWith(
              (states) => Colors.white10,
            ),
          ),
        ),
        bottomSheetTheme: BottomSheetThemeData(
          modalBarrierColor: Colors.black.withOpacity(0.15),
        ),
        appBarTheme: const AppBarTheme(
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarIconBrightness: Brightness.light,
            statusBarColor: Colors.transparent,
          ),
        ),
      );
    case Brightness.light:
      return ThemeData(
        brightness: brightness,
        fontFamily: customFontFamily,
        useMaterial3: useMaterial3,
        colorSchemeSeed: Colors.indigo,
        segmentedButtonTheme: SegmentedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: MaterialStateColor.resolveWith(
              (states) => Colors.white10,
            ),
          ),
        ),
        bottomSheetTheme: BottomSheetThemeData(
          modalBarrierColor: Colors.white.withOpacity(0.08),
        ),
        appBarTheme: const AppBarTheme(
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarIconBrightness: Brightness.dark,
            statusBarColor: Colors.transparent,
          ),
        ),
      );
  }
}

// Misc methods
Color getSurfaceColor(BuildContext context) {
  return Colors.transparent;
}

Color getBorderColor(BuildContext context) {
  return Theme.of(context).brightness == Brightness.dark ? Colors.white10 : Colors.black12;
}

Color getAppBlurColor(BuildContext context) {
  return Theme.of(context).brightness == Brightness.dark ? Colors.black12 : Colors.white54;
}