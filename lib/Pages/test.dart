import 'package:flutter/material.dart';
import 'package:softshares/Components/dynamicForm.Modal.dart';
import '../Components/appBar.dart';


class Test extends StatefulWidget {
  const Test({super.key});

  final Color appBarColor = const Color(0xff80ADD7);

  @override
  State<Test> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<Test> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        iconL: const Icon(Icons.notifications),
        iconR: const Icon(Icons.search),
        title: 'Test Page',
      ), //homeAppBar(),
      body: const formModal(),
    );
  }
}