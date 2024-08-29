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
    final colorScheme = Theme.of(context).colorScheme;
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
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 16.0),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor: colorScheme.primary,
                                  child: Text(
                                    participants[index]
                                        .firstname[0]
                                        .toUpperCase(),
                                    style:
                                        TextStyle(color: colorScheme.onPrimary),
                                  ),
                                ),
                                const SizedBox(width: 12.0),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${participants[index].firstname} ${participants[index].lastName}",
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: colorScheme.onSurface,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
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
