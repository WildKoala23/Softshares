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
  late List<bool> selectedOptions;
  

  @override
  void initState() {
    super.initState();
    // Initialize all options as unselected
    selectedOptions = List<bool>.filled(widget.options.length, false);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
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
            int index = widget.options.indexOf(option);
            return CheckboxListTile(
              title: Text(option),
              value: selectedOptions[index],
              onChanged: (value) {
                setState(() {
                  selectedOptions[index] = value ?? false;
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }
}
