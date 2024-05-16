import 'package:flutter/material.dart';

class formAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const formAppbar({Key? key, required this.title}) : super(key: key);

  static const Color containerColor = Color(0xFFFEF7FF);
  static const Color appBarColor = Color(0xFF80ADD7);
  static const Color appBarFont = Color(0xFFFFFFFF);
  static const Color mainColor = Color(0xFF80ADD7);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: appBarColor,
      foregroundColor: appBarFont,
      leading: IconButton(
        icon: const Icon(Icons.close),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      title: Text(title),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
