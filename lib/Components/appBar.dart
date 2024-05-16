import 'package:flutter/material.dart';

//********************************************************************//
//* To call this widget, it's necessary to pass 2 icons and 1 string *//
//********************************************************************//

// ignore: must_be_immutable
class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  Icon? iconR, iconL;
  String title;

  MyAppBar({super.key, required this.iconR, required this.title, this.iconL});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).primaryColor,
      foregroundColor: Colors.white,
      title: Text(title),
      actions: [
        //If Right icon exists, create button
        if (iconL != null) IconButton(onPressed: () {}, icon: iconL!),
        IconButton(onPressed: () {}, icon: iconR!)
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
