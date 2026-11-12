import 'package:example/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mini_utils/mini_utils.dart';

void main() {
  testWidgets('Cdev button demo responds to taps', (tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.ensureVisible(find.text('Try cdev button'));
    await tester.tap(find.text('Try cdev button'));
    await tester.pump();
    expect(find.text('Cdev button pressed'), findsOneWidget);
    final disabled = tester.widget<CdevCustomElevatedButton>(
      find.widgetWithText(CdevCustomElevatedButton, 'Disabled'),
    );
    expect(disabled.onPressed, isNull);
  });

  testWidgets('Editor toggles highlighting without losing edits', (
    tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    await tester.scrollUntilVisible(find.byType(LineNumberTextField), 200);
    final field = find.descendant(
      of: find.byType(LineNumberTextField),
      matching: find.byType(TextField),
    );
    const sample = 'final count = 42; // example\n';
    await tester.enterText(field, sample);
    await tester.pump();
    final editor = tester.widget<LineNumberTextField>(
      find.byType(LineNumberTextField),
    );
    expect(editor.controller!.text, sample);
    final span = editor.syntaxHighlighter!(sample, editor.style!);
    expect(span.toPlainText(), sample);
    expect(span.children!.where((span) => span.style?.color != null).length, 3);
    await Scrollable.ensureVisible(
      tester.element(find.text('Syntax highlighting')),
      alignment: 0.5,
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Syntax highlighting'));
    await tester.pump();
    expect(
      tester
          .widget<LineNumberTextField>(find.byType(LineNumberTextField))
          .syntaxHighlighter,
      isNull,
    );
    expect(editor.controller!.text, sample);
    await tester.tap(find.text('Syntax highlighting'));
    await tester.pump();
    expect(
      tester
          .widget<LineNumberTextField>(find.byType(LineNumberTextField))
          .syntaxHighlighter,
      isNotNull,
    );
    expect(editor.controller!.text, sample);
  });

  testWidgets('Gallery changes themes and preserves edited text', (
    tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    expect(find.text('Mini Utils Gallery'), findsOneWidget);
    await tester.scrollUntilVisible(find.byType(LineNumberTextField), 200);
    final field = find.descendant(
      of: find.byType(LineNumberTextField),
      matching: find.byType(TextField),
    );
    await tester.enterText(field, 'First line\nSecond line');
    await tester.pump();
    expect(find.text('2'), findsOneWidget);
    await tester.tap(find.byTooltip('Use dark theme'));
    await tester.pumpAndSettle();
    expect(Theme.of(tester.element(field)).brightness, Brightness.dark);
    expect(find.text('First line\nSecond line'), findsOneWidget);
  });

  testWidgets('Date picker cancellation preserves the empty selection', (
    tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    await tester.scrollUntilVisible(find.text('Choose date & time'), 150);
    await tester.ensureVisible(find.text('Choose date & time'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Choose date & time'));
    await tester.pumpAndSettle();
    expect(find.byType(DatePickerDialog), findsOneWidget);
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(find.text('No date selected'), findsOneWidget);
  });

  testWidgets('Login demo validates input and cancels back to gallery', (
    tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    await tester.scrollUntilVisible(
      find.text('Open login demo'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.ensureVisible(find.text('Open login demo'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Open login demo'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Enter'));
    await tester.pump();
    expect(find.text('Enter a username and password.'), findsOneWidget);
    await tester.enterText(find.byType(TextField).at(0), 'demo');
    await tester.enterText(find.byType(TextField).at(1), 'sample');
    await tester.tap(find.text('Enter'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('Demo login submitted for demo.'), findsOneWidget);
    await tester.pump(const Duration(seconds: 5));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(find.text('Mini Utils Gallery'), findsOneWidget);
  });
}
