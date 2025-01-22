import 'package:flutter/material.dart';

const Color clrBase = Color(0xFF1e1e2e);
const Color clrText = Color(0xFFcdd6f4);

final ThemeData enderNoteTheme = ThemeData(
  colorScheme: const ColorScheme.dark(primary: clrText),
  useMaterial3: true,
  scaffoldBackgroundColor: clrBase,
  appBarTheme: const AppBarTheme(
    scrolledUnderElevation: 0,
    backgroundColor: clrBase,
    foregroundColor: clrText,
    titleTextStyle: TextStyle(
      fontSize: 16,
      color: clrText,
    ),
  ),
  textTheme: const TextTheme(
    bodyMedium: TextStyle(color: clrText),
    bodyLarge: TextStyle(color: clrText),
  ),
  iconButtonTheme: const IconButtonThemeData(
    style: ButtonStyle(
      iconColor: WidgetStatePropertyAll(clrText),
      fixedSize: WidgetStatePropertyAll(Size(50, 50)),
    ),
  ),
  textButtonTheme: const TextButtonThemeData(
    style: ButtonStyle(
      foregroundColor: WidgetStatePropertyAll(clrText),
    ),
  ),
  elevatedButtonTheme: const ElevatedButtonThemeData(
    style: ButtonStyle(
      foregroundColor: WidgetStatePropertyAll(clrBase),
      backgroundColor: WidgetStatePropertyAll(clrText),
    ),
  ),
  drawerTheme: const DrawerThemeData(
    backgroundColor: clrBase,
  ),
  listTileTheme: const ListTileThemeData(
    iconColor: clrText,
    textColor: clrText,
  ),
  bottomSheetTheme: const BottomSheetThemeData(
    backgroundColor: clrBase,
  ),
  inputDecorationTheme: const InputDecorationTheme(
    floatingLabelStyle: TextStyle(color: clrText),
    border: OutlineInputBorder(),
    labelStyle: TextStyle(color: clrText),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: clrText),
    ),
  ),
  checkboxTheme: const CheckboxThemeData(
    checkColor: WidgetStatePropertyAll(clrBase),
    fillColor: WidgetStatePropertyAll(Colors.transparent),
    side: BorderSide.none,
  ),
);
