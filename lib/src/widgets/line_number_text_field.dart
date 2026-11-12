import 'package:flutter/material.dart';

/// A multiline text field with a synchronized line-number gutter.
class LineNumberTextField extends StatefulWidget {
  /// Creates a text field with optional syntax highlighting.
  const LineNumberTextField({
    super.key,
    this.controller,
    this.style,
    this.decoration,
    this.onChanged,
    this.syntaxHighlighter,
  });

  /// The caller-owned controller for editing and retrieving text.
  final TextEditingController? controller;
  /// The base style for text and line numbers.
  final TextStyle? style;
  /// The decoration applied to the editable field.
  final InputDecoration? decoration;
  /// Called once when the user changes the text.
  final ValueChanged<String>? onChanged;

  /// Builds styled spans for the current text. The returned span must contain
  /// exactly the input text, without adding or removing characters. Prefer color-only
  /// styles to keep the text aligned with the line numbers.
  ///
  /// Highlighting is temporarily suspended while an input method composes text.
  final TextSpan Function(String text, TextStyle style)? syntaxHighlighter;

  @override
  State<LineNumberTextField> createState() => _LineNumberTextFieldState();
}

class _LineNumberTextFieldState extends State<LineNumberTextField> {
  late _HighlightingController _textController;
  late final ScrollController _textScrollController;
  late final ScrollController _lineScrollController;

  int _lineCount = 1;

  static const double _fontSize = 15;
  static const double _lineHeight = 1.5;

  @override
  void initState() {
    super.initState();

    _textController = _HighlightingController(
      source: widget.controller,
      highlighter: widget.syntaxHighlighter,
    );

    _textScrollController = ScrollController();
    _lineScrollController = ScrollController();

    _textController.addListener(_onTextChanged);
    _textScrollController.addListener(_onTextScroll);

    _updateLineCount();
  }

  @override
  void didUpdateWidget(covariant LineNumberTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      final previousValue = _textController.value;
      _textController.removeListener(_onTextChanged);
      _textController.dispose();
      _textController = _HighlightingController(
        source: widget.controller,
        highlighter: widget.syntaxHighlighter,
        initialValue: previousValue,
      );
      _textController.addListener(_onTextChanged);
      _lineCount = '\n'.allMatches(_textController.text).length + 1;
    } else {
      _textController.highlighter = widget.syntaxHighlighter;
    }
  }

  void _onTextChanged() {
    _updateLineCount();
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

    _textController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = widget.style ??
        const TextStyle(
          fontFamily: 'RobotoMono',
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

/// Keeps the caller's controller in sync without taking ownership of it.
class _HighlightingController extends TextEditingController {
  _HighlightingController({
    this.source,
    this.highlighter,
    TextEditingValue? initialValue,
  }) : super.fromValue(source?.value ?? initialValue) {
    source?.addListener(_readSource);
    addListener(_writeSource);
  }

  final TextEditingController? source;
  TextSpan Function(String text, TextStyle style)? highlighter;

  void _readSource() {
    if (value != source!.value) value = source!.value;
  }

  void _writeSource() {
    if (source != null && source!.value != value) source!.value = value;
  }

  @override
  TextSpan buildTextSpan({
    required BuildContext context,
    TextStyle? style,
    required bool withComposing,
  }) {
    final composing = withComposing &&
        value.isComposingRangeValid &&
        !value.composing.isCollapsed;
    if (highlighter != null && !composing) {
      final span = highlighter!(text, style ?? const TextStyle());
      assert(span.toPlainText() == text,
          'syntaxHighlighter must preserve the original text.');
      return TextSpan(style: style, children: [span]);
    }
    return source?.buildTextSpan(
            context: context, style: style, withComposing: withComposing) ??
        super.buildTextSpan(
            context: context, style: style, withComposing: withComposing);
  }

  @override
  void dispose() {
    source?.removeListener(_readSource);
    removeListener(_writeSource);
    super.dispose();
  }
}
