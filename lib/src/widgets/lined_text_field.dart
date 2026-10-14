import 'package:flutter/material.dart';

class LineNumberTextField extends StatefulWidget {
  const LineNumberTextField({
    super.key,
    this.controller,
    this.style,
    this.decoration,
    this.onChanged,
  });

  final TextEditingController? controller;
  final TextStyle? style;
  final InputDecoration? decoration;
  final ValueChanged<String>? onChanged;

  @override
  State<LineNumberTextField> createState() => _LineNumberTextFieldState();
}

class _LineNumberTextFieldState extends State<LineNumberTextField> {
  late final TextEditingController _textController;
  late final ScrollController _textScrollController;
  late final ScrollController _lineScrollController;

  bool _ownsTextController = false;

  int _lineCount = 1;

  static const double _fontSize = 14;
  static const double _lineHeight = 1.5;

  @override
  void initState() {
    super.initState();

    if (widget.controller != null) {
      _textController = widget.controller!;
    } else {
      _textController = TextEditingController();
      _ownsTextController = true;
    }

    _textScrollController = ScrollController();
    _lineScrollController = ScrollController();

    _textController.addListener(_onTextChanged);
    _textScrollController.addListener(_onTextScroll);

    _updateLineCount();
  }

  void _onTextChanged() {
    _updateLineCount();
    widget.onChanged?.call(_textController.text);
  }

  void _updateLineCount() {
    final text = _textController.text;

    final count = '\n'.allMatches(text).length + 1;

    if (count != _lineCount) {
      setState(() {
        _lineCount = count;
      });
    }
  }

  void _onTextScroll() {
    if (!_lineScrollController.hasClients) {
      return;
    }

    final offset = _textScrollController.offset;

    final maxOffset = _lineScrollController.position.maxScrollExtent;

    _lineScrollController.jumpTo(
      offset.clamp(0.0, maxOffset),
    );
  }

  @override
  void dispose() {
    _textController.removeListener(_onTextChanged);
    _textScrollController.removeListener(_onTextScroll);

    _textScrollController.dispose();
    _lineScrollController.dispose();

    if (_ownsTextController) {
      _textController.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = widget.style ??
        const TextStyle(
          fontFamily: 'monospace',
          fontSize: _fontSize,
          height: _lineHeight,
        );

    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).dividerColor,
        ),
        borderRadius: BorderRadius.circular(4),
      ),
      clipBehavior: Clip.antiAlias,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildLineNumbers(textStyle),
          Expanded(
            child: TextField(
              controller: _textController,
              scrollController: _textScrollController,
              maxLines: null,
              minLines: 1,
              expands: false,
              style: textStyle,
              keyboardType: TextInputType.multiline,
              textInputAction: TextInputAction.newline,
              decoration: widget.decoration ??
                  const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                  ),
              onChanged: widget.onChanged,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLineNumbers(TextStyle textStyle) {
    return Container(
      width: 50,
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
        child: SingleChildScrollView(
          controller: _lineScrollController,
          physics: const NeverScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.only(
              top: 8,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(
                _lineCount,
                (index) {
                  return SizedBox(
                    height: textStyle.fontSize! * _lineHeight,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        right: 8,
                      ),
                      child: Text(
                        '${index + 1}',
                        style: textStyle.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
