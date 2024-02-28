import 'package:flutter_test/flutter_test.dart';

import 'color_picker_test.dart';

void main() {
  testWidgets("Color Picker Test", (widgetTester) async {
    await widgetTester.pumpWidget(ColorPickerTest());
    await widgetTester.tap(find.text("Press"));
    await widgetTester.pump();
    await widgetTester.tap(find.text("Cancel"));
    expect(find.text("Press"), findsOneWidget);
    expect(find.text("Cancel"), findsOneWidget);
  });
}
