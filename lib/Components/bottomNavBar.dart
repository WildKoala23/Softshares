// ignore: file_names
import 'package:flutter/material.dart';

class MyBottomBar extends StatelessWidget {
  const MyBottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      fixedColor: Colors.black,
      showUnselectedLabels: true,
      showSelectedLabels: true,
      unselectedItemColor: Colors.black,
      items: [
        BottomNavigationBarItem(
          icon: IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/PointOfInterest');
            },
            icon: const Icon(Icons.pin_drop),
          ),
          label: 'POI',
        ),
        BottomNavigationBarItem(
          icon: IconButton(
            icon: const Icon(
              Icons.add,
            ),
            onPressed: () {
              Navigator.pushNamed(context, '/createForm');
            },
          ),
          label: 'Add',
        ),
        BottomNavigationBarItem(
          icon: IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/home');
            },
            icon: const Icon(Icons.home),
          ),
          label: 'Home',
        ),
      ],
    );
  }
}
