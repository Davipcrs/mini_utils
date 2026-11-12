import 'package:material_ui/material_ui.dart';

import '../../functions/responsive_layout.dart';
import '../helpers/navigation_bar_item.dart';

/// Responsive, presentational navigation with no routing or page management.
///
/// Place in a Row beside an Expanded page on tablet/desktop. Below
/// [mobileBreakpoint], place it directly in Scaffold.drawer instead. The parent
/// should use a LayoutBuilder with the same breakpoints to choose that slot.
/// Selection and drawer dismissal remain the caller's responsibility.
class CdevResponsiveNavigationBar extends StatefulWidget {
  /// Creates a navigation bar. All dimensions use logical pixels.
  const CdevResponsiveNavigationBar({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.destinations,
    this.onNewItemPressed,
    this.onThemeChanged,
    this.newItemLabel = 'New Item',
    this.newItemIcon = Icons.add,
    this.backgroundColor,
    this.selectedColor,
    this.selectedForegroundColor,
    this.inactiveColor,
    this.newItemBackgroundColor,
    this.newItemForegroundColor,
    this.mobileBreakpoint,
    this.desktopBreakpoint,
    this.collapsedWidth = 80,
    this.expandedWidth = 256,
    this.initiallyExpanded = true,
    this.animationDuration = const Duration(milliseconds: 240),
  })  : assert(destinations.length > 0),
        assert(selectedIndex >= 0 && selectedIndex < destinations.length),
        assert(mobileBreakpoint == null || mobileBreakpoint > 0),
        assert(desktopBreakpoint == null || desktopBreakpoint > 0),
        assert(mobileBreakpoint == null ||
            desktopBreakpoint == null ||
            mobileBreakpoint < desktopBreakpoint),
        assert(collapsedWidth >= 72 && expandedWidth >= collapsedWidth);

  /// Controlled destination index.
  final int selectedIndex;

  /// Called when a destination is tapped.
  final ValueChanged<int> onDestinationSelected;

  /// Destinations in display order.
  final List<NavigationBarItem> destinations;

  /// Enables the optional creation button when non-null.
  final VoidCallback? onNewItemPressed;

  /// Optional theme toggle callback. The host owns ThemeMode and updates its
  /// MaterialApp; the button reflects the current Theme brightness.
  final VoidCallback? onThemeChanged;

  /// Creation button label and tooltip.
  final String newItemLabel;

  /// Creation button icon.
  final IconData newItemIcon;

  /// Navigation surface color. Defaults to ColorScheme.surface.
  final Color? backgroundColor;

  /// Selected destination pill color. Defaults to ColorScheme.primaryContainer.
  final Color? selectedColor;

  /// Selected foreground. Defaults to ColorScheme.onPrimaryContainer.
  final Color? selectedForegroundColor;

  /// Inactive foreground. Defaults to ColorScheme.onSurfaceVariant.
  final Color? inactiveColor;

  /// Creation surface. Defaults to ColorScheme.secondaryContainer.
  final Color? newItemBackgroundColor;

  /// Creation foreground. Defaults to ColorScheme.onSecondaryContainer.
  final Color? newItemForegroundColor;

  /// Drawer breakpoint override. Defaults to ResponsiveLayout.instance.
  final double? mobileBreakpoint;

  /// Desktop breakpoint override. Defaults to ResponsiveLayout.instance.
  final double? desktopBreakpoint;

  /// Width of the icon-only sidebar.
  final double collapsedWidth;

  /// Preferred width of the expanded sidebar and mobile drawer.
  final double expandedWidth;

  /// Initial desktop expansion preference, preserved through resizes.
  final bool initiallyExpanded;

  /// Duration of sidebar width and label animations.
  final Duration animationDuration;

  @override
  State<CdevResponsiveNavigationBar> createState() =>
      _CdevResponsiveNavigationBarState();
}

