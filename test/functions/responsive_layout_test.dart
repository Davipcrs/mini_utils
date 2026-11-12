import 'package:flutter_test/flutter_test.dart';
import 'package:mini_utils/mini_utils.dart';

void main() {
  setUp(() => ResponsiveLayout(mobileBreakpoint: 600, desktopBreakpoint: 1024));
  tearDown(
      () => ResponsiveLayout(mobileBreakpoint: 600, desktopBreakpoint: 1024));

  test('shares configuration and preserves it when retrieved again', () {
    final configured =
        ResponsiveLayout(mobileBreakpoint: 480, desktopBreakpoint: 900);
    expect(identical(configured, ResponsiveLayout()), isTrue);
    expect(identical(configured, ResponsiveLayout.instance), isTrue);
    expect(ResponsiveLayout.instance.evaluate(479), 1);
    expect(ResponsiveLayout.instance.evaluate(480), 2);
    expect(ResponsiveLayout.instance.evaluate(900), 3);
    expect(responsiveLayout(900), 3);
    expect(configured.evaluate(900, desktopBreakpoint: 1000), 2);
    expect(configured.desktopBreakpoint, 900);
  });

  test('partial configuration preserves the other breakpoint', () {
    final layout = ResponsiveLayout(mobileBreakpoint: 480);
    expect(layout.desktopBreakpoint, 1024);
    ResponsiveLayout(desktopBreakpoint: 900);
    expect(layout.mobileBreakpoint, 480);
    expect(layout.desktopBreakpoint, 900);
    expect(() => ResponsiveLayout(mobileBreakpoint: 1000), throwsArgumentError);
    expect(layout.mobileBreakpoint, 480);
    expect(layout.desktopBreakpoint, 900);
    expect(() => layout.evaluate(double.nan), throwsArgumentError);
    expect(() => layout.evaluate(500, desktopBreakpoint: 400),
        throwsArgumentError);
    expect(layout.desktopBreakpoint, 900);
  });

  test('rejects invalid configuration without changing shared values', () {
    expect(() => ResponsiveLayout(mobileBreakpoint: 1024), throwsArgumentError);
    expect(() => ResponsiveLayout(mobileBreakpoint: double.nan),
        throwsArgumentError);
    expect(() => ResponsiveLayout(desktopBreakpoint: double.infinity),
        throwsArgumentError);
    expect(ResponsiveLayout.instance.mobileBreakpoint, 600);
    expect(ResponsiveLayout.instance.desktopBreakpoint, 1024);
    expect(() => ResponsiveLayout.instance.evaluate(-1), throwsArgumentError);
    expect(() => ResponsiveLayout.instance.evaluate(double.infinity),
        throwsArgumentError);
  });
  test('classifies widths at the navigation breakpoints', () {
    expect(responsiveLayout(0), 1);
    expect(responsiveLayout(599.9), 1);
    expect(responsiveLayout(600), 2);
    expect(responsiveLayout(1023.9), 2);
    expect(responsiveLayout(1024), 3);
    expect(responsiveLayout(1920), 3);
  });

  test('supports custom breakpoints', () {
    int classify(double width) => responsiveLayout(
          width,
          mobileBreakpoint: 480,
          desktopBreakpoint: 900,
        );
    expect(classify(479), 1);
    expect(classify(480), 2);
    expect(classify(899), 2);
    expect(classify(900), 3);
  });
}
