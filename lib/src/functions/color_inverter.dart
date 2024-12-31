import 'dart:ui';

Color colorInverter(Color color) {
  return Color.from(
    // Preserve the alpha channel
    alpha: color.a,
    red: 1 - color.r, // Invert red
    green: 1 - color.g, // Invert green
    blue: 1 - color.b, // Invert blue
  );
}
