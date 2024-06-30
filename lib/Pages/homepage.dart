import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:softshares/Components/bottomNavBar.dart';
import 'package:softshares/Components/drawer.dart';
import 'package:softshares/Components/publicationCard.dart';
import 'package:softshares/classes/POI.dart';
import 'package:softshares/classes/event.dart';
import 'package:softshares/classes/forums.dart';
import 'package:softshares/classes/publication.dart';
import 'package:softshares/classes/user.dart';
import '../Components/appBar.dart';
import '../Components/forumCard.dart';
import '../classes/ClasseAPI.dart';
import 'package:http/http.dart' as http;

//Test dummies
User user1 = User(1, 'John', 'Doe', 'john.doe@example.com');
User user2 = User(2, 'Jane', 'Smith', 'jane.smith@example.com');
User user3 = User(3, 'Emily', 'Johnson', 'emily.johnson@example.com');

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

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
                    case Event:
                      break;
                    case Publication:
                      return PublicationCard(pub: pub);
                    case POI:
                      break;
                    case Forum:
                      return ForumCard(forum: pub as Forum);
                  }
                }));
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      drawer: myDrawer(),
      bottomNavigationBar: const MyBottomBar(),
    );
  }
}

// List<ForumCard> createTestForumCards() {
//   List<ForumCard> cards = [];

//   // Create multiple instances of Forum with different data
//   Forum forum1 = Forum(user1, user3, 'Discussion about new software trends',
//       'Tech Talk', true, 'Technology', 'Software', DateTime.now(), );

//   // Create a new Forum instance
//   Forum forum2 = Forum(user2, user3, 'Discussion about sports events',
//       'Sports Forum', true, 'Sports', 'Football', DateTime.now(), );

//   // Create ForumCard widgets with the Forum objects
//   ForumCard card1 = ForumCard(forum: forum1);
//   ForumCard card2 = ForumCard(forum: forum2);

//   // Add the ForumCard widgets to the list
//   cards.add(card1);
//   cards.add(card2);

//   return cards;
// }


// ListView.builder(
//         itemCount: testList.length,
//         itemBuilder: (context, index) {
//           return testList[index];
//         },

// FutureBuilder(
//         future: getPosts(),
//         builder: (context, snapshot) {
//           if (snapshot.hasData) {
//             return (ListView.builder(
//               itemCount: testList.length,
//               itemBuilder: (context, index) {
//                 return testList[index];
//               },
//             ));
//           } else {
//             return const Center(
//               child: CircularProgressIndicator(),
//             );
//           }
//         },
//       )


// Center(
//           child: ListView.builder(
//         itemCount: testList.length,
//         itemBuilder: (context, index) {
//           return testList[index];
//         },
//       )