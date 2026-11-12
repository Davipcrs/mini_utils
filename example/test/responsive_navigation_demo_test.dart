import 'package:example/responsive_navigation_demo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mini_utils/mini_utils.dart';

void main() {
  testWidgets('demo and navigation share custom breakpoints across resizes', (
    tester,
  ) async {
    ResponsiveLayout(mobileBreakpoint: 480, desktopBreakpoint: 900);
    addTearDown(
      () => ResponsiveLayout(mobileBreakpoint: 600, desktopBreakpoint: 1024),
    );
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    for (final width in [479.0, 480.0, 899.0, 900.0]) {
      tester.view.physicalSize = Size(width, 800);
      await tester.pumpWidget(
        MaterialApp(home: ResponsiveNavigationDemo(onThemeChanged: () {})),
      );
      await tester.pumpAndSettle();
      final nav = find.byType(CdevResponsiveNavigationBar);
      if (width < 480) {
        await tester.tap(find.byTooltip('Open navigation menu'));
        await tester.pumpAndSettle();
        expect(find.byTooltip('Close navigation'), findsOneWidget);
        await tester.tap(find.byTooltip('Close navigation'));
        await tester.pumpAndSettle();
      } else {
        expect(find.byType(Drawer), findsNothing);
        expect(tester.getSize(nav).width, width < 900 ? 80 : 256);
        expect(
          find.byTooltip('Collapse navigation'),
          width < 900 ? findsNothing : findsOneWidget,
        );
      }
      expect(tester.takeException(), isNull);
    }
  });

  for (final width in [390.0, 800.0, 1200.0]) {
    testWidgets('Theme toggle follows cdev theme at width $width', (
      tester,
    ) async {
      tester.view.physicalSize = Size(width, 800);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      var dark = false;
      await tester.pumpWidget(
        StatefulBuilder(
          builder: (context, setState) => MaterialApp(
            theme: cdevSuiteLightTheme,
            darkTheme: cdevSuiteDarkTheme,
            themeMode: dark ? ThemeMode.dark : ThemeMode.light,
            home: ResponsiveNavigationDemo(
              onThemeChanged: () => setState(() => dark = !dark),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      if (width < 600) {
        await tester.tap(find.byTooltip('Open navigation menu'));
        await tester.pumpAndSettle();
      }
      final nav = find.byType(CdevResponsiveNavigationBar);
      void expectColors(ThemeData theme) {
        final surfaces = tester.widgetList<Material>(
          find.descendant(of: nav, matching: find.byType(Material)),
        );
        expect(
          surfaces.any((m) => m.color == theme.colorScheme.surface),
          isTrue,
        );
        expect(
          surfaces.any((m) => m.color == theme.colorScheme.primaryContainer),
          isTrue,
        );
        expect(Theme.of(tester.element(nav)).brightness, theme.brightness);
      }

      expectColors(cdevSuiteLightTheme);
      await tester.tap(find.byTooltip('Use dark theme'));
      await tester.pumpAndSettle();
      expectColors(cdevSuiteDarkTheme);
      expect(find.byTooltip('Use light theme'), findsOneWidget);
      await tester.tap(find.byTooltip('Use light theme'));
      await tester.pumpAndSettle();
      expectColors(cdevSuiteLightTheme);
      expect(tester.takeException(), isNull);
    });
  }
}
