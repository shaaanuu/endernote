import '../../presentation/theme/app_themes.dart';

abstract class ThemeEvent {}

class ChangeThemeEvent extends ThemeEvent {
  final AppTheme theme;

  ChangeThemeEvent(this.theme);
}
