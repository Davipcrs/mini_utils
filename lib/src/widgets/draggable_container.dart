import 'package:flutter/material.dart';

typedef OffsetCallback = void Function(Offset val);

// @DOCSTART
class DraggableContainer extends StatefulWidget {
  /// This class is a Draggable custom container.
  /// Need to be in a Stack because the use of the Positioned Widget
  // @DOCEND
  final Offset initPosition;
  final Widget childWidget;
  final bool lockVariable;
  final OffsetCallback onMove;

  const DraggableContainer({
    super.key,
    required this.initPosition,
    required this.childWidget,
    required this.lockVariable,
    required this.onMove,
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
                if (position + details.delta < MediaQuery.sizeOf(context) &&
                    position + details.delta > Offset.zero) {
                  position = position + details.delta;
                }
                widget.onMove(position);
              },
            );
          }
        },
        child: widget.childWidget,
      ),
    );
  }
}
