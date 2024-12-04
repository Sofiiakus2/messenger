import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


const primaryColor = Color(0xFFb0c6fa);
const secondaryColor = Color(0xFFdfe9fd);
const thirdColor = Color(0xFF3f72f4);
const fourthColor = Color(0xFF000000);
const backgroundColor = Colors.white;

final themeData = ThemeData();

final lightTheme = ThemeData(
  useMaterial3: true,
  primaryColor: primaryColor,
  textTheme: textTheme,

  popupMenuTheme: PopupMenuThemeData(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(16)),
    ),
  ),
  scaffoldBackgroundColor: backgroundColor,
  colorScheme: ColorScheme.fromSeed(
    seedColor: primaryColor,
    brightness: Brightness.dark,
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    //  backgroundColor: dividerColor,
    selectedItemColor: primaryColor,
    unselectedItemColor: Colors.grey,
    showSelectedLabels: false,
    showUnselectedLabels: false,
    elevation: 8,
    type: BottomNavigationBarType.fixed,
  ),
);

final textTheme = TextTheme(
  titleSmall: GoogleFonts.montserrat(
      fontSize: 18,
      fontWeight: FontWeight.w500,
      color: Colors.grey
  ),
  titleMedium: GoogleFonts.montserrat(
      fontSize: 18,
      fontWeight: FontWeight.w700,
      color: Colors.white
  ),
  labelSmall: GoogleFonts.montserrat(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: Colors.white
  ),
  labelMedium: GoogleFonts.montserrat(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: Colors.white
  ),
  labelLarge: GoogleFonts.montserrat(
      fontSize: 30,
      fontWeight: FontWeight.w800,
      color: Colors.black
  ),
  bodySmall: GoogleFonts.montserrat(
      fontSize: 16,
      fontWeight: FontWeight.w300,
      color: Colors.black
  ),

);