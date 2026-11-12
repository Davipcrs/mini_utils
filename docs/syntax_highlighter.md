# Using `syntaxHighlighter`

`LineNumberTextField` accepts an optional callback that turns its current text
into styled `TextSpan` objects. You supply the tokenization rules and colors;
the widget handles editing and line numbers. No additional package is required.

## Callback API

```dart
TextSpan Function(String text, TextStyle style)? syntaxHighlighter
```

- `text` is the entire current field value, including spaces and newlines.
- `style` is the field's base text style. Apply it to the root span so unstyled
  text inherits the same appearance.
- Return a `TextSpan` tree with different child styles for the tokens you want
  to highlight. The combined plain text must exactly equal `text`.

Omit `syntaxHighlighter` or set it to `null` to use normal controller rendering.
There is no built-in language selection or automatic language detection.

## Complete example

This example colors a few Dart keywords purple and leaves all other text in the
base style. Paste it into a Flutter app's `lib/main.dart` with `mini_utils` added
to the app's dependencies.

```dart
import 'package:flutter/material.dart';
import 'package:mini_utils/mini_utils.dart';

void main() => runApp(const MaterialApp(home: EditorExample()));

class EditorExample extends StatefulWidget {
  const EditorExample({super.key});

  @override
  State<EditorExample> createState() => _EditorExampleState();
}

class _EditorExampleState extends State<EditorExample> {
  final _controller = TextEditingController(
    text: 'final greeting = "Hello";\nvar count = 1;',
  );

  static final _keywords = RegExp(r'\b(final|const|var)\b');

  TextSpan _highlight(String text, TextStyle style) {
    final spans = <TextSpan>[];
    var offset = 0;

    for (final match in _keywords.allMatches(text)) {
      // Preserve the text before each keyword, including whitespace.
      spans.add(TextSpan(text: text.substring(offset, match.start)));
      spans.add(TextSpan(
        text: match.group(0),
        style: const TextStyle(color: Colors.purple),
      ));
      offset = match.end;
    }

    // Preserve the remaining text. This also handles empty input or no matches.
    spans.add(TextSpan(text: text.substring(offset)));
    return TextSpan(style: style, children: spans);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Syntax highlighting')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          height: 300,
          child: LineNumberTextField(
            controller: _controller,
            style: const TextStyle(
              fontFamily: 'monospace',
              fontSize: 15,
              height: 1.5,
            ),
            syntaxHighlighter: _highlight,
          ),
        ),
      ),
    );
  }
}
```

The regular expression is a demonstration: it also matches keywords inside
strings and comments. For more token types, see the example project's
[Dart demonstration tokenizer](../example/lib/dart_syntax_highlighter.dart).
For full language support, adapt a language-specific tokenizer's output into
`TextSpan` children while preserving every input character.

## Rendering requirements

1. Preserve every character in its original order, including newlines and
   whitespace. Do not trim, format, escape, or insert text. The widget checks
   `span.toPlainText() == text` with a debug assertion; violating this requirement
   can break cursor and selection alignment.
2. Prefer changing colors only. Font size, font family, and line-height changes
   can misalign text with the line-number gutter. When supplying `style`, include
   a `fontSize` and use `height: 1.5` to match the gutter's row spacing.
3. Keep the callback synchronous and free of side effects. It can run repeatedly
   during rendering, including selection changes. Do not edit the controller or
   call `setState` inside it. Compile reusable regular expressions outside the
   callback and keep tokenization inexpensive for large text values.

The gutter counts explicit newline characters. Soft-wrapped visual lines do
not receive additional line numbers.

## Controllers and input behavior

The `controller` parameter is optional. If you supply one, text, selection, and
composing values stay synchronized with the widget's internal controller. You
remain responsible for disposing your controller after the widget no longer
uses it. Read or update its text normally:

```dart
final currentCode = controller.text;
controller.text = 'const answer = 42;';
```

`onChanged` runs when the user edits text. Programmatic controller changes do not
invoke it; add a controller listener if you need to observe those changes too.

While an input method is composing text, the widget temporarily uses normal
controller rendering to preserve composing feedback such as the underline.
Highlighting resumes when composition ends. If your supplied controller overrides
`buildTextSpan`, that renderer is used during composition and whenever
`syntaxHighlighter` is `null`.

## Change colors or disable highlighting

Capture theme colors in the callback and rebuild the widget when the theme or
highlighting preference changes:

```dart
final colors = Theme.of(context).colorScheme;

LineNumberTextField(
  controller: controller,
  syntaxHighlighter: highlightingEnabled
      ? (text, style) => TextSpan(
            text: text,
            style: style.copyWith(color: colors.primary),
          )
      : null,
)
```

This last snippet applies one color to the whole value. Use child spans as in the
complete example to color individual tokens.
