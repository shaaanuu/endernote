import 'package:flutter/material.dart';
import 'app_themes.dart';

const Color _clrBase = Color(0xFF1e1e2e);
const Color _clrText = Color(0xFFcdd6f4);

final ThemeData catppuccinMochaTheme = ThemeData(
  colorScheme: const ColorScheme.dark(primary: _clrText),
  useMaterial3: true,
  scaffoldBackgroundColor: _clrBase,
  appBarTheme: const AppBarTheme(
    scrolledUnderElevation: 0,
    backgroundColor: _clrBase,
    foregroundColor: _clrText,
    titleTextStyle: TextStyle(
      fontSize: 16,
      color: _clrText,
    ),
  ),
  textTheme: const TextTheme(
    bodyMedium: TextStyle(color: _clrText),
    bodyLarge: TextStyle(color: _clrText),
  ),
  iconButtonTheme: const IconButtonThemeData(
    style: ButtonStyle(
      iconColor: WidgetStatePropertyAll(_clrText),
      fixedSize: WidgetStatePropertyAll(Size(50, 50)),
    ),
  ),
  textButtonTheme: const TextButtonThemeData(
    style: ButtonStyle(
      foregroundColor: WidgetStatePropertyAll(_clrText),
    ),
  ),
  elevatedButtonTheme: const ElevatedButtonThemeData(
    style: ButtonStyle(
      foregroundColor: WidgetStatePropertyAll(_clrBase),
      backgroundColor: WidgetStatePropertyAll(_clrText),
    ),
  ),
  drawerTheme: const DrawerThemeData(
    backgroundColor: _clrBase,
  ),
  listTileTheme: const ListTileThemeData(
    iconColor: _clrText,
    textColor: _clrText,
  ),
  bottomSheetTheme: const BottomSheetThemeData(
    backgroundColor: _clrBase,
  ),
  inputDecorationTheme: InputDecorationTheme(
    floatingLabelStyle: const TextStyle(color: _clrText),
    border: const OutlineInputBorder(),
    labelStyle: const TextStyle(color: _clrText),
    hintStyle: TextStyle(
      color: _clrText.withAlpha(100),
      fontWeight: FontWeight.w100,
    ),
    enabledBorder: const OutlineInputBorder(
      borderSide: BorderSide(color: _clrText),
    ),
  ),
  extensions: const <ThemeExtension<dynamic>>{
    EndernoteColors(
      clrBase: _clrBase,
      clrText: _clrText,
    ),
  },
);
