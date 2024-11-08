import 'package:flutter/material.dart';

class DraggableContainer extends StatefulWidget {
  final Offset initPosition;
  final Widget childWidget;
  final bool lockVariable;

  const DraggableContainer({
    super.key,
    required this.initPosition,
    required this.childWidget,
    required this.lockVariable,
  });

  @override
  State<DraggableContainer> createState() => _DraggableContainerState();
}

class _DraggableContainerState extends State<DraggableContainer> {
  Offset position = Offset.zero;
  @override
  void initState() {
    position = widget.initPosition;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: position.dx,
      top: position.dy,
      child: GestureDetector(
        onPanUpdate: (details) {
          if (!widget.lockVariable) {
            setState(
              () {
                position = position + details.delta;
              },
            );
          }
        },
        child: widget.childWidget,
      ),
    );
  }
}
