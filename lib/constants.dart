import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:io' show Platform;

Color themeColor = const Color(0xFF7158EE);

TextStyle titleStyle = GoogleFonts.montserrat(
    textStyle: TextStyle(
  fontSize: Platform.isAndroid ? 16.0 : 20.0,
  fontWeight: FontWeight.w600,
  decoration: TextDecoration.none,
  color: const Color(0xFF181857),
));

TextStyle subtitleStyle = GoogleFonts.montserrat(
    textStyle: TextStyle(
  fontWeight: FontWeight.w500,
  color: Colors.black54,
  fontSize: Platform.isAndroid ? 10.0 : 12.0,
  letterSpacing: -0.2,
));

TextStyle textStyle = GoogleFonts.comfortaa(
    textStyle: TextStyle(
  fontWeight: FontWeight.w500,
  color: Colors.black54,
  fontSize: Platform.isAndroid ? 12.0 : 16.0,
  letterSpacing: -0.2,
));
