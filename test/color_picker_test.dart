import 'package:flutter/material.dart';
import 'package:mini_utils/mini_utils.dart';

class ColorPickerTest extends StatelessWidget {
  const ColorPickerTest({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: "Test",
      home: MyWidget(),
    );
  }
}

class MyWidget extends StatelessWidget {
  const MyWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("adwa"),
      ),
      body: Center(
        child: ElevatedButton(
            onPressed: () async {
              print(await showColorPicker(context: context));
            },
            child: const Text("Press")),
      ),
    );
  }
}
