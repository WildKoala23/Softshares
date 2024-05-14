import 'package:flutter/material.dart';
import 'package:softshares/Components/customRadioBtn.dart';

class test extends StatefulWidget {
  const test({Key? key});

  @override
  State<test> createState() => _testState();
}

class _testState extends State<test> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          height: 200, // Example height, you can adjust as needed
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomRadioBtn(label: 'label', options: ['option1', 'option2']),
            ],
          ),
        ),
      ),
    );
  }
}
