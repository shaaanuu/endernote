import 'package:flutter/material.dart';
import 'package:iconsax_linear/iconsax_linear.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../theme/app_themes.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_list_tile.dart';

class ScreenAbout extends StatelessWidget {
  const ScreenAbout({super.key});

  @override
  Widget build(BuildContext context) {
    Future<String> getAppVersion() async {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();

      return packageInfo.version;
    }

    return Scaffold(
      appBar: CustomAppBar(
        leadingIcon: IconsaxLinear.arrow_left_1,
        title: 'About',
        onLeading: () => Navigator.pop(context),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: [
            ListTile(
              title: const Text(
                "Organize your shitty brain",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              subtitle: Padding(
                padding: EdgeInsets.only(top: 8),
                child: Text(
                  'Kinda feel messy or shitty when it comes to clear thinking? Don’t worry—Endernote’s got your back. '
                  'Capture your chaos, organize your thoughts, and get back to what really matters.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Theme.of(context)
                        .extension<EndernoteColors>()
                        ?.clrTextSecondary,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            FutureBuilder(
              future: getAppVersion(),
              builder: (context, snapshot) => CustomListTile(
                lead: IconsaxLinear.info_circle,
                title: 'Version',
                subtitle: snapshot.data,
              ),
            ),
            const CustomListTile(
              lead: IconsaxLinear.award,
              title: 'Acknowledgments',
              subtitle:
                  'Built by Endernote crafters with Flutter, using amazing tools like flutter_bloc and more.',
            ),
            CustomListTile(
              lead: IconsaxLinear.star,
              title: 'Star us on Github',
              subtitle:
                  'It will motivate us to work on cool projects like this.',
              trail: IconsaxLinear.link,
              onTap: () async => await launchUrl(
                Uri.parse('https://www.github.com/shaaanuu/endernote'),
              ),
            ),
            CustomListTile(
              lead: IconsaxLinear.message,
              title: 'Support',
              subtitle: 'Found an issue? Need help? Create an issue here.',
              trail: IconsaxLinear.link,
              onTap: () async => await launchUrl(
                Uri.parse('https://www.github.com/shaaanuu/endernote/issues'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
