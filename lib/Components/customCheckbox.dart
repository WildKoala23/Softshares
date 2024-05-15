import 'package:flutter/material.dart';

class customCheckbox extends StatefulWidget {
  final String label;
  final List<String> options;
  const customCheckbox({Key? key, required this.label, required this.options})
      : super(key: key);

  @override
  State<customCheckbox> createState() => _customCheckboxState();
}

class _customCheckboxState extends State<customCheckbox> {
  late bool currentOption;

  @override
  void initState() {
    super.initState();
    currentOption = false;
    /*Remove null char at the end of list */
    if (widget.options.length > 1) {
      widget.options.removeLast();
    }
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
            return Checkbox(
              value: false,
              onChanged: (value) {
                setState(() {
                  currentOption = value!;
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }
}
