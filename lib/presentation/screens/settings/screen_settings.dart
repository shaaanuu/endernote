import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax_linear/iconsax_linear.dart';

import '../../../bloc/theme/theme_bloc.dart';
import '../../../bloc/theme/theme_events.dart';
import '../../../bloc/theme/theme_states.dart';
import '../../theme/app_themes.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_list_tile.dart';

class ScreenSettings extends StatelessWidget {
  const ScreenSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        leadingIcon: IconsaxLinear.arrow_left_1,
        title: 'Settings',
        onLeading: () => Navigator.pop(context),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Material(
          color: Theme.of(context)
              .extension<EndernoteColors>()
              ?.clrSecondary
              .withAlpha(179),
          borderRadius: BorderRadius.circular(10),
          clipBehavior: Clip.antiAlias,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 4),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 2,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              switch (index) {
                case 0:
                  return BlocBuilder<ThemeBloc, ThemeState>(
                    builder: (context, state) => CustomListTile(
                      lead: IconsaxLinear.brush_3,
                      title: 'Theme',
                      subtitle: state.theme.toString().split('.').last,
                      onTap: () => showModalBottomSheet(
                        context: context,
                        backgroundColor: Theme.of(context)
                            .extension<EndernoteColors>()
                            ?.clrBase,
                        shape: const RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(10)),
                        ),
                        builder: (context) => ListView(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          children: [
                            const SizedBox(height: 8),
                            ...AppTheme.values.map(
                              (theme) {
                                return ListTile(
                                  title: Text(
                                    theme.toString().split('.').last,
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .extension<EndernoteColors>()
                                          ?.clrText,
                                    ),
                                  ),
                                  trailing:
                                      context.read<ThemeBloc>().state.theme ==
                                              theme
                                          ? Icon(
                                              IconsaxLinear.tick_circle,
                                              color: Theme.of(context)
                                                  .extension<EndernoteColors>()
                                                  ?.clrText,
                                            )
                                          : null,
                                  onTap: () {
                                    context
                                        .read<ThemeBloc>()
                                        .add(ChangeThemeEvent(theme));
                                    Navigator.pop(context);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        backgroundColor: Theme.of(context)
                                            .colorScheme
                                            .surface,
                                        content: Text(
                                          'Selected theme: ${theme.toString().split('.').last}.',
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
                  );
                case 1:
                  return CustomListTile(
                    lead: IconsaxLinear.book,
                    title: 'About',
                    subtitle: 'Crafted with care.',
                    onTap: () => Navigator.pushNamed(context, '/about'),
                  );
                default:
                  return const SizedBox.shrink();
              }
            },
          ),
        ),
      ),
    );
  }
}
