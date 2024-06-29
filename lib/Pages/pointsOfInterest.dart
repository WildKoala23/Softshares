import 'package:flutter/material.dart';
import 'package:softshares/Components/appBar.dart';
import 'package:softshares/Components/bottomNavBar.dart';
import 'package:softshares/Components/drawer.dart';
import 'package:softshares/classes/user.dart';
import '../Components/POICard.dart';
import '../classes/POI.dart';


User user1 = User('John', 'Doe', 'Software Engineer', 'San Francisco, CA',
    'john.doe@example.com', DateTime(1990, 5, 15), false);
User user2 = User('Jane', 'Smith', 'Product Manager', 'New York, NY',
    'jane.smith@example.com', DateTime(1985, 8, 25), true);
User user3 = User('Emily', 'Johnson', 'Designer', 'Los Angeles, CA',
    'emily.johnson@example.com', DateTime(1992, 11, 30), false);

class PointsOfInterest extends StatefulWidget {
  const PointsOfInterest({super.key});

  @override
  State<PointsOfInterest> createState() => _PointsOfInterestState();
}

class _PointsOfInterestState extends State<PointsOfInterest> {
  List<POICard> testPOICards = createTestPOICards();

  void rightCallback(context) {
    print('search');
  }

  void leftCallback(context) {
    print('Filter');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        iconL: const Icon(Icons.filter_alt_outlined),
        leftCallback: leftCallback,
        title: 'Points of Interest',
        iconR: const Icon(Icons.search),
        rightCallback: rightCallback,
      ),
      drawer: myDrawer(),
      body: Center(
          child: ListView.builder(
        itemCount: testPOICards.length,
        itemBuilder: (context, index) {
          return testPOICards[index];
        },
      )),
      bottomNavigationBar: const MyBottomBar(),
    );
  }
}

List<POICard> createTestPOICards() {
  List<POICard> cards = [];

  // Create multiple instances of POI with different data
    POI poi1 = POI(
    user1,
    user3,
    'Beautiful park with a lot of greenery',
    1,
    'Central Park',
    true,
    'Nature',
    'Parks',
    DateTime.now(),
    3,
    null
  );

  POI poi2 = POI(
    user3,
    user4,
    'Historic monument with a rich history',
    2,
    'Liberty Bell',
    true,
    'History',
    'Monuments',
    DateTime.now(),
    5,
    null
  );

  // Create POICard widgets with the POI objects
  POICard card1 = POICard(pointOfInterest: poi1);
  POICard card2 = POICard(pointOfInterest: poi2);

  // Add the POICard widgets to the list
  cards.add(card1);
  cards.add(card2);

  return cards;
}
