import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax_linear/iconsax_linear.dart';

import '../../../bloc/theme/theme_bloc.dart';
import '../../../bloc/theme/theme_events.dart';
import '../../../bloc/theme/theme_states.dart';
import '../../theme/app_themes.dart';
import '../../widgets/custom_list_tile.dart';

class ScreenSettings extends StatelessWidget {
  const ScreenSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(IconsaxLinear.arrow_left_1),
        ),
        title: const Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: [
            BlocBuilder<ThemeBloc, ThemeState>(
              builder: (context, state) => CustomListTile(
                lead: IconsaxLinear.brush_3,
                title: 'Theme',
                subtitle: state.theme.toString().split('.').last,
                onTap: () => showModalBottomSheet(
                  context: context,
                  builder: (context) => Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                      ),
                    ),
                    alignment: Alignment.center,
                    child: ListView(
                      children: [
                        const SizedBox(height: 20),
                        ...AppTheme.values.map(
                          (theme) {
                            return ListTile(
                              title: Text(theme.toString().split('.').last),
                              trailing:
                                  context.read<ThemeBloc>().state.theme == theme
                                      ? const Icon(IconsaxLinear.tick_circle)
                                      : null,
                              onTap: () {
                                context
                                    .read<ThemeBloc>()
                                    .add(ChangeThemeEvent(theme));
                                Navigator.pop(context);

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    backgroundColor:
                                        Theme.of(context).colorScheme.surface,
                                    content: Text(
                                      'Selected theme: ${theme.toString().split('.').last}.',
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            CustomListTile(
              lead: IconsaxLinear.book,
              title: 'About',
              subtitle: 'Crafted with care.',
              onTap: () => Navigator.pushNamed(context, '/about'),
            ),
          ],
        ),
      ),
    );
  }
}
