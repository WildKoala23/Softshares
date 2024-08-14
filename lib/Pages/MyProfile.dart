import 'package:flutter/material.dart';
import 'package:softshares/Components/bottomNavBar.dart';
import 'package:softshares/Components/drawer.dart';
import 'package:softshares/Pages/signIn.dart';
import 'package:softshares/classes/ClasseAPI.dart';
import 'package:softshares/classes/areaClass.dart';
import 'package:softshares/classes/db.dart';
import 'package:softshares/providers/auth_provider.dart';
import '../Components/appBar.dart';
import '../classes/user.dart';

class MyProfile extends StatefulWidget {
  MyProfile({super.key, required this.areas, required this.user});
  List<AreaClass> areas;
  User user;

  @override
  State<MyProfile> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyProfile> {
  SQLHelper bd = SQLHelper.instance;
  API api = API();

  void rightCallback(context) {
    Navigator.pushNamed(context, '/settings');
  }

  Future getPosts() async {
    var data = await api.getUserPosts();
    print(data);
  }

  @override
  void initState() {
    super.initState();
    getPosts();
  }

  void logOff() {
    showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: const Text('Log Off?'),
            content: const Text('Are you sure you want to log off?'),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel')),
              TextButton(
                  onPressed: () async {
                    await bd.removeUser(widget.user);
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SignIn()));
                  },
                  child: const Text('Log Off'))
            ],
          );
        });
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
              logOff();
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
          '${widget.user.firstname} ${widget.user.lastName}',
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
                    widget.user.lastName[0],
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
