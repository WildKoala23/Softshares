import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:softshares/Components/formAppBar.dart';
import 'package:softshares/classes/ClasseAPI.dart';
import 'package:softshares/classes/publication.dart';
import 'package:softshares/classes/user.dart';

class PostPage extends StatefulWidget {
  const PostPage({super.key, required this.publication});

  final Publication publication;

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  API api = API();
  TextEditingController commentCx = TextEditingController();
  final _commentKey = GlobalKey<FormState>();
  Map<User, String> comments = {};

  Future<void> getComments() async {
    comments = await api.getComents(widget.publication);
    setState(() {}); // Ensure the UI updates after fetching comments
  }

  @override
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: formAppbar(title: widget.publication.title),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    cardHeader(colorScheme),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 5.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          widget.publication.title,
                          style: TextStyle(fontSize: 22),
                        ),
                      ),
                    ),
                    widget.publication.img != null
                        ? Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: Container(
                              width: double.infinity,
                              height: 250,
                              child: ClipRRect(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                                child: Image.network(
                                    fit: BoxFit.cover,
                                    'https://backendpint-w3vz.onrender.com/uploads/${widget.publication.img!.path}',
                                    //Handles images not existing
                                    errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    color: Color.fromARGB(255, 159, 255, 150),
                                  );
                                }),
                              ),
                            ),
                          )
                        : Container(),
                    Padding(
                      padding: const EdgeInsets.only(top: 28.0, bottom: 8.0),
                      child: Container(
                        width: double.infinity,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Flexible(
                              child: Text(widget.publication
                                  .desc), // Used Flexible to wrap text
                            ),
                            Column(
                              children: [],
                            )
                          ],
                        ),
                      ),
                    ),
                    const Divider(
                      color: Colors.black,
                      height: 30,
                      thickness: 2,
                      indent: 10,
                      endIndent: 10,
                    ),
                    comments.isEmpty
                        ? const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Icon(
                                  Icons.sentiment_dissatisfied,
                                  size: 50,
                                ),
                                Text(
                                  'So empty',
                                  style: TextStyle(fontSize: 24),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: comments.length,
                            itemBuilder: (context, index) {
                              User user = comments.keys.elementAt(index);
                              String comment = comments[user]!;
                              return ListTile(
                                leading: commentCircle(colorScheme),
                                title: Text(
                                  "${user.firstname} ${user.lastName}",
                                  style: TextStyle(fontSize: 22),
                                ),
                                subtitle: Text(comment),
                              );
                            },
                          ),
                  ],
                ),
              ),
            ),
            Form(
              key: _commentKey,
              child: TextFormField(
                textCapitalization: TextCapitalization.sentences,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter comment';
                  }
                  return null;
                },
                controller: commentCx,
                decoration: InputDecoration(
                  label: const Text('Add comment'),
                  suffixIcon: IconButton(
                    onPressed: () async {
                      if (_commentKey.currentState!.validate()) {
                        await api.createComment(
                            widget.publication, commentCx.text);
                        commentCx.clear();
                        await getComments();
                      }
                    },
                    icon: const Icon(Icons.send),
                  ),
                  border: const OutlineInputBorder(borderSide: BorderSide()),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container commentCircle(ColorScheme colorScheme) {
    return Container(
      margin: const EdgeInsets.only(right: 6.0),
      height: 40,
      width: 40,
      decoration: BoxDecoration(
        color: colorScheme.secondary,
        border: Border.all(width: 3, color: Colors.transparent),
        borderRadius: BorderRadius.circular(95),
      ),
      child: Center(
        // If user does not have Profile Pic, print first letter of first name
        child: widget.publication.user.profileImg == null
            ? Text(
                widget.publication.user.firstname[0],
                style: TextStyle(fontSize: 20, color: colorScheme.onPrimary),
              )
            : const Text('I'),
      ),
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