class _CdevResponsiveNavigationBarState
    extends State<CdevResponsiveNavigationBar> {
  late bool _expanded = widget.initiallyExpanded;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
        builder: (context, constraints) {
          final colors = Theme.of(context).colorScheme;
          final dark = Theme.of(context).brightness == Brightness.dark;
          final background = widget.backgroundColor ?? colors.surface;
          final inactive = widget.inactiveColor ?? colors.onSurfaceVariant;
          // Row gives non-flex children unbounded horizontal constraints.
          final width = constraints.hasBoundedWidth
              ? constraints.maxWidth
              : MediaQuery.sizeOf(context).width;
          final layout = ResponsiveLayout.instance.evaluate(
            width,
            mobileBreakpoint: widget.mobileBreakpoint,
            desktopBreakpoint: widget.desktopBreakpoint,
          );
          final mobile = layout == 1;
          final desktop = layout == 3;
          final expanded = mobile || (desktop && _expanded);
          final content = Material(
            color: background,
            child: SafeArea(
              child: ListView(
                padding: const EdgeInsets.all(12),
                children: [
                  if (mobile || desktop) ...[
                    Align(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        tooltip: mobile
                            ? 'Close navigation'
                            : expanded
                                ? 'Collapse navigation'
                                : 'Expand navigation',
                        color: inactive,
                        icon: Icon(mobile ? Icons.close : Icons.menu),
                        onPressed: mobile
                            ? () => Scaffold.maybeOf(context)?.closeDrawer()
                            : () => setState(() => _expanded = !_expanded),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                  if (widget.onNewItemPressed != null) ...[
                    _button(
                      label: widget.newItemLabel,
                      icon: widget.newItemIcon,
                      expanded: expanded,
                      background: widget.newItemBackgroundColor ??
                          colors.secondaryContainer,
                      foreground: widget.newItemForegroundColor ??
                          colors.onSecondaryContainer,
                      onTap: widget.onNewItemPressed!,
                    ),
                    const SizedBox(height: 24),
                  ],
                  for (var i = 0; i < widget.destinations.length; i++)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: _button(
                        label: widget.destinations[i].label,
                        icon: i == widget.selectedIndex
                            ? widget.destinations[i].selectedIcon ??
                                widget.destinations[i].icon
                            : widget.destinations[i].icon,
                        expanded: expanded,
                        background: i == widget.selectedIndex
                            ? widget.selectedColor ?? colors.primaryContainer
                            : Colors.transparent,
                        foreground: i == widget.selectedIndex
                            ? widget.selectedForegroundColor ??
                                colors.onPrimaryContainer
                            : inactive,
                        selected: i == widget.selectedIndex,
                        onTap: () => widget.onDestinationSelected(i),
                      ),
                    ),
                  if (widget.onThemeChanged != null) ...[
                    const SizedBox(height: 16),
                    _button(
                      label: dark ? 'Use light theme' : 'Use dark theme',
                      icon: dark
                          ? Icons.light_mode_outlined
                          : Icons.dark_mode_outlined,
                      expanded: expanded,
                      background: Colors.transparent,
                      foreground: inactive,
                      onTap: widget.onThemeChanged!,
                    ),
                  ],
                ],
              ),
            ),
          );
          if (mobile) {
            return Drawer(
              width: widget.expandedWidth,
              backgroundColor: background,
              child: content,
            );
          }
          return AnimatedContainer(
            duration: widget.animationDuration,
            curve: Curves.easeInOutCubic,
            width: expanded ? widget.expandedWidth : widget.collapsedWidth,
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(color: background),
            child: content,
          );
        },
      );

  Widget _button({
    required String label,
    required IconData icon,
    required bool expanded,
    required Color background,
    required Color foreground,
    required VoidCallback onTap,
    bool selected = false,
  }) =>
      Semantics(
        selected: selected,
        button: true,
        child: Tooltip(
          message: label,
          child: Material(
            color: background,
            borderRadius: BorderRadius.circular(999),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: onTap,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                child: Row(
                  children: [
                    Icon(icon,
                        color: foreground,
                        size: 24,
                        semanticLabel: expanded ? null : label),
                    Expanded(
                      child: AnimatedOpacity(
                        opacity: expanded ? 1 : 0,
                        duration: widget.animationDuration,
                        child: ExcludeSemantics(
                          excluding: !expanded,
                          child: Padding(
                            padding: EdgeInsets.only(left: expanded ? 12 : 0),
                            child: Text(
                              expanded ? label : '',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(color: foreground),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
}
