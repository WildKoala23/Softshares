import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:softshares/Components/formAppBar.dart';
import 'package:softshares/classes/publication.dart';

class PostPage extends StatefulWidget {
  const PostPage({super.key, required this.publication});

  final Publication publication;

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
        appBar: formAppbar(title: widget.publication.title),
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
                widget.publication.title,
                style: const TextStyle(fontSize: 26),
              ),
              widget.publication.img == null
                  ? Container()
                  : Image.network(
                      'https://backendpint-w3vz.onrender.com/uploads/${widget.publication.img!.path}',
                      //Handles images not existing
                      errorBuilder: (context, error, stackTrace) {
                      return Container();
                    }),
              Container(
                child: Text(widget.publication.desc),
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
                  child: widget.publication.user.profileImg == null
                      ? Text(
                          widget.publication.user.firstname[0],
                          style: TextStyle(
                              fontSize: 20, color: colorScheme.onPrimary),
                        )
                      : const Text('I')),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${widget.publication.user.firstname} ${widget.publication.user.lastName}",
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
