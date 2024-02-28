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

  await showAdaptiveDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(builder: (context, state) {
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.60,
              height: MediaQuery.of(context).size.height * 0.60,
              child: Scaffold(
                body: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.25,
                          height: MediaQuery.of(context).size.height * 0.60,
                          child: Container(
                            decoration: BoxDecoration(color: selectedColor),
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.25,
                          height: MediaQuery.of(context).size.height * 0.60,
                          child: Column(
                            children: [
                              //DropdownMenu(dropdownMenuEntries: dropdownMenuEntries),
                              TextField(
                                controller: redController,
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                onEditingComplete: () {
                                  state(
                                    () {
                                      red = int.parse(redController.text);
                                      selectedColor = Color.fromARGB(
                                          opacity, red, green, blue);
                                    },
                                  );
                                },
                              ), // R
                              TextField(
                                controller: greenController,
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                onEditingComplete: () {
                                  state(
                                    () {
                                      green = int.parse(redController.text);
                                      selectedColor = Color.fromARGB(
                                          opacity, red, green, blue);
                                    },
                                  );
                                },
                              ), // G
                              TextField(
                                controller: blueController,
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                onEditingComplete: () {
                                  state(
                                    () {
                                      blue = int.parse(redController.text);
                                      selectedColor = Color.fromARGB(
                                          opacity, red, green, blue);
                                    },
                                  );
                                },
                              ), // B
                              TextField(
                                controller: opacityController,
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                onEditingComplete: () {
                                  state(
                                    () {
                                      opacity = int.parse(redController.text);
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
          ),
        );
      });
    },
  );
  return selectedColor;
}
