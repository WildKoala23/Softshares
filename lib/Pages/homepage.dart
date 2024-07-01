import 'package:flutter/material.dart';
import 'package:softshares/Components/bottomNavBar.dart';
import 'package:softshares/Components/drawer.dart';
import 'package:softshares/Components/publicationCard.dart';
import 'package:softshares/Pages/createPub.dart';
import 'package:softshares/classes/POI.dart';
import 'package:softshares/classes/event.dart';
import 'package:softshares/classes/forums.dart';
import 'package:softshares/classes/publication.dart';
import 'package:softshares/classes/user.dart';
import '../Components/appBar.dart';
import '../Components/forumCard.dart';
import '../classes/ClasseAPI.dart';
import '../classes/areaClass.dart';

//Test dummies
User user1 = User(1, 'John', 'Doe', 'john.doe@example.com');
User user2 = User(2, 'Jane', 'Smith', 'jane.smith@example.com');
User user3 = User(3, 'Emily', 'Johnson', 'emily.johnson@example.com');

class MyHomePage extends StatefulWidget {
  MyHomePage({super.key, required this.areas});
  List<AreaClass> areas;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Publication> posts = [];
  final API api = API();

  Future<void> getPosts() async {
    posts = await api.getAllPosts();
  }

  void leftCallback(context) {
    print('Notifications');
  }

  void rightCallback(context) {
    print('search');
  }

  @override
  void initState() {
    super.initState();
    getPosts();
    print(posts.length);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        iconL: const Icon(Icons.notifications),
        leftCallback: leftCallback,
        iconR: const Icon(Icons.search),
        rightCallback: rightCallback,
        title: 'Homepage',
      ), //homeAppBar(),
      body: FutureBuilder(
        future: getPosts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return (ListView.builder(
                itemCount: posts.length,
                itemBuilder: (context, index) {
                  final pub = posts[index];
                  switch (pub.runtimeType) {
                    case Event _:
                      break;
                    case POI _:
                      break;
                    case Forum _:
                      return ForumCard(forum: pub as Forum);
                    default:
                      return PublicationCard(pub: pub);
                  }
                }));
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      drawer: myDrawer(
        areas: widget.areas,
      ),
      bottomNavigationBar: const MyBottomBar(),
    );
  }
}
