import 'package:ficonsax/ficonsax.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

ListTile _tiles({
  required final IconData icn,
  required final String title,
  final void Function()? onTap,
}) {
  return ListTile(
    leading: Icon(
      icn,
    ),
    title: Text(
      title,
    ),
    onTap: onTap ?? () {},
  );
}

Widget showDrawer(BuildContext context) {
  FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  Future<String> fetchEmail() async =>
      await secureStorage.read(key: "displayName") ?? "Who...?";

  return Drawer(
    width: 250,
    child: ListView(
      padding: EdgeInsets.zero,
      children: [
        DrawerHeader(
          child: Column(
            children: [
              GestureDetector(
                child: const CircleAvatar(radius: 50),
                onTap: () => Navigator.popAndPushNamed(context, '/sign_in'),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: FutureBuilder(
                  future: fetchEmail(),
                  builder: (context, snapshot) {
                    String data;

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      data = "Loading...";
                    } else if (snapshot.hasError) {
                      data = "Error";
                    } else {
                      data = snapshot.data ?? "Who?";
                    }

                    return Text(
                      data,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        _tiles(
          icn: IconsaxOutline.folder,
          title: 'All Notes',
          onTap: () => Navigator.popAndPushNamed(context, '/home'),
        ),
        _tiles(
          icn: IconsaxOutline.heart,
          title: 'Favourite',
          onTap: () => Navigator.popAndPushNamed(context, '/favourite'),
        ),
        _tiles(
          icn: IconsaxOutline.setting_2,
          title: 'Settings',
          onTap: () => Navigator.popAndPushNamed(context, '/settings'),
        ),
        _tiles(
          icn: IconsaxOutline.book,
          title: 'About',
          onTap: () => Navigator.popAndPushNamed(context, '/about'),
        ),
      ],
    ),
  );
}
