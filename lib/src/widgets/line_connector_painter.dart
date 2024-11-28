import 'package:flutter/material.dart';

class Tuple2<T1, T2> {
  final T1 item1;
  final T2 item2;

  Tuple2(this.item1, this.item2);
}

class LineConnectorPainter extends CustomPainter {
  final List<Tuple2<Offset, Offset>> lines;
  final Color lineColor;

  LineConnectorPainter({required this.lines, required this.lineColor});
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = lineColor
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    for (final line in lines) {
      canvas.drawLine(line.item1, line.item2, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
