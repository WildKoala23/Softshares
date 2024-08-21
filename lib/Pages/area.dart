import 'package:flutter/material.dart';
import 'package:softshares/Components/appBar.dart';
import 'package:softshares/Components/bottomNavBar.dart';
import 'package:softshares/Components/drawer.dart';
import 'package:softshares/Components/eventCard.dart';
import 'package:softshares/Components/forumCard.dart';
import 'package:softshares/Components/publicationCard.dart';
import 'package:softshares/Pages/filterPage.dart';
import 'package:softshares/classes/ClasseAPI.dart';
import 'package:softshares/classes/areaClass.dart';
import 'package:softshares/classes/event.dart';
import 'package:softshares/classes/forums.dart';
import 'package:softshares/classes/publication.dart';

// ignore: must_be_immutable
class Area extends StatefulWidget {
  final String title;
  List<AreaClass> areas;
  Area({super.key, required this.title, required this.areas});

  @override
  State<Area> createState() => _MyAreaState();
}

class _MyAreaState extends State<Area> {
  List<Publication> allPubs = [];
  final API api = API();
  String type = 'forums';
  int? price, aval;

  Future<void> getPubs(String type, int? price, int? aval) async {
    allPubs = [];
    // Get specific area
    AreaClass area =
        widget.areas.firstWhere((area) => area.areaName == widget.title);
    // Get type of publications from specific area
    var data = await api.getAllPubsByArea(area.id, type);

    // Filter based on provided filters
    if(type != 'events'){
      allPubs = data.where((pub) {
      bool matchesPrice = price == null || pub.price == price;
      bool matchesAval = aval == null || pub.aval == aval;
      return matchesPrice && matchesAval;
    }).toList();
    }
  }

  @override
  void initState() {
    super.initState();
    getPubs(type, price, aval);
  }

  void _onTabChanged(int index) {
    setState(() {
      switch (index) {
        case 0:
          type = 'forums';
          break;
        case 1:
          type = 'events';
          break;
        case 2:
          type = 'posts';
          break;
      }
      getPubs(type, price, aval); // Fetch data when tab changes
    });
  }

  void leftCallback(context) {
     Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FilterPage(),
          ),
        );
  }

  void rigthCallBack(context) {
    print('search');
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: MyAppBar(
        iconR: const Icon(Icons.search),
        leftCallback: leftCallback,
        rightCallback: rigthCallBack,
        title: widget.title,
        iconL: const Icon(Icons.filter_alt),
      ),
      body: DefaultTabController(
        length: 3,
        child: Column(
          children: [
            TabBar(
              labelColor: colorScheme.onSecondary,
              indicatorColor: colorScheme.secondary,
              splashFactory: NoSplash.splashFactory,
              tabs: const [
                Tab(
                  child: Text('Forums'),
                ),
                Tab(
                  child: Text('Events'),
                ),
                Tab(
                  child: Text('Posts'),
                ),
              ],
              onTap: _onTabChanged,
            ),
            Expanded(
              child: TabBarView(
                children: [
                  forumsContent(),
                  eventContent(),
                  postContent(),
                ],
              ),
            ),
          ],
        ),
      ),
      drawer: myDrawer(
        areas: widget.areas,
      ),
      bottomNavigationBar: const MyBottomBar(),
    );
  }

  FutureBuilder<dynamic> forumsContent() {
    return FutureBuilder(
      future: getPubs(type, price, aval),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else {
          if (allPubs.isEmpty) {
            return const Center(
              child: Text(
                'No posts found',
                style: TextStyle(fontSize: 18),
              ),
            );
          } else {
            return ListView.builder(
              itemCount: allPubs.length,
              itemBuilder: (context, index) {
                return ForumCard(forum: allPubs[index] as Forum);
              },
            );
          }
        }
      },
    );
  }

  FutureBuilder<dynamic> eventContent() {
    return FutureBuilder(
      future: getPubs(type, price, aval),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else {
          if (allPubs.isEmpty) {
            return const Center(
              child: Text(
                'No posts found',
                style: TextStyle(fontSize: 18),
              ),
            );
          } else {
            return ListView.builder(
              itemCount: allPubs.length,
              itemBuilder: (context, index) {
                return EventCard(event: allPubs[index] as Event);
              },
            );
          }
        }
      },
    );
  }

  FutureBuilder<dynamic> postContent() {
    return FutureBuilder(
      future: getPubs(type, price, aval),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else {
          if (allPubs.isEmpty) {
            return const Center(
              child: Text(
                'No posts found',
                style: TextStyle(fontSize: 18),
              ),
            );
          } else {
            return ListView.builder(
              itemCount: allPubs.length,
              itemBuilder: (context, index) {
                return PublicationCard(pub: allPubs[index]);
              },
            );
          }
        }
      },
    );
  }
}
