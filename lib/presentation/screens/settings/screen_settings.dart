import 'package:ficonsax/ficonsax.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../bloc/sync/sync_bloc.dart';

class ScreenSettings extends StatelessWidget {
  const ScreenSettings({super.key});

  @override
  Widget build(BuildContext context) {
    const FlutterSecureStorage secureStorage = FlutterSecureStorage();

    Future<String?> fetchEmail() async =>
        await secureStorage.read(key: "email");

    Future<String?> fetchName() async =>
        await secureStorage.read(key: "displayName");

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(IconsaxOutline.arrow_left_2),
        ),
        title: const Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: [
            ListTile(
              leading: const Icon(IconsaxOutline.user),
              title: FutureBuilder(
                future: fetchName(),
                builder: (context, snapshot) => Text(
                  snapshot.data ?? "Not logged in",
                ),
              ),
              subtitle: FutureBuilder(
                future: fetchEmail(),
                builder: (context, snapshot) => Text(
                  snapshot.data ?? "Not logged in",
                ),
              ),
              onTap: () => Navigator.pushNamed(context, "/sign_in"),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(IconsaxOutline.global_refresh),
              title: const Text('Sync'),
              subtitle: const Text('Sync to cloud'),
              onTap: () {
                context.read<SyncBloc>().add(SyncIsarToFirebase());
                context.read<SyncBloc>().add(SyncFirebaseToIsar());
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(IconsaxOutline.brush_3),
              title: const Text('Theme'),
              subtitle: const Text('Catppuccin Mocha'),
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
                      ListTile(
                        title: const Text('Catppuccin Mocha'),
                        onTap: () {
                          Navigator.pop(context);

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              backgroundColor: Color(0xFF181825),
                              content: Text(
                                'Selected theme: Catppuccin Mocha.',
                                style: TextStyle(color: Color(0xFFbac2de)),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const Divider(),
          ],
        ),
      ),
    );
  }
}
