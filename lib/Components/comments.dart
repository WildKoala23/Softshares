import 'package:flutter/material.dart';
import '../classes/commentClass.dart';

class CommentWidget extends StatefulWidget {
  Comment comment;

  CommentWidget({
    Key? key,
    required this.comment,
  }) : super(key: key);

  @override
  _CommentWidgetState createState() => _CommentWidgetState();
}

class _CommentWidgetState extends State<CommentWidget> {
  bool _isReplying = false;
  final TextEditingController _replyController = TextEditingController();

  void _toggleReplying() {
    setState(() {
      _isReplying = !_isReplying;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: colorScheme.primary,
                  child: Text(
                    widget.comment.user.firstname[0].toUpperCase(),
                    style: TextStyle(color: colorScheme.onPrimary),
                  ),
                ),
                const SizedBox(width: 12.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${widget.comment.user.firstname} ${widget.comment.user.lastName}",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.thumb_up_alt_outlined),
                            onPressed: () {},
                            tooltip: 'Like',
                          ),
                          // IconButton(
                          //   icon: const Icon(Icons.thumb_down_alt_outlined),
                          //   onPressed: () {},
                          //   tooltip: 'Dislike',
                          // ),
                        ],
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.report_problem_rounded),
                      onPressed: () {},
                      tooltip: 'Report',
                    ),
                    // IconButton(
                    //   icon: const Icon(Icons.chat_bubble_outline),
                    //   onPressed: _toggleReplying,
                    //   tooltip: 'Reply',
                    // ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            Text(
              widget.comment.comment,
              style: TextStyle(color: colorScheme.onSurface),
            ),
            // if (_isReplying) ...[
            //   const SizedBox(height: 8.0),
            //   TextField(
            //     controller: _replyController,
            //     decoration: InputDecoration(
            //       labelText: 'Add a reply',
            //       suffixIcon: IconButton(
            //         icon: const Icon(Icons.send),
            //         onPressed: () {
            //           if (_replyController.text.isNotEmpty) {
            //             widget.onReply(_replyController.text);
            //             _replyController.clear();
            //             _toggleReplying();
            //           }
            //         },
            //       ),
            //       border: const OutlineInputBorder(),
            //     ),
            //   ),
            // ],
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _replyController.dispose();
    super.dispose();
  }
}
