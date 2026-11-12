# Responsive navigation

Import `package:mini_utils/mini_utils.dart` to use `CdevResponsiveNavigationBar`
and `NavigationBarItem`. Uses Material widgets with no additional dependencies.

- Below 600 logical pixels: returns a Drawer. Put the component in
  `Scaffold.drawer`; the host Scaffold supplies the menu button.
- 600–1023: icon-only sidebar.
- 1024 and above: expanded sidebar with a manual expand/collapse button.

The widget uses LayoutBuilder. When placed directly in a Row with unbounded
horizontal constraints, it falls back to the MediaQuery viewport width. For a
pane within a larger window, constrain its maximum width to the pane's available
width, as shown in the example.

The caller owns the selected index, page content and drawer dismissal after
selection. No Scaffold, router or business logic is created by the component.
Set `onNewItemPressed` to show the optional creation button. Customize its label,
icon and colors, plus sidebar colors, widths, breakpoints and animation duration
through constructor parameters. Keep the host's mobile breakpoint consistent
with the component's `mobileBreakpoint`.

Run the standalone Material 3 demo from `example/`:

```sh
flutter run -t lib/responsive_navigation_demo.dart
```

Or open **Responsive navigation → Open navigation demo** in the existing gallery.
The demo supports selection, creation feedback, desktop expansion and mobile
Drawer dismissal. Resize the window to test each layout. Its `main()` is a
minimal standalone entry point; the existing gallery entry point is preserved.

## Light and dark themes

Default colors follow `Theme.of(context).colorScheme`, including the cdev light
and dark themes. Explicit color arguments still override the corresponding theme
colors. The optional `onThemeChanged` callback displays a theme action with an
icon and label in the expanded sidebar/Drawer, or an icon and tooltip in the
collapsed sidebar. Its label reflects the active theme brightness.

The host owns theme state:

```dart
MaterialApp(
  theme: cdevSuiteLightTheme,
  darkTheme: cdevSuiteDarkTheme,
  themeMode: dark ? ThemeMode.dark : ThemeMode.light,
  // Within the home page's CdevResponsiveNavigationBar:
  // onThemeChanged: () => setState(() => dark = !dark),
)
```

The standalone demo and gallery demo both apply the change to the host app.

## Shared layout configuration

Configure the singleton once before starting your app:

```dart
void main() {
  ResponsiveLayout(mobileBreakpoint: 480, desktopBreakpoint: 1200);
  runApp(const MyApp());
}
```

Without configuration, defaults are 600 and 1024 logical pixels. Read the shared
instance anywhere; retrieving it without arguments preserves your settings:

```dart
final layout = ResponsiveLayout.instance.evaluate(constraints.maxWidth);
// 1 = mobile, 2 = medium/tablet, 3 = large/desktop
```

Use LayoutBuilder constraints for a pane's width, or
`MediaQuery.sizeOf(context).width` for the full window. The NavBar and example
use this same singleton, so their layouts follow your custom breakpoints.
Explicit NavBar breakpoint arguments override the shared settings locally.

Breakpoints must be finite and satisfy `0 < mobileBreakpoint < desktopBreakpoint`.
Invalid configuration throws ArgumentError without changing existing values.
Widths must be finite and nonnegative. Reconfiguration is supported through the
constructor but does not trigger rebuilds; configure before runApp for consistent
layouts. The existing `responsiveLayout(width)` function also uses the singleton;
its optional breakpoint overrides affect only that call.
