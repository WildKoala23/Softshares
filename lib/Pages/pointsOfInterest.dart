import 'package:flutter/material.dart';
import 'package:softshares/Components/appBar.dart';
import 'package:softshares/Components/bottomNavBar.dart';
import 'package:softshares/Components/drawer.dart';
import 'package:softshares/classes/ClasseAPI.dart';
import 'package:softshares/classes/areaClass.dart';
import 'package:softshares/classes/user.dart';
import '../Components/POICard.dart';
import '../classes/POI.dart';

User user1 = User(1, 'John', 'Doe', 'john.doe@example.com');

class PointsOfInterest extends StatefulWidget {
  PointsOfInterest({super.key, required this.areas});
  List<AreaClass> areas;
  @override
  State<PointsOfInterest> createState() => _PointsOfInterestState();
}

class _PointsOfInterestState extends State<PointsOfInterest> {
  List<POI> listPoi = [];
  final API api = API();

  void rightCallback(context) {
    print('search');
  }

  void leftCallback(context) {
    print('Filter');
  }

  Future<void> getPoI() async {
    listPoi = await api.getAllPoI();
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
      drawer: myDrawer(areas: widget.areas,),
      body: FutureBuilder(
        future: getPoI(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return (ListView.builder(
                itemCount: listPoi.length,
                itemBuilder: (contex, index) {
                  return (POICard(pointOfInterest: listPoi[index]));
                }));
          } else {
            return (const Center(
              child: CircularProgressIndicator(),
            ));
          }
        },
      ),
      bottomNavigationBar: const MyBottomBar(),
    );
  }
}
