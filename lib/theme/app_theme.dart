import 'package:flutter/material.dart';

import 'input_theme.dart';

ThemeData getTheme() {
  return ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xff8B5FBF),
      primary: const Color(0xff8B5FBF),
    ),
    fontFamily: 'Montserrat',
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: getAppBarTheme(),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: Color(0xff8B5FBF),
      unselectedItemColor: Colors.black,
      unselectedIconTheme: IconThemeData(
        color: Colors.black,
        size: 30,
      ),
      selectedIconTheme: IconThemeData(
        color: Color(0xff8B5FBF),
        size: 30,
      ),
      selectedLabelStyle: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.normal,
      ),
      unselectedLabelStyle: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.normal,
      ),
    ),
    inputDecorationTheme: getInputDecorationTheme(),
    dropdownMenuTheme: DropdownMenuThemeData(
      menuStyle: MenuStyle(
        surfaceTintColor: MaterialStateProperty.all(Colors.white),
        backgroundColor: MaterialStateProperty.all(Colors.white),
        side: MaterialStateProperty.all(
          const BorderSide(
            color: Colors.transparent,
          ),
        ),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(
          horizontal: 50,
          vertical: 20,
        ),
      ),
    ),
  );
}

AppBarTheme getAppBarTheme() {
  return const AppBarTheme(
    backgroundColor: Colors.white,
    foregroundColor: Colors.black,
    shadowColor: Colors.transparent,
    titleTextStyle: TextStyle(
      color: Colors.black54,
      fontSize: 20,
      fontWeight: FontWeight.normal,
    ),
  );
}
