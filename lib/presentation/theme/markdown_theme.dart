import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import 'app_themes.dart';

MarkdownStyleSheet mdTheme(context) => MarkdownStyleSheet(
      h1: TextStyle(
        color: Theme.of(context).extension<EndernoteColors>()?.clrText,
        fontWeight: FontWeight.bold,
        fontSize: 28,
        letterSpacing: 0.5,
        fontFamily: 'PlayfairDisplay',
      ),
      h2: TextStyle(
        color: Theme.of(context).extension<EndernoteColors>()?.clrText,
        fontWeight: FontWeight.bold,
        fontSize: 24,
        letterSpacing: 0.5,
        fontFamily: 'PlayfairDisplay',
      ),
      h3: TextStyle(
        color: Theme.of(context).extension<EndernoteColors>()?.clrText,
        fontWeight: FontWeight.bold,
        fontSize: 20,
        letterSpacing: 0.5,
        fontFamily: 'PlayfairDisplay',
      ),
      h4: TextStyle(
        color: Theme.of(context).extension<EndernoteColors>()?.clrText,
        fontWeight: FontWeight.bold,
        fontSize: 18,
        letterSpacing: 0.5,
        fontFamily: 'PlayfairDisplay',
      ),
      h5: TextStyle(
        color: Theme.of(context).extension<EndernoteColors>()?.clrText,
        fontWeight: FontWeight.w600,
        fontSize: 16,
        letterSpacing: 0.5,
        fontFamily: 'PlayfairDisplay',
      ),
      h6: TextStyle(
        color: Theme.of(context).extension<EndernoteColors>()?.clrText,
        fontWeight: FontWeight.w600,
        fontSize: 14,
        letterSpacing: 0.5,
        fontFamily: 'PlayfairDisplay',
      ),
      p: TextStyle(
        color: Theme.of(context)
            .extension<EndernoteColors>()
            ?.clrText
            .withAlpha(240),
        fontSize: 16,
        height: 1.6,
        fontFamily: 'Roboto',
      ),
      em: TextStyle(
        fontStyle: FontStyle.italic,
        color: Theme.of(context)
            .extension<EndernoteColors>()
            ?.clrText
            .withAlpha(240),
        fontFamily: 'Roboto',
      ),
      strong: TextStyle(
        fontWeight: FontWeight.bold,
        color: Theme.of(context)
            .extension<EndernoteColors>()
            ?.clrText
            .withAlpha(240),
        fontFamily: 'Roboto',
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
        fontFamily: 'Roboto',
      ),
      listBullet: TextStyle(
        color: Theme.of(context)
            .extension<EndernoteColors>()!
            .clrText
            .withAlpha(230),
        fontSize: 16,
        fontFamily: 'Roboto',
      ),
    );
