import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../presentation/theme/app_themes.dart';
import 'theme_events.dart';
import 'theme_states.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(ThemeState(AppTheme.catppuccinMocha)) {
    on<ChangeThemeEvent>((event, emit) async {
      final prefs = await SharedPreferences.getInstance();
      emit(ThemeState(event.theme));
      prefs.setString("selectedTheme", event.theme.name);
    });

    on<LoadSavedThemeEvent>((event, emit) {
      emit(ThemeState(event.theme));
    });

    _loadSavedTheme();
  }

  Future<void> _loadSavedTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final savedTheme = prefs.getString("selectedTheme");
    if (savedTheme != null) {
      final theme = AppTheme.values.byName(savedTheme);
      add(LoadSavedThemeEvent(theme));
    }
  }
}
