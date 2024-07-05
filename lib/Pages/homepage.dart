import 'package:flutter/material.dart';
import 'package:softshares/Components/bottomNavBar.dart';
import 'package:softshares/Components/drawer.dart';
import 'package:softshares/Components/eventCard.dart';
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
  final ScrollController _scrollController =
      ScrollController(); // Scroll controller
  late Future<void> futurePosts;

  Future<void> getPosts() async {
    var data = await api.getAllPosts();
    posts = data;
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
    futurePosts = getPosts();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == 0) {
        getPosts();
      }
    });
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
        future: futurePosts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            print(snapshot);
            if (snapshot.hasError) {
              return (Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.cloud_off),
                    const Text(
                        'Failed connection to server. Please check your connection'),
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                        onPressed: () async {
                          setState(() {
                            futurePosts = getPosts();
                          });
                        },
                        child: const Text('Try again'))
                  ],
                ),
              ));
            }
            return RefreshIndicator(
              onRefresh: getPosts,
              child: (ListView.builder(
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    final pub = posts[index];
                    switch (pub) {
                      case Event _:
                        return EventCard(event: pub);
                      case Forum _:
                        return ForumCard(forum: pub);
                      case Publication _:
                        return PublicationCard(pub: pub);
                    }
                  })),
            );
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
