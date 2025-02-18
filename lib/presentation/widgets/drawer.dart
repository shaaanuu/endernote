import 'package:ficonsax/ficonsax.dart';
import 'package:flutter/material.dart';

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
  return Drawer(
    width: 250,
    child: ListView(
      padding: EdgeInsets.zero,
      children: [
        const DrawerHeader(
          child: Column(
            children: [
              CircleAvatar(radius: 50),
              Padding(
                padding: EdgeInsets.only(top: 10),
                child: Text(
                  'John Doe',
                  style: TextStyle(fontWeight: FontWeight.bold),
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
          icn: IconsaxOutline.clipboard_text,
          title: 'To-Dos',
          onTap: () => Navigator.popAndPushNamed(context, '/todos'),
        ),
        _tiles(
          icn: IconsaxOutline.setting_2,
          title: 'Settings',
          onTap: () => Navigator.popAndPushNamed(context, '/settings'),
        ),
      ],
    ),
  );
}
