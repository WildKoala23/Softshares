import 'package:flutter/material.dart';
import 'package:softshares/Components/bottomNavBar.dart';
import 'package:softshares/Components/drawer.dart';
import '../Components/appBar.dart';
import './classes/user.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({super.key});

  final Color appBarColor = const Color(0xff80ADD7);

  @override
  State<MyProfile> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyProfile> {
  //Placeholder User for testing
  User user = User('Guilherme', 'Pedrinho', 'Software Engineer', 'Viseu',
      "email@example.com", 23, 09, 2001);

  void rightCallback(context) {
    print('settings');
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
                labelColor: Colors.black,
                indicatorColor: colorScheme.secondary,
                splashFactory: NoSplash.splashFactory,
                tabs: [
                  Tab(
                    child: Text('My Posts'),
                  ),
                  Tab(
                    child: Text('Saved Posts'),
                  )
                ],
              ))
        ],
      ),
      drawer: myDrawer(
        location: 'Viseu',
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
              Navigator.pushNamed(context, '/Login');
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
          style: TextStyle(fontSize: 24, color: colorScheme.primary),
        ),
        const SizedBox(
          height: 5,
        ),
        Text(
          user.job,
          style: TextStyle(fontSize: 14, color: colorScheme.onTertiary),
        ),
        const SizedBox(
          height: 2,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.location_on_outlined,
              size: 14,
              color: colorScheme.onTertiary,
            ),
            Text(
              user.location,
              style: TextStyle(fontSize: 14, color: colorScheme.onTertiary),
            )
          ],
        )
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
