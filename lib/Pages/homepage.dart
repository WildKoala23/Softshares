import 'package:flutter/material.dart';
import 'package:softshares/Components/bottomNavBar.dart';
import 'package:softshares/Components/drawer.dart';
import 'package:softshares/Pages/classes/forums.dart';
import '../Components/appBar.dart';
import '../Components/forumCard.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  final Color appBarColor = const Color(0xff80ADD7);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<ForumCard> testList = createTestForumCards();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        iconL: const Icon(Icons.notifications),
        iconR: const Icon(Icons.search),
        title: 'Homepage',
      ), //homeAppBar(),
      body: Center(
          child: ListView.builder(
        itemCount: testList.length,
        itemBuilder: (context, index) {
          return testList[index];
        },
      )),
      drawer: myDrawer(
        location: 'Viseu',
      ),
      bottomNavigationBar: const MyBottomBar(),
    );
  }
}

List<ForumCard> createTestForumCards() {
  List<ForumCard> cards = [];

  // Create multiple instances of Forum with different data
  Forum forum1 = Forum(
    "John",
    "Doe",
    "Title 1",
    "Department 1",
    "SubCategory 1",
    "Description 1",
    "profilePic1",
    "https://img.freepik.com/free-photo/colorful-design-with-spiral-design_188544-9588.jpg?size=626&ext=jpg&ga=GA1.1.553209589.1715126400&semt=sph",
  );

  Forum forum2 = Forum(
    "Peter",
    "Parker",
    "Title 2",
    "Department 2",
    "SubCategory 2",
    "Description 2",
    "profilePic2",
    null,
  );

  // Create ForumCard widgets with the Forum objects
  ForumCard card1 = ForumCard(forum: forum1);
  ForumCard card2 = ForumCard(forum: forum2);

  // Add the ForumCard widgets to the list
  cards.add(card1);
  cards.add(card2);

  return cards;
}
