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
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                  const SizedBox(
                    height: 80,
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Form(
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
            ),
          ),
        ],
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
