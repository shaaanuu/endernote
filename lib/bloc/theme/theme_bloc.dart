import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../presentation/theme/app_themes.dart';
import 'theme_events.dart';
import 'theme_states.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  ThemeBloc() : super(ThemeState(AppTheme.catppuccinMocha)) {
    _loadSavedTheme();

    on<ChangeThemeEvent>((event, emit) async {
      emit(ThemeState(event.theme));
      await _secureStorage.write(
        key: "selectedTheme",
        value: event.theme.toString(),
      );
    });

    on<LoadSavedThemeEvent>((event, emit) {
      emit(ThemeState(event.theme));
    });
  }

  Future<void> _loadSavedTheme() async {
    final savedTheme = await _secureStorage.read(key: "selectedTheme");
    if (savedTheme != null) {
      final theme = AppTheme.values.firstWhere(
        (theme) => theme.toString() == savedTheme,
        orElse: () => AppTheme.catppuccinMocha,
      );
      add(LoadSavedThemeEvent(theme));
    }
  }
}
