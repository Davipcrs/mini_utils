import 'package:flutter/material.dart';
import 'package:mini_utils/mini_utils.dart';

class ColorPickerTest extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
        title: Text("adwa"),
      ),
      body: Center(
        child: ElevatedButton(
            onPressed: () async {
              print(await showColorPicker(context: context));
            },
            child: Text("Press")),
      ),
    );
  }
}
