import 'package:example/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mini_utils/mini_utils.dart';

void main() {
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
