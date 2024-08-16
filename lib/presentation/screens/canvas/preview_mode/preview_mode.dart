import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '../../../theme/markdown_theme.dart';
import '../screen_canvas.dart';

class PreviewMode extends StatelessWidget {
  const PreviewMode({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Markdown(
            data: textControl.text,
            styleSheet: mdTheme(),
          ),
        ),
      ],
    );
  }
}
