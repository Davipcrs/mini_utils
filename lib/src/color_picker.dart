import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future<Color?> showColorPicker({
  required BuildContext context,
  List<Color>? colorList,
}) async {
  int red = 0;
  int green = 0;
  int blue = 0;
  int opacity = 255;
  Color? selectedColor = Color.fromARGB(opacity, red, green, blue);
  TextEditingController redController = TextEditingController();
  TextEditingController greenController = TextEditingController();
  TextEditingController blueController = TextEditingController();
  TextEditingController opacityController = TextEditingController();
  redController.text = red.toString();
  greenController.text = green.toString();
  blueController.text = blue.toString();
  opacityController.text = opacity.toString();
  bool canceled = false;

  await showAdaptiveDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(builder: (context, state) {
        return Dialog(
          backgroundColor: Theme.of(context).colorScheme.background,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Theme.of(context).colorScheme.background,
              ),
              width: MediaQuery.of(context).size.width * 0.6,
              height: MediaQuery.of(context).size.height * 0.6,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.25,
                        height: MediaQuery.of(context).size.height * 0.50,
                        child: Center(
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.25,
                            height: MediaQuery.of(context).size.height * 0.25,
                            decoration: BoxDecoration(color: selectedColor),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.25,
                        height: MediaQuery.of(context).size.height * 0.50,
                        child: Column(
                          children: [
                            //DropdownMenu(dropdownMenuEntries: dropdownMenuEntries),
                            Padding(
                              padding:
                                  const EdgeInsets.only(bottom: 8.0, top: 12),
                              child: TextField(
                                decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    hintText: "Red (0-255)",
                                    labelText: "Red (0-255)"),
                                controller: redController,
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                onEditingComplete: () {
                                  state(
                                    () {
                                      if (redController.text == "") {
                                        return;
                                      }
                                      red = int.parse(redController.text);
                                      selectedColor = Color.fromARGB(
                                          opacity, red, green, blue);
                                    },
                                  );
                                },
                              ),
                            ), // R
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: TextField(
                                decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    hintText: "Green (0-255)",
                                    labelText: "Green (0-255)"),
                                controller: greenController,
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                onEditingComplete: () {
                                  state(
                                    () {
                                      if (greenController.text == "") {
                                        return;
                                      }
                                      green = int.parse(greenController.text);
                                      selectedColor = Color.fromARGB(
                                          opacity, red, green, blue);
                                    },
                                  );
                                },
                              ),
                            ), // G
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: TextField(
                                decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    hintText: "Blue (0-255)",
                                    labelText: "Blue (0-255)"),
                                controller: blueController,
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                onEditingComplete: () {
                                  state(
                                    () {
                                      if (blueController.text == "") {
                                        return;
                                      }
                                      blue = int.parse(blueController.text);
                                      selectedColor = Color.fromARGB(
                                          opacity, red, green, blue);
                                    },
                                  );
                                },
                              ),
                            ), // B
                            TextField(
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: "Opacity (0-255)",
                                  labelText: "Opacity (0-255)"),
                              controller: opacityController,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              onEditingComplete: () {
                                state(
                                  () {
                                    if (opacityController.text == "") {
                                      return;
                                    }
                                    opacity = int.parse(opacityController.text);
                                    selectedColor = Color.fromARGB(
                                        opacity, red, green, blue);
                                  },
                                );
                              },
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
                          canceled = true;
                          return;
                        },
                        child: const Text("Cancel"),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          selectedColor =
                              Color.fromARGB(opacity, red, green, blue);
                          Navigator.of(context).pop();
                          return;
                        },
                        child: const Text("Confirm"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      });
    },
  );
  if (canceled) {
    return null;
  }
  return selectedColor;
}
