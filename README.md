<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages).
-->

# mini_utils

A Flutter Package with reusable Widgets and Functions.

## Features

Widgets:

- dateTimePicker
- colorPicker
- loginScreen
- digitalClock  

## Getting started

Import the package in the pubspec.yaml

## Usage

Show Widgets:  

```dart
Color? color = showColorPicker(BuildContext context);
DateTime? date = showDateTimePicker(BuildContext context);
```

### CdevCustomButton

Import `package:mini_utils/mini_utils.dart` and use the shared elevated button:

```dart
CdevCustomButton(
  onPressed: () { /* Save changes. */ },
  child: const Text('Save'),
)
```

Pass `onPressed: null` to disable it. Suite defaults provide a 48-pixel minimum
height, rounded corners, and consistent padding. Colors follow the current theme,
including the cdev light and dark themes. Customize all buttons in an app through
`ThemeData.elevatedButtonTheme`, or pass a `ButtonStyle` to one button's `style`.
App theme styles override suite defaults; individual styles override both.

### LineNumberTextField syntax highlighting

See the [syntax highlighting guide](docs/syntax_highlighter.md) for a complete
example, callback requirements, controller behavior, and theme integration.

Use the optional `syntaxHighlighter` callback to style the editable text:

```dart
LineNumberTextField(
  controller: controller,
  syntaxHighlighter: (text, style) {
    final spans = <TextSpan>[];
    var offset = 0;
    for (final match in RegExp(r'\b(final|const|var)\b').allMatches(text)) {
      spans.add(TextSpan(text: text.substring(offset, match.start)));
      spans.add(TextSpan(
        text: match[0],
        style: const TextStyle(color: Colors.purple),
      ));
      offset = match.end;
    }
    spans.add(TextSpan(text: text.substring(offset)));
    return TextSpan(style: style, children: spans);
  },
)
```

Return a `TextSpan` tree containing exactly the original text. You can use
language-specific tokenizers to give individual tokens different colors. Prefer
color-only changes to preserve alignment with line numbers. Highlighting is
suspended during input-method composition so the composing underline is retained.
Omit the callback for normal text rendering.
