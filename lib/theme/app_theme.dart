import 'package:flutter/material.dart';

import 'input_theme.dart';

ThemeData getTheme() {
  return ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xffff7518),
      primary: const Color(0xffff7518),
    ),
    fontFamily: 'Montserrat',
    useMaterial3: false,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: getAppBarTheme(),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
        // backgroundColor: Colors.white,
        // selectedItemColor: Color(0xffff7518),
        // unselectedItemColor: Colors.black,
        // unselectedIconTheme: IconThemeData(
        //   color: Colors.black,
        //   size: 30,
        // ),
        // selectedIconTheme: IconThemeData(
        //   color: Color(0xffff7518),
        //   size: 30,
        // ),
        // selectedLabelStyle: TextStyle(
        //   fontSize: 12,
        //   fontWeight: FontWeight.normal,
        // ),
        // unselectedLabelStyle: TextStyle(
        //   fontSize: 12,
        //   fontWeight: FontWeight.normal,
        // ),
        ),
    iconTheme: IconThemeData(
      color: Color(0xffff7518),
      size: 30,
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

extension ContextExtensions on BuildContext {
  double get rMinHeight => 720.0;
  double get rTabletWidth => 800.0;
  double get rLaptopWidth => 1024.0;
  double get rLargeLaptopWidth => 1440.0;

  bool get isSmallScreen => isPhone || isTablet;

  bool get isPhone => width < rTabletWidth;
  bool get isTablet => width < rLaptopWidth;
  bool get isLaptop => width >= rLaptopWidth && width < rLargeLaptopWidth;
  bool get isLargeLaptop => width >= rLargeLaptopWidth;

  double getResponsiveHorizontalPadding() {
    return isTablet
        ? 16
        : isLaptop
            ? (rLaptopWidth - rTabletWidth) / 2
            : (rLargeLaptopWidth - rLaptopWidth) / 2;
  }

  // * Theme
  ThemeData get theme => Theme.of(this);

  TextTheme get textTheme => theme.textTheme;
  InputDecorationTheme get inputDecorationTheme => theme.inputDecorationTheme;
  ElevatedButtonThemeData get elevatedButtonTheme => theme.elevatedButtonTheme;

  ColorScheme get colorScheme => theme.colorScheme;
  Color get primaryColor => theme.colorScheme.primary;
  Color get secondaryColor => theme.colorScheme.secondary;

  String get fontFamily => textTheme.bodyLarge!.fontFamily!;

  // * MediaQuery
  MediaQueryData get mediaQuery => MediaQuery.of(this);

  double get height => mediaQuery.size.height;
  double get width => mediaQuery.size.width;
  double get statusBarHeight => mediaQuery.padding.top;
  double get bottomBarHeight => mediaQuery.padding.bottom;

  //* Default Colors
  Color get appColorGreen => const Color(0xff317020);
  Color get appColorRed => const Color(0xffe74c3c);
  Color get appColorBlue => const Color(0xff204051);
  Color get appColorSubText => const Color(0xff4C5264);
  Color get appColorDisabledButton => const Color(0xffE4E4E4);
  Color get appColorGrey => const Color(0XFF6C6C6C);
  Color get appColorBackground => const Color(0xFFF2F5FA);
  Color get appColorWhite => const Color(0xFFFFFFFF);
  Color get appColorBlack => const Color(0XFF2e2e2e);

  // * Default Sizes
  double get elevation => 3.0;
  double get borderRadius => 20.0;
}
