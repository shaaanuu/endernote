import 'package:flutter/material.dart';

import 'app_themes.dart';

// Nord Dark Colors
const Color nordDarkBase = Color(0xFF2E3440);
const Color nordDarkText = Color(0xFFD8DEE9);
const Color nordDarkPrimary = Color(0xFF88C0D0);

// Nord Light Colors
const Color nordLightBase = Color(0xFFECEFF4);
const Color nordLightText = Color(0xFF2E3440);
const Color nordLightPrimary = Color(0xFF5E81AC);

final ThemeData nordDarkTheme = ThemeData(
  fontFamily: 'SourceSans3Regular',
  colorScheme: const ColorScheme.dark(primary: nordDarkPrimary),
  useMaterial3: true,
  scaffoldBackgroundColor: nordDarkBase,
  appBarTheme: const AppBarTheme(
    scrolledUnderElevation: 0,
    backgroundColor: nordDarkBase,
    foregroundColor: nordDarkText,
    titleTextStyle: TextStyle(
      fontSize: 16,
      color: nordDarkText,
    ),
  ),
  textTheme: const TextTheme(
    bodyMedium: TextStyle(color: nordDarkText),
    bodyLarge: TextStyle(color: nordDarkText),
  ),
  iconButtonTheme: const IconButtonThemeData(
    style: ButtonStyle(
      iconColor: WidgetStatePropertyAll(nordDarkText),
      fixedSize: WidgetStatePropertyAll(Size(50, 50)),
    ),
  ),
  textButtonTheme: const TextButtonThemeData(
    style: ButtonStyle(
      foregroundColor: WidgetStatePropertyAll(nordDarkText),
    ),
  ),
  elevatedButtonTheme: const ElevatedButtonThemeData(
    style: ButtonStyle(
      foregroundColor: WidgetStatePropertyAll(nordDarkBase),
      backgroundColor: WidgetStatePropertyAll(nordDarkPrimary),
    ),
  ),
  drawerTheme: const DrawerThemeData(
    backgroundColor: nordDarkBase,
  ),
  listTileTheme: const ListTileThemeData(
    iconColor: nordDarkText,
    textColor: nordDarkText,
  ),
  bottomSheetTheme: const BottomSheetThemeData(
    backgroundColor: nordDarkBase,
  ),
  inputDecorationTheme: InputDecorationTheme(
    floatingLabelStyle: const TextStyle(color: nordDarkText),
    border: const OutlineInputBorder(),
    labelStyle: const TextStyle(color: nordDarkText),
    hintStyle: TextStyle(
      color: nordDarkText.withAlpha(100),
      fontWeight: FontWeight.w100,
    ),
    enabledBorder: const OutlineInputBorder(
      borderSide: BorderSide(color: nordDarkText),
    ),
  ),
  checkboxTheme: const CheckboxThemeData(
    checkColor: WidgetStatePropertyAll(nordDarkBase),
    fillColor: WidgetStatePropertyAll(Colors.transparent),
    side: BorderSide.none,
  ),
  snackBarTheme: SnackBarThemeData(
    contentTextStyle: TextStyle(color: nordDarkText),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadiusGeometry.circular(10),
    ),
    behavior: SnackBarBehavior.floating,
    backgroundColor: nordDarkPrimary,
  ),
  extensions: const <ThemeExtension<dynamic>>{
    EndernoteColors(
      clrBase: nordDarkBase,
      clrText: nordDarkText,
      clrSecondary: nordDarkBase,
      clrTextSecondary: nordDarkText,
    ),
  },
);

final ThemeData nordLightTheme = ThemeData(
  fontFamily: 'SourceSans3Regular',
  colorScheme: const ColorScheme.light(primary: nordLightPrimary),
  useMaterial3: true,
  scaffoldBackgroundColor: nordLightBase,
  appBarTheme: const AppBarTheme(
    scrolledUnderElevation: 0,
    backgroundColor: nordLightBase,
    foregroundColor: nordLightText,
    titleTextStyle: TextStyle(
      fontSize: 16,
      color: nordLightText,
    ),
  ),
  textTheme: const TextTheme(
    bodyMedium: TextStyle(color: nordLightText),
    bodyLarge: TextStyle(color: nordLightText),
  ),
  iconButtonTheme: const IconButtonThemeData(
    style: ButtonStyle(
      iconColor: WidgetStatePropertyAll(nordLightText),
      fixedSize: WidgetStatePropertyAll(Size(50, 50)),
    ),
  ),
  textButtonTheme: const TextButtonThemeData(
    style: ButtonStyle(
      foregroundColor: WidgetStatePropertyAll(nordLightText),
    ),
  ),
  elevatedButtonTheme: const ElevatedButtonThemeData(
    style: ButtonStyle(
      foregroundColor: WidgetStatePropertyAll(nordLightBase),
      backgroundColor: WidgetStatePropertyAll(nordLightPrimary),
    ),
  ),
  drawerTheme: const DrawerThemeData(
    backgroundColor: nordLightBase,
  ),
  listTileTheme: const ListTileThemeData(
    iconColor: nordLightText,
    textColor: nordLightText,
  ),
  bottomSheetTheme: const BottomSheetThemeData(
    backgroundColor: nordLightBase,
  ),
  inputDecorationTheme: InputDecorationTheme(
    floatingLabelStyle: const TextStyle(color: nordLightText),
    border: const OutlineInputBorder(),
    labelStyle: const TextStyle(color: nordLightText),
    hintStyle: TextStyle(
      color: nordLightText.withAlpha(100),
      fontWeight: FontWeight.w100,
    ),
    enabledBorder: const OutlineInputBorder(
      borderSide: BorderSide(color: nordLightText),
    ),
  ),
  checkboxTheme: const CheckboxThemeData(
    checkColor: WidgetStatePropertyAll(nordLightBase),
    fillColor: WidgetStatePropertyAll(Colors.transparent),
    side: BorderSide.none,
  ),
  snackBarTheme: SnackBarThemeData(
    contentTextStyle: TextStyle(color: nordLightText),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadiusGeometry.circular(10),
    ),
    behavior: SnackBarBehavior.floating,
    backgroundColor: nordLightPrimary,
  ),
  extensions: const <ThemeExtension<dynamic>>{
    EndernoteColors(
      clrBase: nordLightBase,
      clrText: nordLightText,
      clrSecondary: nordLightBase,
      clrTextSecondary: nordLightText,
    ),
  },
);
