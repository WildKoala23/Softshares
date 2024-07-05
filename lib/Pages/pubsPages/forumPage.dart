import 'package:flutter/material.dart';
import 'package:softshares/Components/formAppBar.dart';
import 'package:softshares/classes/ClasseAPI.dart';
import 'package:softshares/classes/forums.dart';

class ForumPage extends StatefulWidget {
  const ForumPage({super.key, required this.forum});

  final Forum forum;

  @override
  State<ForumPage> createState() => _PostPageState();
}

class _PostPageState extends State<ForumPage> {
  API api = API();
  TextEditingController commentCx = TextEditingController();
  final _commentKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    commentCx.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
        appBar: formAppbar(title: widget.forum.title),
        body: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  cardHeader(colorScheme),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 5.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        widget.forum.title,
                        style: TextStyle(fontSize: 22),
                      ),
                    ),
                  ),
                  SingleChildScrollView()
                ],
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
                                widget.forum, commentCx.text);
                          }
                        },
                        icon: const Icon(Icons.send)),
                    border: const OutlineInputBorder(borderSide: BorderSide()),
                  ),
                ),
              ),
            ],
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
                      : Text(
                          widget.forum.user.firstname[0],
                          style: TextStyle(color: colorScheme.onPrimary),
                        )),
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
