import 'package:flutter/material.dart';

import 'catppuccin_mocha.dart';
import 'nord.dart';

class EndernoteColors extends ThemeExtension<EndernoteColors> {
  final Color clrBase;
  final Color clrText;
  final Color clrSecondary;
  final Color clrTextSecondary;

  const EndernoteColors({
    required this.clrBase,
    required this.clrText,
    required this.clrSecondary,
    required this.clrTextSecondary,
  });

  @override
  ThemeExtension<EndernoteColors> copyWith({
    Color? clrBase,
    Color? clrText,
    Color? clrSecondary,
    Color? clrTextSecondary,
  }) {
    return EndernoteColors(
      clrBase: clrBase ?? this.clrBase,
      clrText: clrText ?? this.clrText,
      clrSecondary: clrSecondary ?? this.clrSecondary,
      clrTextSecondary: clrTextSecondary ?? this.clrTextSecondary,
    );
  }

  @override
  ThemeExtension<EndernoteColors> lerp(
    ThemeExtension<EndernoteColors>? other,
    double t,
  ) {
    if (other is! EndernoteColors) {
      return this;
    }
    return EndernoteColors(
      clrBase: Color.lerp(clrBase, other.clrBase, t)!,
      clrText: Color.lerp(clrText, other.clrText, t)!,
      clrSecondary: Color.lerp(clrSecondary, other.clrSecondary, t)!,
      clrTextSecondary:
          Color.lerp(clrTextSecondary, other.clrTextSecondary, t)!,
    );
  }
}

enum AppTheme {
  catppuccinMocha,
  nordDark,
  nordLight,
  // Add new themes here...
}

final Map<AppTheme, ThemeData> appThemeData = {
  AppTheme.catppuccinMocha: catppuccinMochaTheme,
  AppTheme.nordDark: nordDarkTheme,
  AppTheme.nordLight: nordLightTheme,
  // Add other themes here...
};
