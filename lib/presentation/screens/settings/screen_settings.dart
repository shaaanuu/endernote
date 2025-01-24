import 'package:ficonsax/ficonsax.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../bloc/theme/theme_bloc.dart';
import '../../../bloc/theme/theme_events.dart';
import '../../../bloc/theme/theme_states.dart';
import '../../theme/app_themes.dart';
import '../../widgets/custom_list_tile.dart';

class ScreenSettings extends StatelessWidget {
  const ScreenSettings({super.key});

  @override
  Widget build(BuildContext context) {
    const FlutterSecureStorage secureStorage = FlutterSecureStorage();

    Future fetchNameAndEmail() async => [
          await secureStorage.read(key: "email"),
          await secureStorage.read(key: "displayName"),
        ];

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(IconsaxOutline.arrow_left_2),
        ),
        title: const Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: [
            FutureBuilder(
              future: fetchNameAndEmail(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return CustomListTile(
                  lead: IconsaxOutline.user,
                  title: snapshot.data[1] ?? "Not logged in",
                  subtitle: snapshot.data[0] ?? "Not logged in",
                  onTap: () => Navigator.pushNamed(context, "/sign_in"),
                );
              },
            ),
            const CustomListTile(
                lead: IconsaxOutline.global_refresh,
                title: 'Sync',
                // subtitle: 'Sync to Cloud',
                subtitle: 'Currently unavailable'
                // onTap: () {
                //   context.read<SyncBloc>().add(SyncDirectoryToFirebase());
                //   context.read<SyncBloc>().add(SyncFirebaseToDirectory());

                //   ScaffoldMessenger.of(context).showSnackBar(
                //     const SnackBar(
                //       backgroundColor: Color(0xFF181825),
                //       content: Text(
                //         'Please restart the app to see changes.',
                //         style: TextStyle(color: Color(0xFFbac2de)),
                //       ),
                //     ),
                //   );
                // },
                ),
            CustomListTile(
              lead: IconsaxOutline.logout,
              title: 'Logout',
              subtitle: 'Logout from the account',
              onTap: () {
                secureStorage.deleteAll();

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    backgroundColor: Color(0xFF181825),
                    content: Text(
                      'Please restart the app to see changes.',
                      style: TextStyle(color: Color(0xFFbac2de)),
                    ),
                  ),
                );
              },
            ),
            BlocBuilder<ThemeBloc, ThemeState>(
              builder: (context, state) => CustomListTile(
                lead: IconsaxOutline.brush_3,
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
                                      ? const Icon(IconsaxOutline.tick_circle)
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
          ],
        ),
      ),
    );
  }
}
