import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';
import 'package:mini_utils/src/widgets/components/cdev_custom_text_field.dart';

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
          backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Theme.of(context).colorScheme.surfaceContainer,
              ),
              width: MediaQuery.of(context).size.width * 0.4,
              height: MediaQuery.of(context).size.height * 0.285,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.18,
                        height: MediaQuery.of(context).size.height * 0.25,
                        child: Container(
                          // width: MediaQuery.of(context).size.width * 0.25,
                          // height: MediaQuery.of(context).size.height * 0.125,
                          decoration: BoxDecoration(
                              color: selectedColor,
                              borderRadius: BorderRadius.circular(16)),
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.15,
                        height: MediaQuery.of(context).size.height * 0.25,
                        child: Column(
                          children: [
                            //DropdownMenu(dropdownMenuEntries: dropdownMenuEntries),
                            Padding(
                              padding:
                                  const EdgeInsets.only(bottom: 8.0, top: 12),
                              child: CdevCustomTextField(
                                hintText: "Red (0-255)",
                                labelText: "Red (0-255)",
                                textEditingController: redController,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                keyboardType: TextInputType.number,
                                onChanged: (value) {
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
                                /*
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
                                */
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
                                onChanged: (value) {
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
                                /*
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
                                */
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
                                  onChanged: (value) {
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
                                  }
                                  /*
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
                                }
                                */
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
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 12.0),
                        child: TextButton(
                          onPressed: () async {
                            Navigator.of(context).pop();
                            selectedColor = null;
                            canceled = true;
                            return;
                          },
                          child: const Text("Cancel"),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 24.0),
                        child: TextButton(
                          onPressed: () async {
                            selectedColor =
                                Color.fromARGB(opacity, red, green, blue);
                            Navigator.of(context).pop();
                            return;
                          },
                          child: const Text("OK"),
                        ),
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
