import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:softshares/Components/formAppBar.dart';
import 'package:softshares/classes/ClasseAPI.dart';
import 'package:softshares/classes/publication.dart';

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
              Column(
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
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Container(
                      width: double.infinity,
                      height: 250,
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        child: widget.publication.img != null
                            ? Image.network(
                                fit: BoxFit.cover,
                                'https://backendpint-w3vz.onrender.com/uploads/${widget.publication.img!.path}',
                                //Handles images not existing
                                errorBuilder: (context, error, stackTrace) {
                                return Container();
                              })
                            : Container(),
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
                                widget.publication, commentCx.text);
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
