import 'package:flutter/material.dart';

class customTextField extends StatefulWidget {
  final String label;
  final bool numericInput;
  TextEditingController? controller;

  // Properly define the key parameter in the constructor

  customTextField(
      {Key? key,
      required this.label,
      required this.numericInput,
      this.controller})
      : super(key: key);

  @override
  State<customTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<customTextField> {
  late TextEditingController labelController;

  @override
  void initState() {
    /*If not provided with a controller, create a new one */
    labelController = widget.controller ?? TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    labelController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 25, top: 20, right: 25),
      child: TextField(
        controller: labelController,
        keyboardType:
            widget.numericInput ? TextInputType.number : TextInputType.name,
        decoration: InputDecoration(
          labelText: widget.label, // Use labelText instead of label
        ),
      ),
    );
  }
}
