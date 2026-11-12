import 'package:material_ui/material_ui.dart';

/// Defines a type based on a function that recieves the Offset Value for being used
/// as a callback on DraggableContainer
/// This function will be used to change position of the DraggableContainer
typedef OffsetCallback = void Function(Offset val);

// @DOCSTART
/// This class is a Draggable custom container.
/// Need to be in a Stack because the use of the Positioned Widget
class DraggableContainer extends StatefulWidget {
  // @DOCEND

  ///Init Position of the DraggableContainer
  final Offset initPosition;

  ///DraggableContainer Widget Child - need for personalize the container
  final Widget childWidget;

  ///This variable locks the position of the DraggableContainer
  final bool lockVariable;

  ///Callback function based on the type OffsetCallback resposible for moving the
  ///DraggableContainer
  final OffsetCallback onMove;

  /// Constructor for DraggableContainer
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
