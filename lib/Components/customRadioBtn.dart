import 'package:flutter/material.dart';

class customRadioBtn extends StatefulWidget {
  final String label;
  final List<String> options;

  const customRadioBtn({Key? key, required this.label, required this.options})
      : super(key: key);

  @override
  State<customRadioBtn> createState() => _CustomRadioBtnState();
}

class _CustomRadioBtnState extends State<customRadioBtn> {
  late String selectedOption; // Initialize selectedOption

  @override
  void initState() {
    super.initState();
    selectedOption = widget.options.first; // Initialize to the first option
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 25.0, top: 20),
          child: Text(
            widget.label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
        Column(
          children: widget.options.map((option) {
            return RadioListTile(
              title: Text(option),
              value: option,
              groupValue: selectedOption,
              onChanged: (value) {
                setState(() {
                  selectedOption = value.toString();
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }
}
