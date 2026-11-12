import 'package:flutter/material.dart';

/// An elevated button with consistent defaults for cdev suite apps.
///
/// Colors and text styling follow the current theme. The app's
/// [ElevatedButtonThemeData.style] overrides the suite defaults, and [style]
/// overrides both. Set [onPressed] to null to disable the button.
class CdevCustomElevatedButton extends StatelessWidget {
  /// Creates a cdev suite button.
  const CdevCustomElevatedButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.onLongPress,
    this.style,
    this.autofocus = false,
    this.focusNode,
  });

  /// Called when the button is pressed; null disables the button.
  final VoidCallback? onPressed;

  /// Called when the button is long-pressed.
  final VoidCallback? onLongPress;

  /// The button's label or other content.
  final Widget child;

  /// Optional overrides for this button's appearance.
  final ButtonStyle? style;

  /// Whether the button requests focus automatically.
  final bool autofocus;

  /// An optional focus node managed by the caller.
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    final suiteStyle = ElevatedButton.styleFrom(
        minimumSize: const Size(64, 48),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        shadowColor: Theme.of(context).colorScheme.primaryFixed
        //backgroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
        );

    final themedStyle =
        ElevatedButtonTheme.of(context).style?.merge(suiteStyle) ?? suiteStyle;

    return ElevatedButton(
      onPressed: onPressed,
      onLongPress: onPressed == null ? null : onLongPress,
      style: style?.merge(themedStyle) ?? themedStyle,
      autofocus: autofocus,
      focusNode: focusNode,
      child: child,
    );
  }
}
