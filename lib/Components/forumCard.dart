import 'package:flutter/material.dart';
import 'package:softshares/Pages/classes/forums.dart';

class ForumCard extends StatefulWidget {
  const ForumCard({super.key, required this.forum});

  final Forum forum;

  @override
  State<ForumCard> createState() => _POIState();
}

class _POIState extends State<ForumCard> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Card(
      margin: EdgeInsets.fromLTRB(26, 26, 20, 0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(14.0, 20.0, 14.0, 20.0),
            child: cardHeader(colorScheme),
          ),
          //If image == null, put color instead
          widget.forum.getImage() == null
              ? Container(
                  height: 0,
                )
              : Image.network(
                  widget.forum.getImage()!,
                ),
          Padding(
            padding: const EdgeInsets.all(14.0),
            child: textContent(colorScheme),
          ),
          Padding(
            padding: const EdgeInsets.only(
                top: 20.0, bottom: 50.0, left: 14, right: 14),
            child: Container(
              alignment: Alignment.centerLeft,
              child: Text(
                widget.forum.getDescription(),
                textAlign: TextAlign.start,
              ),
            ),
          )
        ],
      ),
    );
  }

  Row textContent(ColorScheme colorScheme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.forum.getTitle(),
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              widget.forum.getSubCategory(),
              style: TextStyle(color: colorScheme.onTertiary, fontSize: 16),
            )
          ],
        ),
      ],
    );
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
                  child: widget.forum.profilePic != null
                      ? Text(
                          widget.forum.getFirstName()[0],
                          style: TextStyle(
                              fontSize: 20, color: colorScheme.onPrimary),
                        )
                      : const Text('PP')),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${widget.forum.getFirstName()} ${widget.forum.getLastName()}",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  widget.forum.getDepartment(),
                  style: TextStyle(fontWeight: FontWeight.w100, fontSize: 14),
                )
              ],
            ),
          ],
        ),
        const Icon(
          Icons.bookmark_add_outlined,
          size: 30,
        )
      ],
    );
  }
}
