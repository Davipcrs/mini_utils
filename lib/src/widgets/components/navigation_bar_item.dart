import 'package:flutter/material.dart';

/// A destination displayed by [ResponsiveNavigationBar].
@immutable
class NavigationBarItem {
  /// Creates a destination with an optional selected icon.
  const NavigationBarItem({
    required this.icon,
    required this.label,
    this.selectedIcon,
  });

  /// Icon displayed when this destination is inactive.
  final IconData icon;

  /// Optional icon displayed when selected.
  final IconData? selectedIcon;

  /// Visible label and accessibility description.
  final String label;
}
