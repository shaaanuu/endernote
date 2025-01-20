import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

const Color markdownHeadingColor = Color(0xFFcdd6f4);
const Color markdownParagraphColor = Color(0xFFbac2de);
const Color markdownCodeColor = Color(0xFF11111b);
const Color markdownLinkColor = Color(0xFF89b4fa);
const Color markdownListColor = Color(0xFFb4befe);

MarkdownStyleSheet mdTheme() => MarkdownStyleSheet(
      h1: const TextStyle(
        color: markdownHeadingColor,
        fontWeight: FontWeight.bold,
        fontSize: 28,
        fontFamily: 'PlayfairDisplay',
      ),
      h2: const TextStyle(
        color: markdownHeadingColor,
        fontWeight: FontWeight.bold,
        fontSize: 24,
        fontFamily: 'PlayfairDisplay',
      ),
      h3: const TextStyle(
        color: markdownHeadingColor,
        fontWeight: FontWeight.bold,
        fontSize: 20,
        fontFamily: 'PlayfairDisplay',
      ),
      h4: const TextStyle(
        color: markdownHeadingColor,
        fontWeight: FontWeight.bold,
        fontSize: 18,
        fontFamily: 'PlayfairDisplay',
      ),
      h5: const TextStyle(
        color: markdownHeadingColor,
        fontWeight: FontWeight.w600,
        fontSize: 16,
        fontFamily: 'PlayfairDisplay',
      ),
      h6: const TextStyle(
        color: markdownHeadingColor,
        fontWeight: FontWeight.w600,
        fontSize: 14,
        fontFamily: 'PlayfairDisplay',
      ),
      p: const TextStyle(
        color: markdownParagraphColor,
        fontSize: 16,
        height: 1.6,
        fontFamily: 'Roboto',
      ),
      em: const TextStyle(
        fontStyle: FontStyle.italic,
        color: markdownParagraphColor,
        fontFamily: 'Roboto',
      ),
      strong: const TextStyle(
        fontWeight: FontWeight.bold,
        color: markdownParagraphColor,
        fontFamily: 'Roboto',
      ),
      code: const TextStyle(
        color: markdownParagraphColor,
        backgroundColor: markdownCodeColor,
        fontFamily: 'FiraCode',
        fontSize: 14,
      ),
      codeblockDecoration: BoxDecoration(
        color: markdownCodeColor,
        borderRadius: BorderRadius.circular(8),
        border:
            Border.all(color: markdownParagraphColor.withValues(alpha: 0.2)),
      ),
      blockquoteDecoration: BoxDecoration(
        color: markdownCodeColor.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(10),
        border: const Border(
          left: BorderSide(
            color: markdownHeadingColor,
            width: 4,
          ),
        ),
      ),
      horizontalRuleDecoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: const Border(
          top: BorderSide(
            width: 3.0,
            color: markdownListColor,
          ),
        ),
      ),
      a: const TextStyle(
        color: markdownLinkColor,
        decoration: TextDecoration.underline,
        fontFamily: 'Roboto',
      ),
      listBullet: const TextStyle(
        color: markdownListColor,
        fontSize: 16,
        fontFamily: 'Roboto',
      ),
    );
