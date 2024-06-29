import 'package:flutter/material.dart';
import 'package:softshares/Components/bottomNavBar.dart';
import 'package:softshares/Components/drawer.dart';
import 'package:softshares/classes/forums.dart';
import 'package:softshares/classes/user.dart';
import '../Components/appBar.dart';
import '../Components/forumCard.dart';

//Test dummies
User user1 = User('John', 'Doe', 'Software Engineer', 'San Francisco, CA',
    'john.doe@example.com', DateTime(1990, 5, 15), false);
User user2 = User('Jane', 'Smith', 'Product Manager', 'New York, NY',
    'jane.smith@example.com', DateTime(1985, 8, 25), true);
User user3 = User('Emily', 'Johnson', 'Designer', 'Los Angeles, CA',
    'emily.johnson@example.com', DateTime(1992, 11, 30), true);

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  final Color appBarColor = const Color(0xff80ADD7);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<ForumCard> testList = createTestForumCards();

  void leftCallback(context) {
    print('Notifications');
  }

  void rightCallback(context) {
    print('search');
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
      body: Center(
          child: ListView.builder(
        itemCount: testList.length,
        itemBuilder: (context, index) {
          return testList[index];
        },
      )),
      drawer: myDrawer(),
      bottomNavigationBar: const MyBottomBar(),
    );
  }
}

List<ForumCard> createTestForumCards() {
  List<ForumCard> cards = [];

  // Create multiple instances of Forum with different data
  Forum forum1 = Forum(
    user1,
    user3,
    'Discussion about new software trends',
    1,
    'Tech Talk',
    true,
    'Technology',
    'Software',
    DateTime.now()
  );

  // Create a new Forum instance
  Forum forum2 = Forum(
    user2,
    user3,
    'Discussion about sports events',
    1,
    'Sports Forum',
    true,
    'Sports',
    'Football',
    DateTime.now()
  );

  // Create ForumCard widgets with the Forum objects
  ForumCard card1 = ForumCard(forum: forum1);
  ForumCard card2 = ForumCard(forum: forum2);

  // Add the ForumCard widgets to the list
  cards.add(card1);
  cards.add(card2);

  return cards;
}
