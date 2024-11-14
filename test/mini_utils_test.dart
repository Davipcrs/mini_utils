import 'package:flutter_test/flutter_test.dart';

import 'widgets/color_picker_test.dart';

void main() {
  testWidgets("Color Picker Test", (widgetTester) async {
    await widgetTester.pumpWidget(const ColorPickerTest());
    await widgetTester.tap(find.text("Press"));
    await widgetTester.pump();
    await widgetTester.tap(find.text("Cancel"));
    expect(find.text("Press"), findsOneWidget);
    expect(find.text("Cancel"), findsOneWidget);
  });
}
