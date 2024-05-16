import 'package:flutter/material.dart';
import 'package:softshares/Components/appBar.dart';
import 'package:softshares/Components/bottomNavBar.dart';
import 'package:softshares/Components/drawer.dart';
import '../Components/POICard.dart';
import 'classes/POI.dart';

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
      drawer: myDrawer(location: 'Viseu'),
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
    "John",
    "Doe",
    "Title 1",
    "Department 1",
    "SubCategory 1",
    "Description 1",
    3, // Aval
    "profilePic1",
    null,
  );

  POI poi2 = POI(
    "Peter",
    "Parker",
    "Title 2",
    "Department 2",
    "SubCategory 2",
    "Description 2",
    5, // Aval
    "profilePic2",
    null,
  );

  // Create POICard widgets with the POI objects
  POICard card1 = POICard(pointOfInterest: poi1);
  POICard card2 = POICard(pointOfInterest: poi2);

  // Add the POICard widgets to the list
  cards.add(card1);
  cards.add(card2);

  return cards;
}
