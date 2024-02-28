import 'package:flutter/material.dart';

Future<Color?> showColorPicker(
    {required BuildContext context, List<Color>? colorList}) async {
  int red = 0;
  int green = 0;
  int blue = 0;
  int opacity = 0;
  Color selectedColor = Color.fromARGB(opacity, red, green, blue);
  TextEditingController redController = TextEditingController();
  TextEditingController greenController = TextEditingController();
  TextEditingController blueController = TextEditingController();
  TextEditingController opacityController = TextEditingController();
  await showAdaptiveDialog(
    context: context,
    builder: (context) {
      return Scaffold(
        body: Column(
          children: [
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(color: selectedColor),
                ),
                Column(
                  children: [
                    //DropdownMenu(dropdownMenuEntries: dropdownMenuEntries),
                    TextField(
                      controller: redController,
                    ), // R
                    TextField(
                      controller: greenController,
                    ), // G
                    TextField(
                      controller: blueController,
                    ), // B
                    TextField(
                      controller: opacityController,
                    ), // O
                  ],
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {},
                  child: Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: Text("Ok"),
                ),
              ],
            ),
          ],
        ),
      );
    },
  );

  return selectedColor;
}
