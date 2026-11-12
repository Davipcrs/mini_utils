import 'package:flutter/material.dart';

// A small demonstration tokenizer, rather than a complete Dart parser.
final _tokens = RegExp(
  r'''//[^\n]*|'(?:\\.|[^'\\])*'|"(?:\\.|[^"\\])*"|\b(?:import|void|class|final|const|return|if|else|for|while|true|false|null|var)\b|\b\d+(?:\.\d+)?\b''',
);

/// Preserves every character and changes only token colors so gutter rows align.
TextSpan highlightDart(String text, TextStyle style, ColorScheme colors) {
  final spans = <TextSpan>[];
  var offset = 0;
  for (final match in _tokens.allMatches(text)) {
    if (match.start > offset) {
      spans.add(TextSpan(text: text.substring(offset, match.start)));
    }
    final token = match.group(0)!;
    final Color color;
    if (token.startsWith('//')) {
      color = colors.onSurfaceVariant;
    } else if (token.startsWith("'") || token.startsWith('"')) {
      color = colors.tertiary;
    } else if (RegExp(r'^\d').hasMatch(token)) {
      color = colors.secondary;
    } else {
      color = colors.primary;
    }
    spans.add(
      TextSpan(
        text: token,
        style: TextStyle(color: color),
      ),
    );
    offset = match.end;
  }
  spans.add(TextSpan(text: text.substring(offset)));
  return TextSpan(style: style, children: spans);
}
