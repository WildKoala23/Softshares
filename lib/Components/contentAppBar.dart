import 'package:flutter/material.dart';
import 'package:softshares/Pages/editPubs/editEvent.dart';
import 'package:softshares/Pages/editPubs/editForum.dart';
import 'package:softshares/Pages/editPubs/editPost.dart';
import 'package:softshares/Pages/filterPOIPage.dart';
import 'package:softshares/Pages/homepage.dart';
import 'package:softshares/classes/ClasseAPI.dart';
import 'package:softshares/classes/areaClass.dart';
import 'package:softshares/classes/event.dart';
import 'package:softshares/classes/forums.dart';
import 'package:softshares/classes/publication.dart';
import 'package:share_plus/share_plus.dart';

class contentAppBar extends StatefulWidget implements PreferredSizeWidget {
  const contentAppBar({super.key, required this.pub, required this.areas});
  final Publication pub;
  final List<AreaClass> areas;
  @override
  State<contentAppBar> createState() => _contentAppBarState();
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _contentAppBarState extends State<contentAppBar> {
  final TextEditingController _scoreController = TextEditingController();
  API api = API();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return AppBar(
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: const Icon(Icons.close),
      ),
      title: Text(widget.pub.title),
      actions: [
        IconButton(
            onPressed: () {
              Share.share(
                  '_Check out this publication:_\n*${widget.pub.title}*\n ${widget.pub.desc}');
            },
            icon: const Icon(Icons.share)),
        widget.pub.validated == false
            ? IconButton(
                onPressed: () {
                  switch (widget.pub) {
                    case Event _:
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EditEvent(
                                pub: widget.pub as Event, areas: widget.areas)),
                      );
                      break;
                    case Forum _:
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EditForum(
                                  pub: widget.pub as Forum,
                                  areas: widget.areas,
                                )),
                      );
                      break;
                    case Publication _:
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EditPost(
                                    post: widget.pub,
                                    areas: widget.areas,
                                  )));
                      break;
                  }
                },
                icon: const Icon(Icons.edit))
            : IconButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled:
                        true, // Allow the bottom sheet to be responsive to the keyboard
                    builder: (BuildContext context) {
                      return Padding(
                        padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context)
                              .viewInsets
                              .bottom, // Adjust padding for keyboard
                          left: 16,
                          right: 16,
                          top: 16,
                        ),
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Submit your review',
                                style: TextStyle(color: colorScheme.onPrimary),
                              ),
                              const SizedBox(height: 16),
                              TextField(
                                controller: _scoreController,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  labelText: 'Enter your score (1-5)',
                                ),
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: () async {
                                  final score =
                                      int.tryParse(_scoreController.text);
                                  if (score != null &&
                                      score >= 1 &&
                                      score <= 5) {
                                    //await api.ratePub(widget.pub, score);

                                    await api.getPostScore(widget.pub.id!);

                                    // int new_score =
                                    //     await api.getNewScore(widget.pub);
                                    setState(() {
                                      // widget.pub.aval = new_score * 1.0;
                                      widget.pub.aval = score * 1.0;
                                    });
                                    Navigator.pop(context);
                                  } else {
                                    // Show an error message or handle invalid input
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                            'Please enter a valid score between 1 and 5.'),
                                      ),
                                    );
                                  }
                                },
                                style: ButtonStyle(
                                    backgroundColor: MaterialStatePropertyAll(
                                        colorScheme.primary)),
                                child: Text(
                                  'Submit',
                                  style:
                                      TextStyle(color: colorScheme.onPrimary),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
                icon: const Icon(Icons.rate_review),
              ),
      ],
    );
  }

  @override
  void dispose() {
    _scoreController.dispose();
    super.dispose();
  }
}
