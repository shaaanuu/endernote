import 'package:flutter_bloc/flutter_bloc.dart';

import '../../presentation/theme/app_themes.dart';
import 'theme_events.dart';
import 'theme_states.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(ThemeState(AppTheme.catppuccinMocha)) {
    on<ChangeThemeEvent>((event, emit) {
      emit(ThemeState(event.theme));
    });
  }
}
