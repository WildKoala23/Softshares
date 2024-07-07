import 'package:flutter/material.dart';
import 'package:softshares/Components/bottomNavBar.dart';
import 'package:softshares/Components/drawer.dart';
import 'package:softshares/classes/areaClass.dart';
import '../Components/appBar.dart';
import '../classes/user.dart';

User user = User(1, 'John', 'Doe', 'john.doe@example.com');

class MyProfile extends StatefulWidget {
  MyProfile({super.key, required this.areas});
  List<AreaClass> areas;

  @override
  State<MyProfile> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyProfile> {
  //Placeholder User for testing

  void rightCallback(context) {
    Navigator.pushNamed(context, '/settings');
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: MyAppBar(
        iconR: const Icon(Icons.settings),
        rightCallback: rightCallback,
        title: 'Profile',
      ),
      body: Column(
        children: [
          profilePicture(colorScheme),
          const SizedBox(
            height: 10,
          ),
          userInfo(colorScheme),
          const SizedBox(
            height: 15,
          ),
          actionBtns(colorScheme),
          const SizedBox(
            height: 15,
          ),
          DefaultTabController(
              length: 2,
              child: TabBar(
                labelColor: colorScheme.onPrimary,
                indicatorColor: colorScheme.secondary,
                splashFactory: NoSplash.splashFactory,
                tabs: [
                  Tab(
                    child: Text(
                      'My Posts',
                      style: TextStyle(color: colorScheme.onSecondary),
                    ),
                  ),
                  Tab(
                    child: Text('Registered Events',
                        style: TextStyle(color: colorScheme.onSecondary)),
                  )
                ],
              ))
        ],
      ),
      drawer: myDrawer(
        areas: widget.areas,
      ),
      bottomNavigationBar: const MyBottomBar(),
    );
  }

  Row actionBtns(ColorScheme colorScheme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/Editprofile');
            },
            style: ButtonStyle(
                elevation: MaterialStateProperty.all(0),
                backgroundColor: MaterialStateProperty.all(Colors.transparent),
                foregroundColor:
                    MaterialStateProperty.all(colorScheme.secondary),
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(color: colorScheme.secondary)))),
            child: const Text('Edit Profile')),
        ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/SignIn');
            },
            style: ButtonStyle(
                elevation: MaterialStateProperty.all(0),
                backgroundColor: MaterialStateProperty.all(Colors.transparent),
                foregroundColor:
                    MaterialStateProperty.all(colorScheme.secondary),
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(color: colorScheme.secondary)))),
            child: const Text('Log off')),
      ],
    );
  }

  Column userInfo(ColorScheme colorScheme) {
    return Column(
      children: [
        Text(
          '${user.firstname} ${user.lastName}',
          style: TextStyle(fontSize: 24, color: colorScheme.secondary),
        ),
        const SizedBox(
          height: 5,
        ),
        const SizedBox(
          height: 2,
        ),
      ],
    );
  }

  Container profilePicture(ColorScheme colorScheme) {
    return Container(
      child: Center(
        child: Container(
          margin: const EdgeInsets.only(top: 30),
          height: 170,
          width: 170,
          decoration: BoxDecoration(
              border: Border.all(color: colorScheme.secondary, width: 3),
              borderRadius: BorderRadius.circular(95)),
          child: Center(
            child: Container(
                height: 150,
                width: 150,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(75),
                    color: colorScheme.secondary),
                child: Center(
                  child: Text(
                    user.lastName[0],
                    style:
                        TextStyle(fontSize: 54, color: colorScheme.onPrimary),
                  ),
                )),
          ),
        ),
      ),
    );
  }
}
