import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:softshares/Components/comments.dart';
import 'package:softshares/Components/contentAppBar.dart';
import 'package:softshares/Components/formAppBar.dart';
import 'package:softshares/classes/ClasseAPI.dart';
import 'package:softshares/classes/areaClass.dart';
import 'package:softshares/classes/commentClass.dart';
import 'package:softshares/classes/publication.dart';
import 'package:softshares/classes/user.dart';

class PostPage extends StatefulWidget {
  PostPage({super.key, required this.publication, required this.areas});

  final Publication publication;
  List<AreaClass> areas;

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  API api = API();
  TextEditingController commentCx = TextEditingController();
  final _commentKey = GlobalKey<FormState>();
  List<Comment> comments = [];
  int _charCount = 0;
  final int _charLimit = 500;
  List<int> likedComments = [];

  Future<void> getComments() async {
    comments = await api.getComents(widget.publication);
    setState(() {});
  }

  Future<void> getLikes() async {
    var data = await api.getComentsLikes(widget.publication);
    likedComments = data;
  }

  @override
  void initState() {
    super.initState();
    getComments();
    commentCx.addListener(_updateCharCount);
    print('Price: ${widget.publication.price}');
    getLikes();
  }

  void _updateCharCount() {
    setState(() {
      _charCount = commentCx.text.length;
    });
  }

  @override
  void dispose() {
    super.dispose();
    commentCx.dispose();
  }

  @override
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: contentAppBar(
        pub: widget.publication,
        areas: widget.areas,
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                    Text(
                      widget.publication.desc,
                      style: TextStyle(fontSize: 18),
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
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: comments.length,
                            itemBuilder: (context, index) {
                              bool liked =
                                  likedComments.contains(comments[index].id);
                              return CommentWidget(
                                liked: liked,
                                comment: comments[index],
                              );
                            },

                            // shrinkWrap: true,
                            // physics: NeverScrollableScrollPhysics(),
                            // itemCount: comments.length,
                            // itemBuilder: (context, index) {
                            //   User user = comments.keys.elementAt(index);
                            //   String comment = comments[user]!;
                            //   return ListTile(

                            //     leading: commentCircle(colorScheme),
                            //     title: Text(
                            //       "${user.firstname} ${user.lastName}",
                            //       style: const TextStyle(fontSize: 22),
                            //     ),
                            //     subtitle: Row(
                            //       children: [
                            //         IconButton(
                            //           icon: const Icon(Icons.thumb_up_alt),
                            //           onPressed: () {},
                            //         ),
                            //         Expanded(child: Text(comment)),
                            //       ],
                            //     ),
                            //     trailing: Row(
                            //       //join to the title
                            //       mainAxisSize: MainAxisSize.min,
                            //       children: [
                            //         IconButton(
                            //           icon: const Icon(
                            //               Icons.report_problem_rounded),
                            //           onPressed: () {},
                            //         ),
                            //         IconButton(
                            //           icon: const Icon(Icons.chat_bubble),
                            //           onPressed: () {},
                            //         )
                            //       ],
                            //     ),
                            //   );
                            // },
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
                  label: Text(
                    'Characters: $_charCount',
                    style: TextStyle(
                      color: _charCount > _charLimit
                          ? Colors.red
                          : colorScheme.onPrimary,
                    ),
                  ),
                  suffixIcon: IconButton(
                    onPressed: () async {
                      if (_commentKey.currentState!.validate()) {
                        await api.createComment(
                            widget.publication, commentCx.text);
                        commentCx.clear();
                        await getComments(); // Fetch comments again
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
