import 'package:flutter/material.dart';

class customRadioBtnForm extends StatefulWidget {
  customRadioBtnForm({super.key});

  Color containerColor = const Color(0xFFFEF7FF);
  Color appBarColor = const Color(0xff80ADD7);
  Color appBarFont = const Color(0xFFFFFFFF);
  Color mainColor = const Color(0xff80ADD7);

  @override
  State<customRadioBtnForm> createState() => _customRadioBtnState();
}

class _customRadioBtnState extends State<customRadioBtnForm> {
  TextEditingController titleController = TextEditingController();

  @override
  void dispose(){
    super.dispose();
    titleController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: widget.appBarColor,
        foregroundColor: widget.appBarFont,
        leading: const Icon(Icons.close),
        title: const Text('Create Radio Button'),
        actions: const [Icon(Icons.check)],
      ),
      body: Column(
        children: [
          TextField(
            controller: titleController,
          ),
        ],
      ),
    );
  }
}
