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
      body: Center(
        child: Column(
          children: [
            DefaultTabController(
                length: 3,
                child: TabBar(
                  labelColor: colorScheme.onSecondary,
                  indicatorColor: colorScheme.secondary,
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
