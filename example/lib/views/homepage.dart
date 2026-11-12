import 'package:flutter/material.dart';
import 'package:mini_utils/mini_utils.dart';

import '../dart_syntax_highlighter.dart';
import '../responsive_navigation_demo.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.dark, required this.onThemeChanged});

  final bool dark;
  final VoidCallback onThemeChanged;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Color _color = Colors.indigo;
  DateTime? _date;
  Offset _position = const Offset(24, 32);
  bool _locked = false;
  bool _highlightSyntax = true;
  final _editor = TextEditingController(
    text: '// Try editing this text.\nimport \'package:mini_utils/mini_utils.dart\';\n\nvoid main() {\n  // Small utilities, reusable widgets.\n}',
  );

  @override
  void dispose() {
    _editor.dispose();
    super.dispose();
  }

  Future<void> _pickColor() async {
    final color = await showColorPicker(context: context);
    if (!mounted || color == null) return;
    setState(() => _color = color);
  }

  Future<void> _pickDate() async {
    final date = await showDateTimePicker(context: context, initialDate: _date);
    if (!mounted || date == null) return;
    setState(() => _date = date);
  }

  Widget _section(String title, String description, Widget child) => Card(
    margin: const EdgeInsets.only(bottom: 20),
    child: Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(description),
          const SizedBox(height: 16),
          child,
        ],
      ),
    ),
  );

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Mini Utils Gallery'),
      actions: [
        Tooltip(
          message: widget.dark ? 'Use light theme' : 'Use dark theme',
          child: CdevCustomElevatedButton(
            onPressed: widget.onThemeChanged,
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(48, 48),
              padding: EdgeInsets.zero,
            ),
            child: Icon(widget.dark ? Icons.light_mode : Icons.dark_mode),
          ),
        ),
      ],
    ),
    body: SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              const Text(
                'Explore the widgets and helpers exported by mini_utils.',
              ),
              const SizedBox(height: 20),
              _section(
                'Responsive navigation',
                'Try the desktop sidebar, tablet rail and mobile drawer.',
                FilledButton(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => ResponsiveNavigationDemo(
                        onThemeChanged: widget.onThemeChanged,
                      ),
                    ),
                  ),
                  child: const Text('Open navigation demo'),
                ),
              ),
              _section(
                'Cdev custom button',
                'Shared button styling that follows the current light or dark theme.',
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    CdevCustomElevatedButton(
                      onPressed: () => ScaffoldMessenger.of(context)
                          .showSnackBar(
                            const SnackBar(
                              content: Text('Cdev button pressed'),
                            ),
                          ),
                      child: const Text('Try cdev button'),
                    ),
                    const CdevCustomElevatedButton(
                      onPressed: null,
                      child: Text('Disabled'),
                    ),
                    CdevCustomElevatedButton(
                      onPressed: () => ScaffoldMessenger.of(context)
                          .showSnackBar(
                            const SnackBar(
                              content: Text('Custom button pressed'),
                            ),
                          ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Theme.of(context)
                            .colorScheme
                            .onPrimary,
                      ),
                      child: const Text('Custom colors'),
                    ),
                  ],
                ),
              ),
              _section(
                'Color picker & inverter',
                'Choose an RGBA color and compare it with its inverse.',
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        _swatch('Selected', _color),
                        _swatch('Inverted', colorInverter(_color)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    CdevCustomElevatedButton(
                      onPressed: _pickColor,
                      child: const Text('Choose color'),
                    ),
                  ],
                ),
              ),
              _section(
                'Date & time picker',
                'Select a date, then a time. The result appears below.',
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _date == null
                          ? 'No date selected'
                          : '${MaterialLocalizations.of(context).formatMediumDate(_date!)} · ${TimeOfDay.fromDateTime(_date!).format(context)}',
                    ),
                    const SizedBox(height: 12),
                    CdevCustomElevatedButton(
                      onPressed: _pickDate,
                      child: const Text('Choose date & time'),
                    ),
                  ],
                ),
              ),
              _section(
                'Line-numbered editor',
                'Edit the Dart sample or add lines to see syntax colors and line numbers update.',
                Column(
                  children: [
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Syntax highlighting'),
                      value: _highlightSyntax,
                      onChanged: (value) =>
                          setState(() => _highlightSyntax = value),
                    ),
                    SizedBox(
                      height: 220,
                      child: LineNumberTextField(
                        controller: _editor,
                        style: TextStyle(
                          //fontFamily: 'monospace',
                          fontSize: 15,
                          height: 1.5,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                        syntaxHighlighter: _highlightSyntax
                            ? (text, style) => highlightDart(
                                text,
                                style,
                                Theme.of(context).colorScheme,
                              )
                            : null,
                      ),
                    ),
                  ],
                ),
              ),
              _section(
                'Draggable container & connectors',
                'Drag the card to move it and update the connecting line.',
                Column(
                  children: [
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Lock position'),
                      value: _locked,
                      onChanged: (value) => setState(() => _locked = value),
                    ),
                    Text(
                      'Position: ${_position.dx.round()}, ${_position.dy.round()}',
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 240,
                      width: double.infinity,
                      child: ClipRect(
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: CustomPaint(
                                painter: LineConnectorPainter(
                                  lines: [
                                    Tuple2(
                                      const Offset(12, 220),
                                      _position + const Offset(60, 28),
                                    ),
                                  ],
                                  lineColor: Theme.of(context)
                                      .colorScheme
                                      .primary,
                                ),
                              ),
                            ),
                            DraggableContainer(
                              initPosition: _position,
                              lockVariable: _locked,
                              onMove: (value) =>
                                  setState(() => _position = value),
                              childWidget: Container(
                                width: 120,
                                height: 56,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primaryContainer,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Text('Drag me'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              _section(
                'Login screen',
                'A sample form with local feedback for each action. No credentials are sent.',
                CdevCustomElevatedButton(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(builder: (_) => const _LoginDemo()),
                  ),
                  child: const Text('Open login demo'),
                ),
              ),
              _section(
                'Digital clock',
                'Display the current local time in hours and minutes.',
                CdevCustomElevatedButton(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (context) => Scaffold(
                        appBar: AppBar(title: const Text('Digital clock')),
                        body: Center(
                          child: digitalClock(
                            context: context,
                            style: Theme.of(context).textTheme.displayLarge,
                          ),
                        ),
                      ),
                    ),
                  ),
                  child: const Text('Open clock demo'),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );

  Widget _swatch(String label, Color color) => Container(
    width: 150,
    height: 80,
    alignment: Alignment.center,
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(8),
    ),
    child: Text(
      label,
      style: TextStyle(
        color: color.computeLuminance() > 0.5 ? Colors.black : Colors.white,
      ),
    ),
  );
}

class _LoginDemo extends StatefulWidget {
  const _LoginDemo();

  @override
  State<_LoginDemo> createState() => _LoginDemoState();
}

class _LoginDemoState extends State<_LoginDemo> {
  final _login = TextEditingController();
  final _password = TextEditingController();

  @override
  void dispose() {
    _login.dispose();
    _password.dispose();
    super.dispose();
  }

  void _message(String text) {
    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(text)));
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Login demo')),
    body: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 560),
        child: loginScreen(
          context: context,
          loginController: _login,
          passwordController: _password,
          customGreetingText: 'Welcome to the Mini Utils demo',
          onSubmit: () => _message(
            _login.text.trim().isEmpty || _password.text.isEmpty
                ? 'Enter a username and password.'
                : 'Demo login submitted for ${_login.text.trim()}.',
          ),
          onCancel: () => Navigator.of(context).pop(),
          onChangePassword: () =>
              _message('Password recovery callback triggered.'),
          onCreateUser: () => _message('Create user callback triggered.'),
        ),
      ),
    ),
  );
}
