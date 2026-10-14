import 'package:flutter/material.dart';
import 'package:mini_utils/mini_utils.dart';

import 'views/homepage.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _dark = false;

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Mini Utils Gallery',
    debugShowCheckedModeBanner: false,
    theme: cdevSuiteLightTheme,
    darkTheme: cdevSuiteDarkTheme,
    themeMode: _dark ? ThemeMode.dark : ThemeMode.light,
    home: HomePage(
      dark: _dark,
      onThemeChanged: () => setState(() => _dark = !_dark),
    ),
  );
}
