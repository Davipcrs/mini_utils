import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mini_utils/mini_utils.dart';

void main() {
  testWidgets('calls onPressed and uses suite defaults', (tester) async {
    var presses = 0;
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: CdevCustomElevatedButton(
          onPressed: () => presses++,
          child: const Text('Save'),
        ),
      ),
    ));

    await tester.tap(find.text('Save'));
    expect(presses, 1);
    final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
    expect(button.style!.minimumSize!.resolve({}), const Size(64, 48));
  });

  testWidgets('null onPressed disables even a long-press callback',
      (tester) async {
    var called = false;
    await tester.pumpWidget(MaterialApp(
      home: CdevCustomElevatedButton(
        onPressed: null,
        onLongPress: () => called = true,
        child: const Text('Save'),
      ),
    ));

    final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
    expect(button.enabled, isFalse);
    await tester.longPress(find.text('Save'));
    expect(called, isFalse);
  });

  testWidgets('merges app theme and individual style over suite defaults',
      (tester) async {
    await tester.pumpWidget(MaterialApp(
      theme: ThemeData(
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            minimumSize: const Size(100, 52),
          ),
        ),
      ),
      home: CdevCustomElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
        child: const Text('Save'),
      ),
    ));

    final style =
        tester.widget<ElevatedButton>(find.byType(ElevatedButton)).style!;
    expect(style.backgroundColor!.resolve({}), Colors.green);
    expect(style.minimumSize!.resolve({}), const Size(100, 52));
    expect(style.padding!.resolve({}),
        const EdgeInsets.symmetric(horizontal: 24, vertical: 12));
  });
}
