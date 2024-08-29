import 'package:flutter/material.dart';
import 'package:softshares/classes/ClasseAPI.dart';
import 'package:softshares/classes/user.dart';

class CheckAnswers extends StatefulWidget {
  CheckAnswers({super.key, required this.id});

  int id;

  @override
  State<CheckAnswers> createState() => _CheckAnswersState();
}

class _CheckAnswersState extends State<CheckAnswers> {
  API api = API();
  List<User> participants = [];

  Future getParticipants() async {
    var data = await api.getParticipants(widget.id);
    participants = data;
  }

  @override
  void initState() {
    super.initState();
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
        body: FutureBuilder(
          future: getParticipants(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return const Center(
                  child: Text('Something went wrong :(\n Try again'),
                );
              } else if (participants.isEmpty) {
                return const Center(
                  child: Text('No participants'),
                );
              }
              return ListView.builder(
                  itemCount: participants.length,
                  itemBuilder: (context, index) {
                    return Text(participants[index].firstname);
                  });
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ));
  }

}
