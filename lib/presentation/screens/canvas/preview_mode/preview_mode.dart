import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';

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
