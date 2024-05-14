import 'package:flutter/material.dart';

class customRadioBtn extends StatefulWidget {
  final String label;
  final List<String> options;
  const customRadioBtn({super.key, required this.label, required this.options});

  @override
  State<customRadioBtn> createState() => _customRadioBtnState();
}

class _customRadioBtnState extends State<customRadioBtn> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          child: Text(widget.label),
        ),
        Expanded(
            child: ListView.builder(
                itemCount: widget.options.length,
                itemBuilder: (context, index) {
                  return Text('data');

                  /*RadioListTile(
              value: widget.options[index],
              groupValue: widget.options[index],
              onChanged: (value) {})*/
                  ;
                }))
      ],
    );
  }
}
