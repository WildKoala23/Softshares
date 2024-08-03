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
  bool failedLoading = false;
  late Future futurePosts;
  List<int> filter = [];

  void rightCallback(context) {
    print('search');
  }

  void leftCallback(context) {
    print('Filter');
  }

  Future getPoI() async {
    try {
      listPoi = await api.getAllPoI();
      return true;
    } catch (e) {
      throw e;
    }
  }

  @override
  void initState() {
    super.initState();
    futurePosts = getPoI();
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
      drawer: myDrawer(
        areas: widget.areas,
      ),
      body: FutureBuilder(
        future: futurePosts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              print('OOHO :(');
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
                            futurePosts = getPoI();
                          });
                        },
                        child: const Text('Try Again'))
                  ],
                ),
              ));
            } else if (listPoi.isEmpty) {
              return (const Center(
                child: Text('No posts found'),
              ));
            }
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
