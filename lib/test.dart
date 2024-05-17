import 'package:flutter/material.dart';
import 'package:softshares/Components/customRadioBtn.dart';
import 'package:softshares/Components/customTextField.dart';

class test extends StatefulWidget {
  const test({Key? key});

  @override
  State<test> createState() => _testState();
}

class _testState extends State<test> {
  TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        customTextField(
          label: 'Teste',
          numericInput: false,
          controller: controller,
        ),
        ElevatedButton(
            onPressed: () {
              print(controller.text);
            },
            child: Text('Teste'))
      ],
    )));
  }
}
