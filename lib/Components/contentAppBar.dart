import 'package:flutter/material.dart';
import 'package:softshares/Pages/editPubs/editEvent.dart';
import 'package:softshares/Pages/editPubs/editForum.dart';
import 'package:softshares/Pages/editPubs/postEdit.dart';
import 'package:softshares/Pages/homepage.dart';
import 'package:softshares/classes/areaClass.dart';
import 'package:softshares/classes/event.dart';
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
                  switch (widget.pub) {
                    case Event _:
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EditEvent(
                                pub: widget.pub as Event, areas: widget.areas)),
                      );
                      break;
                    case Forum _:
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EditForum(
                                  pub: widget.pub as Forum,
                                  areas: widget.areas,
                                )),
                      );
                      break;
                    case Publication _:
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EditPost(
                                    post: widget.pub,
                                    areas: widget.areas,
                                  )));
                      break;
                  }
                },
                icon: const Icon(Icons.edit))
            : Container()
      ],
    );
  }
}
