import 'package:flutter/material.dart';
import 'package:softshares/Components/appBar.dart';
import 'package:softshares/Components/bottomNavBar.dart';
import 'package:softshares/Components/drawer.dart';
import 'package:softshares/Components/eventCard.dart';
import 'package:softshares/Components/forumCard.dart';
import 'package:softshares/Components/publicationCard.dart';
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
  State<Area> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<Area> {
  List<Publication> pubs = [];
  final API api = API();
  String type = 'forums';

  Future getPubs(String type) async {
    pubs = [];
    //Get specific area
    AreaClass area =
        widget.areas.firstWhere((area) => area.areaName == widget.title);
    //Get type of publications from specific area
    var data = await api.getAllPubsByArea(area.id, type);
    pubs = data;
    print(pubs.length);
  }

  @override
  void initState() {
    super.initState();
    getPubs(type);
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
    });
  }

  void leftCallback(context) {
    print('Filter');
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
        length: 3, // Make sure this matches the number of tabs
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
      future: getPubs(type),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          return ListView.builder(
            itemCount: pubs.length,
            itemBuilder: (context, index) {
              return ForumCard(forum: pubs[index] as Forum);
            },
          );
        }
      },
    );
  }

  FutureBuilder<dynamic> eventContent() {
    return FutureBuilder(
      future: getPubs(type),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          return ListView.builder(
            itemCount: pubs.length,
            itemBuilder: (context, index) {
              return EventCard(event: pubs[index] as Event);
            },
          );
        }
      },
    );
  }

  FutureBuilder<dynamic> postContent() {
    return FutureBuilder(
      future: getPubs(type),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          return ListView.builder(
            itemCount: pubs.length,
            itemBuilder: (context, index) {
              return PublicationCard(pub: pubs[index]);
            },
          );
        }
      },
    );
  }
}
