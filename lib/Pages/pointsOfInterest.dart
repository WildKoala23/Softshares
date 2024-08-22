import 'package:flutter/material.dart';
import 'package:softshares/Components/appBar.dart';
import 'package:softshares/Components/bottomNavBar.dart';
import 'package:softshares/Components/drawer.dart';
import 'package:softshares/Pages/filterPOIPage.dart';
import 'package:softshares/classes/ClasseAPI.dart';
import 'package:softshares/classes/areaClass.dart';
import 'package:softshares/classes/publication.dart';
import '../Components/POICard.dart';

class PointsOfInterest extends StatefulWidget {
  PointsOfInterest({super.key, required this.areas});
  List<AreaClass> areas;
  @override
  State<PointsOfInterest> createState() => _PointsOfInterestState();
}

class _PointsOfInterestState extends State<PointsOfInterest> {
  List<Publication> listPoi = [];
  final API api = API();
  bool failedLoading = false;
  late Future futurePosts;
  Map<String, dynamic> filters = {};

  Future<void> getPubs(Map<String, dynamic> filters) async {
    listPoi = [];
    print('Filters: $filters');

    // Get type of publications from specific area
    var data = await api.getAllPoI();

    if (filters.isNotEmpty) {
      // Initialize a set to track seen publications and avoid duplicates
      Set<Publication> seenPubs = {};

      // Filter by rating
      if (filters.containsKey('rating') && filters['rating'] != null) {
        var filterRatings = filters['rating'] as List<dynamic>;
        filterRatings =
            filterRatings.map((rating) => rating.toString()).toList();

        // Use a temporary set to filter by rating
        Set<Publication> tempPubs = {};
        seenPubs.forEach((pub) {
          if (pub.aval != null &&
              filterRatings.contains(pub.aval!.toInt().toString())) {
            tempPubs.add(pub);
          }
        });

        // Update seenPubs with filtered results by rating
        seenPubs = tempPubs;
      }

      // Convert the set to a list for final output

      listPoi = seenPubs.toList();
    } else {
      listPoi = data;
    }
  }

  void rightCallback(context) {
    print('search');
  }

  void leftCallback(context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FilterPoiPage(
          filters: filters,
        ),
      ),
    );

    if (result != null && result is Map<String, dynamic>) {
      print('Received filters: $result');

      if (result.entries.isNotEmpty) {
        filters['rating'] = result['rating'];
        filters['price'] = result['price'];
      } else {
        filters = {};
      }

      setState(() {
        getPubs(filters);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    futurePosts = getPubs(filters);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        iconL: const Icon(Icons.filter_alt),
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
                            futurePosts = getPubs(filters);
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
