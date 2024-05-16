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
  User user = User('Guilherme', 'Pedrinho', 'Software Engineer', 'Viseu', "email@example.com", 23, 09, 2001);

  void rightCallback(context){
    print('settings');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        iconR: const Icon(Icons.settings),
        rightCallback: rightCallback,
        title: 'Profile',
      ),
      body: Column(
        children: [
          profilePicture(),
          const SizedBox(
            height: 10,
          ),
          userInfo(),
          const SizedBox(
            height: 15,
          ),
          actionBtns(),
          const SizedBox(
            height: 15,
          ),
          const DefaultTabController(
              length: 2,
              child: TabBar(
                labelColor: Colors.black,
                indicatorColor: Color(0xff00C2FF),
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

  Row actionBtns() {
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
                foregroundColor: MaterialStateProperty.all(Color(0xff00C2FF)),
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: const BorderSide(color: Color(0xff00C2FF))))),
            child: const Text('Edit Profile')),
        ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/Login');
            },
            style: ButtonStyle(
                elevation: MaterialStateProperty.all(0),
                backgroundColor: MaterialStateProperty.all(Colors.transparent),
                foregroundColor: MaterialStateProperty.all(Color(0xff00C2FF)),
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: const BorderSide(color: Color(0xff00C2FF))))),
            child: const Text('Log off')),
      ],
    );
  }

  Column userInfo() {
    return Column(
      children: [
        Text(
          '${user.firstname} ${user.lastName}',
          style: const TextStyle(fontSize: 24, color: Color(0xff80ADD7)),
        ),
        const SizedBox(
          height: 5,
        ),
        Text(
          user.job,
          style: const TextStyle(fontSize: 14, color: Color(0xff79747E)),
        ),
        const SizedBox(
          height: 2,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.location_on_outlined,
              size: 14,
              color: Color(0xff79747E),
            ),
            Text(
              user.location,
              style: const TextStyle(fontSize: 14, color: Color(0xff79747E)),
            )
          ],
        )
      ],
    );
  }

  Container profilePicture() {
    return Container(
      height: 220,
      decoration: const BoxDecoration(
          color: Color(0x4080ADD7),
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(110),
              bottomRight: Radius.circular(110))),
      child: Center(
        child: Container(
          margin: const EdgeInsets.only(top: 30),
          height: 170,
          width: 170,
          decoration: BoxDecoration(
              border: Border.all(color: Color(0xff00C2FF), width: 3),
              borderRadius: BorderRadius.circular(95)),
          child: Center(
            child: Container(
                height: 150,
                width: 150,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(75),
                    color: Color(0xff00C2FF)),
                child: Center(
                  child: Text(
                    user.lastName[0],
                    style: TextStyle(fontSize: 54, color: Colors.white),
                  ),
                )),
          ),
        ),
      ),
    );
  }
}
