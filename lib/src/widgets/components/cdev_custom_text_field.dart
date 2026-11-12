import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';

class CdevCustomTextField extends StatelessWidget {
  const CdevCustomTextField(
      {super.key,
      required this.textEditingController,
      this.onChanged,
      this.onEditingComplete,
      this.inputFormatters,
      this.hintText,
      this.labelText,
      this.keyboardType});

  final TextEditingController textEditingController;
  final Function(String)? onChanged;
  final VoidCallback? onEditingComplete;
  final List<TextInputFormatter>? inputFormatters;
  final String? hintText;
  final String? labelText;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
          border: const OutlineInputBorder(),
          hintText: hintText,
          labelText: labelText),
      controller: textEditingController,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      onChanged: onChanged,
      onEditingComplete: onEditingComplete,
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
    );
  }
}
