import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:softshares/classes/ClasseAPI.dart';
import 'package:softshares/classes/user.dart';

class Notices extends StatefulWidget {
  const Notices({super.key});

  @override
  State<Notices> createState() => _NoticesState();
}

class _NoticesState extends State<Notices> {
    API api = API();
  List<User> participants = [];
  var box = GetStorage();
  late Color bgColor;
  int aux = 3; //Tmp

  Future getNotices() async {
    //var data = await api.getNotices()
  }

  @override
  void initState() {
    super.initState();
    if(aux <= 2 && aux >= 1){
      bgColor = Colors.green;
    }else if(aux <= 4 && aux >= 3){
      bgColor = Colors.yellow;
    }else {
      bgColor = Colors.red;
    }
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
          future: getNotices(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                print(snapshot.error);
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
                      color: bgColor,
                      margin:  const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 16.0),
                      child: Padding(
                        padding:  const EdgeInsets.all(12.0),
                        child: Row(
                          children: [
                            Icon(Icons.report),
                            Column(
                              children: [
                                Text('Description here'),
                                Text('Admin here')
                              ],
                            ),
                          ],
                        )
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