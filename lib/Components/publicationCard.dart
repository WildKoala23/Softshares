import 'package:flutter/material.dart';
import 'package:softshares/Pages/pubsPages/postsPage.dart';
import 'package:softshares/classes/publication.dart';

class PublicationCard extends StatefulWidget {
  const PublicationCard({super.key, required this.pub});

  final Publication pub;

  @override
  State<PublicationCard> createState() => _PubState();
}

class _PubState extends State<PublicationCard> {
  bool saved = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PostPage(publication: widget.pub),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.fromLTRB(26, 26, 20, 0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(14.0, 20.0, 14.0, 20.0),
              child: cardHeader(colorScheme),
            ),
            widget.pub.img == null
                ? Container(
                    color: Color.fromARGB(255, 150, 216, 255),
                    height: 120,
                  )
                : Container(
                    height: 120,
                    width: double
                        .infinity, // Ensures the image covers the full width
                    child: Image.network(
                      'https://backendpint-w3vz.onrender.com/uploads/${widget.pub.img!.path}',
                      fit: BoxFit.cover,
                      // Handles images not existing
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Color.fromARGB(255, 150, 216, 255),
                          height: 120,
                        );
                      },
                    ),
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
                  widget.pub.desc,
                  textAlign: TextAlign.start,
                ),
              ),
            )
          ],
        ),
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
              widget.pub.title,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              widget.pub.subAreaName,
              style: TextStyle(color: colorScheme.onTertiary, fontSize: 16),
            )
          ],
        ),
        widget.pub.price != null
            ? Row(
                children: List.generate(
                    widget.pub.price!,
                    (start) => Icon(
                          Icons.euro,
                          color: colorScheme.secondary,
                          size: 25,
                        )))
            : const SizedBox()
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
                  child: widget.pub.user.profileImg == null
                      ? Text(
                          widget.pub.user.firstname[0],
                          style: TextStyle(
                              fontSize: 20, color: colorScheme.onPrimary),
                        )
                      : const Text('I')),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${widget.pub.user.firstname} ${widget.pub.user.lastName}",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
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
