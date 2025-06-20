import 'package:flutter/material.dart';

// Brand colors
const Color kBrandGold = Color.fromARGB(255, 217, 152, 0); // Gold
const Color kBrandBlack = Colors.black;

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: kBrandGold,
  colorScheme: ColorScheme.light(
    primary: kBrandGold,
    onPrimary: Colors.grey,
    onSecondary: Colors.white,
    error: Colors.red,
    onError: Colors.white,
  ),
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: const AppBarTheme(
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
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
  ),
  iconTheme: const IconThemeData(color: kBrandGold),

  snackBarTheme: const SnackBarThemeData(
    contentTextStyle: TextStyle(color: kBrandBlack),
  ),
  textTheme: const TextTheme(
    titleLarge: TextStyle(fontWeight: FontWeight.bold),
  ),
);
