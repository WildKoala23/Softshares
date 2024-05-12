import 'package:flutter/material.dart';
import 'package:softshares/Components/appBar.dart';
import 'package:softshares/Components/bottomNavBar.dart';
import 'package:softshares/Components/drawer.dart';

class Area extends StatefulWidget {
  final String title;
  const Area({super.key, required this.title});

  @override
  State<Area> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<Area> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        iconR: const Icon(Icons.search),
        title: widget.title,
        iconL: const Icon(Icons.filter_alt),
      ),
      body: const Center(
        child: Column(
          children: [
            DefaultTabController(
                length: 3,
                child: TabBar(
                  labelColor: Colors.black,
                  indicatorColor: Color(0xff00C2FF),
                  splashFactory: NoSplash.splashFactory,
                  tabs: [
                    Tab(
                      child: Text('Foruns'),
                    ),
                    Tab(
                      child: Text('Events'),
                    ),
                    Tab(
                      child: Text('Albuns'),
                    )
                  ],
                )),
          ],
        ),
      ),
      drawer: myDrawer(
        location: 'Viseu',
      ),
      bottomNavigationBar: const MyBottomBar(),
    );
  }
}
