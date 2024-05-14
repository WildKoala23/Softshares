import 'package:flutter/material.dart';

class customTextField extends StatefulWidget {
  final String label;
  const customTextField({super.key, required this.label});

  @override
  State<customTextField> createState() => _customTextFieldState();
}

class _customTextFieldState extends State<customTextField> {
  final TextEditingController labelController = TextEditingController();

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
        decoration: InputDecoration(
          label: Text(widget.label),
        ),
      ),
    );
  }
}
