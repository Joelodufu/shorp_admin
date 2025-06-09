import 'package:flutter/material.dart';

// Brand colors
const Color kBrandGold = Color(0xFFFFD700); // Gold
const Color kBrandBlack = Colors.black;

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: kBrandGold,
  colorScheme: ColorScheme.light(
    primary: kBrandGold,
    secondary: kBrandBlack,
    background: Colors.white,
    surface: Colors.white,
    onPrimary: kBrandBlack,
    onSecondary: Colors.white,
    onBackground: kBrandBlack,
    onSurface: kBrandBlack,
    error: Colors.red,
    onError: Colors.white,
  ),
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.white,
    foregroundColor: kBrandBlack,
    elevation: 0.5,
    iconTheme: IconThemeData(color: kBrandBlack),
    titleTextStyle: TextStyle(
      color: kBrandBlack,
      fontWeight: FontWeight.w600,
      fontSize: 20,
    ),
  ),
  inputDecorationTheme: const InputDecorationTheme(
    border: OutlineInputBorder(),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: kBrandGold),
    ),
    labelStyle: TextStyle(color: kBrandBlack),
    prefixIconColor: kBrandGold,
  ),
  cardColor: Colors.white,
  cardTheme: CardTheme(
    color: Colors.white,
    elevation: 1,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
  ),
  iconTheme: const IconThemeData(color: kBrandGold),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: kBrandGold,
    foregroundColor: kBrandBlack,
  ),
  snackBarTheme: const SnackBarThemeData(
    backgroundColor: kBrandGold,
    contentTextStyle: TextStyle(color: kBrandBlack),
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: kBrandBlack),
    bodyMedium: TextStyle(color: kBrandBlack),
    titleLarge: TextStyle(color: kBrandBlack, fontWeight: FontWeight.bold),
  ),
);