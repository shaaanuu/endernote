import 'package:flutter/material.dart';
import 'package:iconsax_linear/iconsax_linear.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../theme/app_themes.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    Future<String> getAppVersion() async {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();

      return packageInfo.version;
    }

    return Drawer(
      backgroundColor: Theme.of(context).extension<EndernoteColors>()?.clrBase,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                "Endernote",
                style: TextStyle(
                  fontFamily: 'SourceSans3Bold',
                  fontSize: 20,
                  color:
                      Theme.of(context).extension<EndernoteColors>()?.clrText,
                ),
              ),
            ),

            const Divider(height: 1),

            // Items
            _drawerItem(
              context,
              icon: IconsaxLinear.setting,
              label: "Settings",
              onTap: () => Navigator.pushNamed(context, '/settings'),
            ),
            _drawerItem(
              context,
              icon: IconsaxLinear.color_swatch,
              label: "Themes / Appearance",
              onTap: () => Navigator.pushNamed(context, '/settings'),
            ),
            _drawerItem(
              context,
              icon: IconsaxLinear.book,
              label: "About",
              onTap: () => Navigator.pushNamed(context, '/about'),
            ),

            const Spacer(),

            // Footer
            FutureBuilder(
              future: getAppVersion(),
              builder: (context, snapshot) => Padding(
                padding: const EdgeInsets.all(12),
                child: Text(
                  snapshot.data != null ? 'v${snapshot.data}' : 'v?.?',
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context)
                        .extension<EndernoteColors>()
                        ?.clrTextSecondary
                        .withAlpha(127),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _drawerItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required void Function()? onTap,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: Theme.of(context).extension<EndernoteColors>()?.clrTextSecondary,
      ),
      title: Text(
        label,
        style: TextStyle(
          fontSize: 16,
          color:
              Theme.of(context).extension<EndernoteColors>()?.clrTextSecondary,
        ),
      ),
      onTap: () {
        Navigator.pop(context);
        onTap!();
      },
    );
  }
}
