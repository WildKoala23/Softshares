import 'package:flutter/material.dart';
import 'package:softshares/classes/ClasseAPI.dart';

class CheckAnswers extends StatefulWidget {
  CheckAnswers({super.key, required this.id});

  int id;

  @override
  State<CheckAnswers> createState() => _CheckAnswersState();
}

class _CheckAnswersState extends State<CheckAnswers> {
  API api = API();

  Future getParticipants() async {
    await api.getParticipants(widget.id);
  }

  @override
  void initState() {
    super.initState();
    getParticipants();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Answers'),
      ),
    );
  }
}
