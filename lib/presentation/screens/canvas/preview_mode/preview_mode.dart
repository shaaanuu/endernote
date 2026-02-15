import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../theme/app_themes.dart';
import '../../../theme/markdown_theme.dart';

class PreviewMode extends StatelessWidget {
  const PreviewMode({super.key, required this.entityPath});

  final String entityPath;

  Future<String> _loadFileContent() async {
    try {
      return await File(entityPath).readAsString();
    } catch (e) {
      return "Error reading file: $e";
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height -
          (kToolbarHeight - MediaQuery.of(context).padding.top),
      child: FutureBuilder(
        future: _loadFileContent(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return Markdown(
              selectable: true,
              checkboxBuilder: (val) {
                return Transform.translate(
                  offset: const Offset(0, 2),
                  child: SizedBox(
                    height: 20,
                    child: Checkbox(
                      value: val,
                      side: BorderSide(
                        color: Theme.of(context)
                            .extension<EndernoteColors>()!
                            .clrText,
                        width: 1.5,
                      ),
                      activeColor: Theme.of(context)
                          .extension<EndernoteColors>()!
                          .clrText,
                      checkColor: Theme.of(context)
                          .extension<EndernoteColors>()!
                          .clrBase,
                      onChanged: (value) {},
                    ),
                  ),
                );
              },
              data: snapshot.data!,
              styleSheet: mdTheme(context),
              physics: const BouncingScrollPhysics(),
              onTapLink: (text, href, title) async {
                if (Uri.parse(href!).hasScheme) {
                  await launchUrl(Uri.parse(href));
                } else if (href.isNotEmpty) {
                  await launchUrl(Uri(scheme: 'https', path: href));
                }
              },
            );
          }
        },
      ),
    );
  }
}
