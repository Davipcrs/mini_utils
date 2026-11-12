import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mini_utils/mini_utils.dart';

void main() {
  testWidgets('highlights text and synchronizes an external controller',
      (tester) async {
    final source = TextEditingController(text: 'final value');
    var changes = 0;
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: LineNumberTextField(
          controller: source,
          onChanged: (_) => changes++,
          syntaxHighlighter: (text, style) => TextSpan(
            text: text,
            style: style.copyWith(color: Colors.purple),
          ),
        ),
      ),
    ));
    final editable = tester.widget<EditableText>(find.byType(EditableText));
    final context = tester.element(find.byType(EditableText));
    TextSpan span() => editable.controller.buildTextSpan(
          context: context,
          style: editable.style,
          withComposing: true,
        );
    expect(span().toPlainText(), 'final value');
    expect((span().children!.single as TextSpan).style!.color, Colors.purple);
    await tester.enterText(find.byType(TextField), 'updated');
    expect(source.text, 'updated');
    expect(changes, 1);
    source.value = const TextEditingValue(
      text: 'composing',
      selection: TextSelection.collapsed(offset: 9),
      composing: TextRange(start: 0, end: 9),
    );
    await tester.pump();
    expect(editable.controller.value, source.value);
    expect(span().toPlainText(), 'composing');
    expect(
      span().children!.any(
          (child) => child.style?.decoration == TextDecoration.underline),
      isTrue,
    );
    await tester.pumpWidget(const SizedBox());
    source.text = 'still usable';
    source.dispose();
  });

  testWidgets('accepts replacement controllers and optional highlighting',
      (tester) async {
    final first = TextEditingController(text: 'first');
    final second = TextEditingController(text: 'second\nline');
    Future<void> show(TextEditingController? source) => tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: LineNumberTextField(controller: source)),
          ),
        );
    await show(first);
    await show(second);
    expect(
        tester.widget<EditableText>(find.byType(EditableText)).controller.text,
        second.text);
    first.text = 'detached';
    await show(null);
    expect(
        tester.widget<EditableText>(find.byType(EditableText)).controller.text,
        second.text);
    await tester.pumpWidget(const SizedBox());
    first.dispose();
    second.dispose();
  });
}
