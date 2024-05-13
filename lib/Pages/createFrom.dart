import 'package:flutter/material.dart';

class createForm extends StatefulWidget {
  createForm({super.key});

  @override
  State<createForm> createState() => _MyWidgetState();

  Color containerColor = const Color(0xFFFEF7FF);
  Color appBarColor = const Color(0xff80ADD7);
  Color appBarFont = Color(0xFFFFFFFF);
}

List<String> options = [
  "Radio Button",
  "Checkbox",
  "TextField",
  "Number input"
];

class _MyWidgetState extends State<createForm> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: widget.appBarColor,
        foregroundColor: widget.appBarFont,
        leading: const Icon(Icons.close),
        title: const Text('Create Form'),
        actions: const [Icon(Icons.check)],
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            showModalBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return modalForm();
              },
            );
          },
          child: Text('Add Items'),
        ),
      ),
    );
  }

  Container modalForm() {
    String currentOption = options[0];

    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: const BorderRadius.all(Radius.circular(30)),
        color: widget.containerColor,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          RadioListTile(
              title: Text(
                options[0],
                style: const TextStyle(fontSize: 24),
              ),
              value: options[0],
              groupValue: currentOption,
              onChanged: (value) {
                setState(() {
                  currentOption = value.toString();
                });
              }),
          RadioListTile(
              title: Text(options[1], style: const TextStyle(fontSize: 24)),
              value: options[1],
              groupValue: currentOption,
              onChanged: (value) {
                setState(() {
                  currentOption = value.toString();
                });
              }),
          RadioListTile(
              title: Text(options[2], style: const TextStyle(fontSize: 24)),
              value: options[2],
              groupValue: currentOption,
              onChanged: (value) {
                setState(() {
                  currentOption = value.toString();
                });
              }),
          RadioListTile(
              title: Text(options[3], style: const TextStyle(fontSize: 24)),
              value: options[3],
              groupValue: currentOption,
              onChanged: (value) {
                setState(() {
                  currentOption = value.toString();
                });
              }),
          ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Add'))
        ],
      ),
    );
  }
}
