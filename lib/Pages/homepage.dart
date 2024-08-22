import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:softshares/Components/bottomNavBar.dart';
import 'package:softshares/Components/drawer.dart';
import 'package:softshares/Components/eventCard.dart';
import 'package:softshares/Components/publicationCard.dart';
import 'package:softshares/classes/event.dart';
import 'package:softshares/classes/forums.dart';
import 'package:softshares/classes/publication.dart';
import 'package:softshares/classes/user.dart';
import '../Components/appBar.dart';
import '../Components/forumCard.dart';
import '../classes/ClasseAPI.dart';
import '../classes/areaClass.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({super.key, required this.areas});
  List<AreaClass> areas;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //firebase
  late FirebaseMessaging messaging;
  String message = "No notifications";

  List<Publication> posts = [];
  final API api = API();
  final ScrollController _scrollController = ScrollController();
  //Variable to store future function
  late Future<void> futurePosts;
  final box = GetStorage();

  //Fetch posts from server
  Future<void> getPosts() async {
    //print('aaaaaaaaaa');
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
    print(box.read('selectedCity'));
    super.initState();
    futurePosts = getPosts();
    _scrollController.addListener(() {
      //If user tries to scroll up when on top of lastest post
      //try to refresh posts
      if (_scrollController.position.pixels == 0) {
        getPosts();
      }
    });
    // messaging = FirebaseMessaging.instance;
    // // Get the token
    // messaging.getToken().then((token) {
    //   print("FCM Token: $token");
    //   // Send the token to your server and store it in your database
    //   if (token != null) {
    //     api.sendTokenToServer(token);
    //   }
    // });

    // FirebaseMessaging.onMessage.listen((RemoteMessage event) {
    //   print("message received");
    //   print(event.notification?.body);
    //   setState(() {
    //     message = event.notification?.body ?? "No Message";
    //   });
    // });

    // FirebaseMessaging.onMessageOpenedApp.listen((message) {
    //   print('Message clicked!');
    // });
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
      ),
      body: FutureBuilder(
        future: futurePosts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            //Handles fetching posts errors
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
                        return EventCard(event: pub, areas: widget.areas);
                      case Forum _:
                        return ForumCard(forum: pub, areas: widget.areas);
                      case Publication _:
                        return PublicationCard(pub: pub, areas: widget.areas);
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
