# Mini Utils example

An interactive Flutter gallery using the local package through `path: ../`.

```sh
cd example
flutter pub get
flutter run
```

The gallery demonstrates the color picker and color inverter, date/time picker,
line-numbered editor, draggable container and line connector, login form, digital
clock, and the package's light and dark themes. Login actions only show local
feedback; they do not authenticate or send credentials.

The digital clock currently inherits the package's periodic timer behavior:
its timer is not disposed when the demo closes. The gallery keeps it on a separate
screen so it starts only when opened.

Run checks with `flutter analyze` and `flutter test` from this folder.

The line-numbered editor uses `LineNumberTextField.syntaxHighlighter` with a small
Dart tokenizer in `lib/dart_syntax_highlighter.dart`. Toggle **Syntax highlighting**
to compare styled and plain text without losing edits. The callback preserves all
input characters and uses color-only token styles with the active theme's colors.
It demonstrates comments, quoted strings, keywords, and numbers; it is not a full
Dart parser. The example owns and disposes its editing controller.
