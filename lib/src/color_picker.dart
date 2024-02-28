import 'package:flutter/material.dart';

Future<Color?> showColorPicker({
  required BuildContext context,
  List<Color>? colorList,
}) async {
  int red = 0;
  int green = 0;
  int blue = 0;
  int opacity = 0;
  Color? selectedColor = Color.fromARGB(opacity, red, green, blue);
  TextEditingController redController = TextEditingController();
  TextEditingController greenController = TextEditingController();
  TextEditingController blueController = TextEditingController();
  TextEditingController opacityController = TextEditingController();

  await showAdaptiveDialog(
    context: context,
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.all(12.0),
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.60,
          height: MediaQuery.of(context).size.height * 0.60,
          child: Scaffold(
            body: Column(
              children: [
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(color: selectedColor),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.30,
                      height: MediaQuery.of(context).size.height * 0.30,
                      child: Column(
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
                      ),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        Navigator.of(context).pop();
                        selectedColor = null;
                        return;
                      },
                      child: Text("Cancel"),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        selectedColor =
                            Color.fromARGB(opacity, red, green, blue);
                        Navigator.of(context).pop();
                        return;
                      },
                      child: Text("Confirm"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
  return selectedColor;
}
