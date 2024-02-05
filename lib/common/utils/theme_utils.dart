import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

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
        appBarTheme: const AppBarTheme(
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarIconBrightness: Brightness.dark,
          ),
        ),
      );
  }
}
