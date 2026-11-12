import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mini_utils/mini_utils.dart';

void main() {
  const items = [
    NavigationBarItem(
        icon: Icons.folder_outlined,
        selectedIcon: Icons.folder,
        label: 'Projects'),
    NavigationBarItem(icon: Icons.description_outlined, label: 'Documents'),
  ];

  testWidgets('uses shared custom breakpoints without local overrides',
      (tester) async {
    ResponsiveLayout(mobileBreakpoint: 480, desktopBreakpoint: 900);
    addTearDown(
        () => ResponsiveLayout(mobileBreakpoint: 600, desktopBreakpoint: 1024));
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    for (final width in [599.0, 900.0]) {
      tester.view.physicalSize = Size(width, 600);
      await tester.pumpWidget(MaterialApp(
          home: Scaffold(
              body: Row(children: [
        CdevResponsiveNavigationBar(
          selectedIndex: 0,
          destinations: items,
          onDestinationSelected: (_) {},
        ),
        const Expanded(child: SizedBox()),
      ]))));
      await tester.pumpAndSettle();
      expect(find.byType(Drawer), findsNothing);
      expect(tester.getSize(find.byType(CdevResponsiveNavigationBar)).width,
          width < 900 ? 80 : 256);
    }
  });

  testWidgets('breakpoints, desktop toggle and callbacks', (tester) async {
    var selected = 0;
    var created = 0;
    Future<void> resize(double width) async {
      tester.view.physicalSize = Size(width, 600);
      tester.view.devicePixelRatio = 1;
      await tester.pumpWidget(MaterialApp(
          home: Scaffold(
              body: Row(children: [
        CdevResponsiveNavigationBar(
          selectedIndex: selected,
          onDestinationSelected: (index) => selected = index,
          destinations: items,
          onNewItemPressed: () => created++,
        ),
        const Expanded(child: SizedBox()),
      ]))));
      await tester.pumpAndSettle();
    }

    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await resize(1024);
    expect(tester.getSize(find.byType(CdevResponsiveNavigationBar)).width, 256);
    await tester.tap(find.text('Documents'));
    expect(selected, 1);
    await resize(1024);
    await tester.tap(find.text('New Item'));
    expect(created, 1);
    await tester.tap(find.byTooltip('Collapse navigation'));
    await tester.pump(const Duration(milliseconds: 100));
    expect(tester.takeException(), isNull);
    await tester.pumpAndSettle();
    expect(tester.getSize(find.byType(CdevResponsiveNavigationBar)).width, 80);
    await tester.tap(find.byTooltip('Expand navigation'));
    await tester.pumpAndSettle();
    await resize(1023);
    expect(tester.getSize(find.byType(CdevResponsiveNavigationBar)).width, 80);
    expect(find.byIcon(Icons.menu), findsNothing);
    await resize(600);
    expect(tester.getSize(find.byType(CdevResponsiveNavigationBar)).width, 80);
    expect(find.byIcon(Icons.menu), findsNothing);
    await resize(1024);
    expect(find.byTooltip('Collapse navigation'), findsOneWidget);
    await resize(599);
    expect(find.byType(Drawer), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('mobile integrates with the host Scaffold drawer',
      (tester) async {
    tester.view.physicalSize = const Size(390, 300);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final key = GlobalKey<ScaffoldState>();
    await tester.pumpWidget(MaterialApp(
        home: Scaffold(
      key: key,
      drawer: CdevResponsiveNavigationBar(
        selectedIndex: 0,
        destinations: items,
        onDestinationSelected: (_) => key.currentState!.closeDrawer(),
      ),
      body: const SizedBox(),
    )));
    key.currentState!.openDrawer();
    await tester.pumpAndSettle();
    expect(find.text('Projects'), findsOneWidget);
    expect(find.byTooltip('New Item'), findsNothing);
    await tester.tap(find.text('Documents'));
    await tester.pumpAndSettle();
    expect(key.currentState!.isDrawerOpen, isFalse);
    key.currentState!.openDrawer();
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Close navigation'));
    await tester.pumpAndSettle();
    expect(key.currentState!.isDrawerOpen, isFalse);
    expect(tester.takeException(), isNull);
  });
}
