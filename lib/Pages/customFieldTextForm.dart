import 'package:flutter/material.dart';

class customFieldtextForm extends StatefulWidget {
  customFieldtextForm({super.key});

  Color containerColor = const Color(0xFFFEF7FF);
  Color appBarColor = const Color(0xff80ADD7);
  Color appBarFont = const Color(0xFFFFFFFF);
  Color mainColor = const Color(0xff80ADD7);

  @override
  State<customFieldtextForm> createState() => _customFieldtextFormState();
}

class _customFieldtextFormState extends State<customFieldtextForm> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: Text('yo'),
    );
  }

    AppBar appBar() {
    return AppBar(
      backgroundColor: widget.appBarColor,
      foregroundColor: widget.appBarFont,
      leading: IconButton(
        icon: const Icon(Icons.close),
        onPressed: () => {Navigator.pop(context, null)},
      ),
      title: const Text('Create Radio Button'),
      actions: [
        IconButton(
            onPressed: () {
              //returnValues();
              //Navigator.pop(context, {"userLabel":userLabel,"options": options});
            },
            icon: const Icon(Icons.check))
      ],
    );
  }
}