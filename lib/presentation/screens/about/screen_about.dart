import 'package:ficonsax/ficonsax.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ScreenAbout extends StatelessWidget {
  const ScreenAbout({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(IconsaxOutline.arrow_left_2),
        ),
        title: const Text('About'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: [
            const ListTile(
              title: Text(
                "Build Your Brain's Backup",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              subtitle: Padding(
                padding: EdgeInsets.only(top: 8),
                child: Text(
                  'Endernote is designed to help you organize your thoughts, ideas, and notes all in one place. '
                  'From creating new notes to easily accessing your favorite ones, Endernote simplifies the process of building your personal knowledge base.',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(height: 20),
            const ListTile(
              leading: Icon(IconsaxOutline.info_circle),
              title: Text('Version'),
              subtitle: Text('1.0.0'),
            ),
            const Divider(),
            const ListTile(
              leading: Icon(IconsaxOutline.award),
              title: Text('Acknowledgments'),
              subtitle: Text(
                'Built by Endernote crafters with Flutter, using amazing tools like flutter_bloc, Isar, and more.',
              ),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(IconsaxOutline.star),
              title: const Text('Star us on Github'),
              subtitle: const Text(
                'It will motivate us to work on cool projects like this.',
              ),
              trailing: const Icon(IconsaxOutline.link),
              onTap: () async {
                await launchUrl(Uri.parse(
                  'https://www.github.com/shaaanuu/endernote',
                ));
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(IconsaxOutline.message),
              title: const Text('Support'),
              subtitle: const Text(
                'Found an issue? Need help? Create an issue here.',
              ),
              trailing: const Icon(IconsaxOutline.link),
              onTap: () async {
                await launchUrl(Uri.parse(
                  'https://www.github.com/shaaanuu/endernote/issues',
                ));
              },
            ),
          ],
        ),
      ),
    );
  }
}
