import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';

import 'app_themes.dart';

MarkdownStyleSheet mdTheme(context) => MarkdownStyleSheet(
      h1: TextStyle(
        fontFamily: 'RobotoSlab',
        fontWeight: FontWeight.bold,
        fontSize: 28,
        height: 1.2,
        letterSpacing: 0.4,
        color: Theme.of(context).extension<EndernoteColors>()?.clrText,
      ),
      h2: TextStyle(
        fontFamily: 'RobotoSlab',
        fontSize: 24,
        height: 1.25,
        letterSpacing: 0.6,
        color: Theme.of(context).extension<EndernoteColors>()?.clrText,
      ),
      h3: TextStyle(
        fontFamily: 'RobotoSlab',
        fontSize: 21,
        height: 1.3,
        letterSpacing: 0.6,
        color: Theme.of(context).extension<EndernoteColors>()?.clrText,
      ),
      h4: TextStyle(
        fontFamily: 'RobotoSlab',
        fontSize: 19,
        height: 1.3,
        letterSpacing: 0.6,
        color: Theme.of(context).extension<EndernoteColors>()?.clrText,
      ),
      h5: TextStyle(
        fontFamily: 'RobotoSlab',
        fontSize: 17,
        height: 1.35,
        letterSpacing: 0.6,
        color: Theme.of(context).extension<EndernoteColors>()?.clrText,
      ),
      h6: TextStyle(
        fontFamily: 'RobotoSlab',
        fontSize: 16,
        height: 1.35,
        letterSpacing: 0.6,
        color: Theme.of(context).extension<EndernoteColors>()?.clrText,
      ),
      p: TextStyle(
        fontFamily: 'WorkSans',
        fontSize: 15.5,
        height: 1.5,
        color: Theme.of(context)
            .extension<EndernoteColors>()
            ?.clrText
            .withAlpha(240),
      ),
      em: TextStyle(
        fontFamily: 'WorkSans',
        fontStyle: FontStyle.italic,
        fontSize: 15.5,
        height: 1.65,
        color: Theme.of(context)
            .extension<EndernoteColors>()
            ?.clrText
            .withAlpha(240),
      ),
      strong: TextStyle(
        fontFamily: 'WorkSans',
        fontWeight: FontWeight.bold,
        fontSize: 15.5,
        height: 1.65,
        color: Theme.of(context)
            .extension<EndernoteColors>()
            ?.clrText
            .withAlpha(240),
      ),
      code: TextStyle(
        fontFamily: 'JetBrainsMono',
        fontSize: 14.5,
        height: 1.55,
        color: Theme.of(context)
            .extension<EndernoteColors>()
            ?.clrText
            .withAlpha(240),
      ),
      codeblockDecoration: BoxDecoration(
        color: Theme.of(context).extension<EndernoteColors>()?.clrSecondary,
        borderRadius: BorderRadius.circular(10),
      ),
      blockquoteDecoration: BoxDecoration(
        color: Theme.of(context).extension<EndernoteColors>()?.clrSecondary,
        borderRadius: BorderRadius.circular(10),
        border: Border(
          left: BorderSide(
            color: Theme.of(context)
                .extension<EndernoteColors>()!
                .clrText
                .withAlpha(230),
            width: 1.5,
          ),
        ),
      ),
      blockquote: TextStyle(
        fontFamily: 'WorkSans',
        fontSize: 15.5,
        height: 1.65,
        fontStyle: FontStyle.italic,
        color: Theme.of(context)
            .extension<EndernoteColors>()
            ?.clrText
            .withAlpha(200),
      ),
      horizontalRuleDecoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Theme.of(context)
                .extension<EndernoteColors>()!
                .clrText
                .withAlpha(150),
          ),
          bottom: BorderSide(width: 15, color: Colors.transparent),
        ),
      ),
      a: TextStyle(
        fontFamily: 'WorkSans',
        color: const Color(0xFF80AFFC),
        decoration: TextDecoration.underline,
        decorationColor:
            Theme.of(context).extension<EndernoteColors>()!.clrText,
      ),
      listBullet: TextStyle(
        fontFamily: 'WorkSans',
        fontSize: 16,
        height: 1.65,
        color: Theme.of(context)
            .extension<EndernoteColors>()!
            .clrText
            .withAlpha(230),
      ),
      tableBorder: TableBorder.all(
        color: Theme.of(context)
            .extension<EndernoteColors>()!
            .clrText
            .withAlpha(120),
        borderRadius: BorderRadius.circular(10),
        width: 1.5,
      ),
      tableHead: TextStyle(
        fontFamily: 'WorkSans',
        fontSize: 14.5,
        height: 1.35,
        fontWeight: FontWeight.w700,
        color: Theme.of(context)
            .extension<EndernoteColors>()!
            .clrText
            .withAlpha(245),
      ),
      tableBody: TextStyle(
        fontFamily: 'WorkSans',
        fontSize: 14.5,
        height: 1.45,
        fontWeight: FontWeight.w500,
        color: Theme.of(context)
            .extension<EndernoteColors>()!
            .clrText
            .withAlpha(235),
      ),
    );
