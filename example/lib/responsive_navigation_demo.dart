import 'package:flutter/material.dart';
import 'package:mini_utils/mini_utils.dart';

/// Standalone entry point: flutter run -t lib/responsive_navigation_demo.dart.
void main() => runApp(const _NavigationDemoApp());

class _NavigationDemoApp extends StatefulWidget {
  const _NavigationDemoApp();

  @override
  State<_NavigationDemoApp> createState() => _NavigationDemoAppState();
}

class _NavigationDemoAppState extends State<_NavigationDemoApp> {
  bool _dark = false;

  @override
  Widget build(BuildContext context) => MaterialApp(
    theme: cdevSuiteLightTheme,
    darkTheme: cdevSuiteDarkTheme,
    themeMode: _dark ? ThemeMode.dark : ThemeMode.light,
    home: ResponsiveNavigationDemo(
      onThemeChanged: () => setState(() => _dark = !_dark),
    ),
  );
}

/// Demonstrates navigation at the actual available window width.
class ResponsiveNavigationDemo extends StatefulWidget {
  /// Creates the demo page.
  const ResponsiveNavigationDemo({super.key, required this.onThemeChanged});

  /// Changes the host application's light/dark theme.
  final VoidCallback onThemeChanged;

  @override
  State<ResponsiveNavigationDemo> createState() =>
      _ResponsiveNavigationDemoState();
}

class _ResponsiveNavigationDemoState extends State<ResponsiveNavigationDemo> {
  int _selectedIndex = 0;
  int _created = 0;
  static const _items = [
    NavigationBarItem(
      icon: Icons.folder_outlined,
      selectedIcon: Icons.folder,
      label: 'Projects',
    ),
    NavigationBarItem(icon: Icons.description_outlined, label: 'Documents'),
    NavigationBarItem(icon: Icons.label_outline, label: 'Labels'),
  ];

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final layout = ResponsiveLayout.instance.evaluate(constraints.maxWidth);
      final mobile = layout == 1;
      return Scaffold(
        appBar: AppBar(title: const Text('Responsive navigation')),
        drawer: mobile ? _navigation(closeDrawer: true) : null,
        body: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (!mobile)
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: constraints.maxWidth),
                child: _navigation(),
              ),
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _items[_selectedIndex].label,
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 16),
                      Text('New items created: $_created'),
                      const SizedBox(height: 16),
                      Text(
                        mobile
                            ? 'Mobile: open the menu in the app bar.'
                            : layout == 2
                            ? 'Tablet: icons only.'
                            : 'Desktop: use the menu button to expand or collapse.',
                      ),
                      const SizedBox(height: 8),
                      const Text('Resize the window to try all three layouts.'),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    },
  );

  Widget _navigation({bool closeDrawer = false}) => CdevResponsiveNavigationBar(
    selectedIndex: _selectedIndex,
    destinations: _items,
    onThemeChanged: widget.onThemeChanged,
    onDestinationSelected: (index) {
      setState(() => _selectedIndex = index);
      if (closeDrawer) Navigator.of(context).pop();
    },
    onNewItemPressed: () => setState(() => _created++),
  );
}
