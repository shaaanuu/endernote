import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import 'app_themes.dart';

MarkdownStyleSheet mdTheme(context) => MarkdownStyleSheet(
      h1: TextStyle(
        fontFamily: 'PlayfairDisplay',
        fontWeight: FontWeight.w700,
        fontSize: 26,
        letterSpacing: 0.2,
        color: Theme.of(context).extension<EndernoteColors>()?.clrText,
      ),
      h2: TextStyle(
        fontFamily: 'PlayfairDisplay',
        fontWeight: FontWeight.w700,
        fontSize: 23,
        letterSpacing: 0.2,
        color: Theme.of(context).extension<EndernoteColors>()?.clrText,
      ),
      h3: TextStyle(
        fontFamily: 'PlayfairDisplay',
        fontWeight: FontWeight.w600,
        fontSize: 21,
        letterSpacing: 0.1,
        color: Theme.of(context).extension<EndernoteColors>()?.clrText,
      ),
      h4: TextStyle(
        fontFamily: 'PlayfairDisplay',
        fontWeight: FontWeight.w600,
        fontSize: 19,
        letterSpacing: 0.1,
        color: Theme.of(context).extension<EndernoteColors>()?.clrText,
      ),
      h5: TextStyle(
        fontFamily: 'PlayfairDisplay',
        fontWeight: FontWeight.w500,
        fontSize: 17,
        letterSpacing: 0.1,
        color: Theme.of(context).extension<EndernoteColors>()?.clrText,
      ),
      h6: TextStyle(
        fontFamily: 'PlayfairDisplay',
        fontWeight: FontWeight.w500,
        fontSize: 16,
        letterSpacing: 0.1,
        color: Theme.of(context).extension<EndernoteColors>()?.clrText,
      ),
      p: TextStyle(
        fontSize: 15,
        height: 1.6,
        color: Theme.of(context)
            .extension<EndernoteColors>()
            ?.clrText
            .withAlpha(240),
      ),
      em: TextStyle(
        fontStyle: FontStyle.italic,
        color: Theme.of(context)
            .extension<EndernoteColors>()
            ?.clrText
            .withAlpha(240),
      ),
      strong: TextStyle(
        fontWeight: FontWeight.bold,
        color: Theme.of(context)
            .extension<EndernoteColors>()
            ?.clrText
            .withAlpha(240),
      ),
      code: TextStyle(
        color: Theme.of(context)
            .extension<EndernoteColors>()
            ?.clrText
            .withAlpha(240),
        fontFamily: 'FiraCode',
        fontSize: 14,
      ),
      codeblockDecoration: BoxDecoration(
        color: Theme.of(context)
            .extension<EndernoteColors>()
            ?.clrBase
            .withValues(blue: 255, green: 255, red: 255, alpha: 200),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Theme.of(context)
              .extension<EndernoteColors>()!
              .clrText
              .withValues(alpha: 0.2),
        ),
      ),
      blockquoteAlign: WrapAlignment.center,
      blockquoteDecoration: BoxDecoration(
        color: Theme.of(context)
            .extension<EndernoteColors>()
            ?.clrBase
            .withValues(blue: 255, green: 255, red: 255, alpha: 200),
        borderRadius: BorderRadius.circular(10),
        border: Border(
          left: BorderSide(
            color: Theme.of(context)
                .extension<EndernoteColors>()!
                .clrText
                .withAlpha(230),
            width: 4,
          ),
        ),
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
        color: Color(0xFF80AFFC),
        decoration: TextDecoration.underline,
        decorationColor:
            Theme.of(context).extension<EndernoteColors>()!.clrText,
      ),
      listBullet: TextStyle(
        color: Theme.of(context)
            .extension<EndernoteColors>()!
            .clrText
            .withAlpha(230),
        fontSize: 16,
      ),
      tableBorder: TableBorder.all(
        color: Theme.of(context)
            .extension<EndernoteColors>()!
            .clrText
            .withAlpha(120),
        borderRadius: BorderRadius.circular(10),
        width: 1.5,
      ),
    );
