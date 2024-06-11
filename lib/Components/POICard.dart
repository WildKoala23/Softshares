import 'package:flutter/material.dart';
import 'package:softshares/Pages/classes/POI.dart';

class POICard extends StatefulWidget {
  const POICard({super.key, required this.pointOfInterest});

  final POI pointOfInterest;

  @override
  State<POICard> createState() => _POIState();
}

class _POIState extends State<POICard> {
  bool saved = false;

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
          widget.pointOfInterest.getImage() == null
              ? Container(
                  color: Color.fromARGB(255, 150, 216, 255),
                  height: 120,
                )
              : Image.asset(widget.pointOfInterest.getImage()!),
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
                widget.pointOfInterest.getDescription(),
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
              widget.pointOfInterest.getTitle(),
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              widget.pointOfInterest.getSubCategory(),
              style: TextStyle(color: colorScheme.onTertiary, fontSize: 16),
            )
          ],
        ),
        Row(
            children: List.generate(
                widget.pointOfInterest.getAval(),
                (start) => Icon(
                      Icons.star,
                      color: colorScheme.secondary,
                      size: 25,
                    )))
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
                  child: widget.pointOfInterest.profilePic != null
                      ? Text(
                          widget.pointOfInterest.getFirstName()[0],
                          style: TextStyle(
                              fontSize: 20, color: colorScheme.onPrimary),
                        )
                      : const Text('I')),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${widget.pointOfInterest.getFirstName()} ${widget.pointOfInterest.getLastName()}",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  widget.pointOfInterest.getDepartment(),
                  style: TextStyle(fontWeight: FontWeight.w100, fontSize: 14),
                )
              ],
            ),
          ],
        ),
        !saved
            ? IconButton(
                icon: Icon(
                  Icons.bookmark_add_outlined,
                  size: 30,
                ),
                onPressed: () {
                  setState(() {
                    saved = true;
                  });
                },
              )
            : IconButton(
                icon: Icon(
                  Icons.bookmark,
                  size: 30,
                ),
                onPressed: () {
                  setState(() {
                    saved = false;
                  });
                },
              )
      ],
    );
  }
}
