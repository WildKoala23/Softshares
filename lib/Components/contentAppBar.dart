import 'package:flutter/material.dart';
import 'package:softshares/Pages/editPubs/editForum.dart';
import 'package:softshares/classes/areaClass.dart';
import 'package:softshares/classes/forums.dart';
import 'package:softshares/classes/publication.dart';
import 'package:share_plus/share_plus.dart';

class contentAppBar extends StatefulWidget implements PreferredSizeWidget {
  const contentAppBar({super.key, required this.pub, required this.areas});
  final Publication pub;
  final List<AreaClass> areas;
  @override
  State<contentAppBar> createState() => _contentAppBarState();
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _contentAppBarState extends State<contentAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: const Icon(Icons.close),
      ),
      title: Text(widget.pub.title),
      actions: [
        IconButton(
            onPressed: () {
              Share.share(
                  '_Check out this publication:_\n*${widget.pub.title}*\n ${widget.pub.desc}');
            },
            icon: const Icon(Icons.share)),
        widget.pub.validated == false
            ? IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EditForum(pub: widget.pub as Forum, areas: widget.areas,)),
                  );
                },
                icon: const Icon(Icons.edit))
            : Container()
      ],
    );
  }
}
