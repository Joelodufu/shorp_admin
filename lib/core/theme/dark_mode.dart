import 'package:flutter/material.dart';

// Brand colors
const Color kBrandGold = Color(0xFFFFD700); // Gold
const Color kBrandBlack = Colors.black;

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: kBrandGold,
  colorScheme: ColorScheme.dark(
    primary: kBrandGold,
    secondary: kBrandBlack,
    background: kBrandBlack,
    surface: Color(0xFF1A1A1A),
    onPrimary: kBrandBlack,
    onSecondary: kBrandGold,
    onBackground: Colors.white,
    onSurface: Colors.white,
    error: Colors.redAccent,
    onError: Colors.black,
  ),
  scaffoldBackgroundColor: kBrandBlack,
  appBarTheme: const AppBarTheme(
    backgroundColor: kBrandBlack,
    foregroundColor: kBrandGold,
    elevation: 0.5,
    iconTheme: IconThemeData(color: kBrandGold),
    titleTextStyle: TextStyle(
      color: kBrandGold,
      fontWeight: FontWeight.w600,
      fontSize: 20,
    ),
  ),
  inputDecorationTheme: const InputDecorationTheme(
    border: OutlineInputBorder(),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: kBrandGold),
    ),
    labelStyle: TextStyle(color: kBrandGold),
    prefixIconColor: kBrandGold,
  ),
  cardColor: Color(0xFF232323),
  cardTheme: CardTheme(
    color: Color(0xFF232323),
    elevation: 1,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(10)),
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
    bodyLarge: TextStyle(color: Colors.white),
    bodyMedium: TextStyle(color: Colors.white),
    titleLarge: TextStyle(color: kBrandGold, fontWeight: FontWeight.bold),
  ),
);