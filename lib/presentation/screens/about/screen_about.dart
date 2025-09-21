import 'package:flutter/material.dart';
import 'package:iconsax_linear/iconsax_linear.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../theme/app_themes.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_list_tile.dart';

class ScreenAbout extends StatelessWidget {
  const ScreenAbout({super.key});

  Future<String> _getAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        leadingIcon: IconsaxLinear.arrow_left_1,
        title: 'About',
        onLeading: () => Navigator.pop(context),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ListView(
          children: [
            ListTile(
              title: const Text(
                "Endernote",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              subtitle: Padding(
                padding: EdgeInsets.only(top: 8),
                child: Text(
                  'For those who want a simple note-taking app which is powerful yet uncluttered',
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
            Material(
              color: Theme.of(context)
                  .extension<EndernoteColors>()
                  ?.clrSecondary
                  .withAlpha(179),
              borderRadius: BorderRadius.circular(10),
              clipBehavior: Clip.antiAlias,
              child: ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(vertical: 4),
                shrinkWrap: true,
                itemCount: 4,
                separatorBuilder: (context, index) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  switch (index) {
                    case 0:
                      return FutureBuilder(
                        future: _getAppVersion(),
                        builder: (context, snapshot) => CustomListTile(
                          lead: IconsaxLinear.info_circle,
                          title: 'Version',
                          subtitle: snapshot.data ?? 'v?.?',
                        ),
                      );
                    case 1:
                      return const CustomListTile(
                        lead: IconsaxLinear.award,
                        title: 'Acknowledgments',
                        subtitle:
                            'Built by Endernote crafters with Flutter, using amazing tools like flutter_bloc and more.',
                      );
                    case 2:
                      return CustomListTile(
                        lead: IconsaxLinear.star,
                        title: 'Star us on Github',
                        subtitle:
                            'It will motivate us to work on cool projects like this.',
                        trail: IconsaxLinear.link,
                        onTap: () async => await launchUrl(
                          Uri.parse(
                              'https://www.github.com/shaaanuu/endernote'),
                        ),
                      );
                    case 3:
                      return CustomListTile(
                        lead: IconsaxLinear.message,
                        title: 'Support',
                        subtitle:
                            'Found an issue? Need help? Create an issue here.',
                        trail: IconsaxLinear.link,
                        onTap: () async => await launchUrl(
                          Uri.parse(
                              'https://www.github.com/shaaanuu/endernote/issues'),
                        ),
                      );
                    default:
                      return null;
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
