import 'package:flutter/material.dart';
import 'package:softshares/Components/formAppBar.dart';
import 'package:softshares/classes/forums.dart';

class ForumPage extends StatefulWidget {
  const ForumPage({super.key, required this.forum});

  final Forum forum;

  @override
  State<ForumPage> createState() => _PostPageState();
}

class _PostPageState extends State<ForumPage> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
        appBar: formAppbar(title: widget.forum.title),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              cardHeader(colorScheme),
              const SizedBox(
                height: 20,
              ),
              Text(
                widget.forum.title,
                style: const TextStyle(fontSize: 26),
              ),
              Container(
                child: Text(widget.forum.desc),
              ),
              const SizedBox(
                height: 50,
              ),
              const Divider(
                height: 0,
                thickness: 2,
                indent: 25,
                endIndent: 25,
              ),
            ]),
          ),
        ));
  }

  Row cardHeader(ColorScheme colorScheme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              margin: const EdgeInsets.only(right: 6.0),
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                  color: colorScheme.secondary,
                  border: Border.all(width: 3, color: Colors.transparent),
                  borderRadius: BorderRadius.circular(95)),
              child: Center(
                  //If user does not have Profile Pic, print first letter of first name
                  child: widget.forum.user.profileImg == null
                      ? Text(
                          widget.forum.user.firstname[0],
                          style: TextStyle(
                              fontSize: 20, color: colorScheme.onPrimary),
                        )
                      : const Text('I')),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${widget.forum.user.firstname} ${widget.forum.user.lastName}",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
