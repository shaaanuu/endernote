import 'package:flutter/material.dart';

import 'catppuccin_mocha.dart';

class EndernoteColors extends ThemeExtension<EndernoteColors> {
  final Color clrBase;
  final Color clrText;

  const EndernoteColors({
    required this.clrBase,
    required this.clrText,
  });

  @override
  ThemeExtension<EndernoteColors> copyWith({
    Color? clrBase,
    Color? clrText,
  }) {
    return EndernoteColors(
      clrBase: clrBase ?? this.clrBase,
      clrText: clrText ?? this.clrText,
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
    );
  }
}

enum AppTheme {
  catppuccinMocha,
  // Add new themes here...
}

final Map<AppTheme, ThemeData> appThemeData = {
  AppTheme.catppuccinMocha: catppuccinMochaTheme,
  // Add other themes here...
};
