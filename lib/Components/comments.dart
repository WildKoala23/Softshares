import 'package:flutter/material.dart';

class CommentWidget extends StatefulWidget {
  final String userFirstName;
  final String userLastName;
  final String comment;
  final ColorScheme colorScheme;
  final Function(String) onReply;

  const CommentWidget({
    Key? key,
    required this.userFirstName,
    required this.userLastName,
    required this.comment,
    required this.colorScheme,
    required this.onReply,
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
                  backgroundColor: widget.colorScheme.primary,
                  child: Text(
                    widget.userFirstName[0].toUpperCase(),
                    style: TextStyle(color: widget.colorScheme.onPrimary),
                  ),
                ),
                const SizedBox(width: 12.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${widget.userFirstName} ${widget.userLastName}",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: widget.colorScheme.onSurface,
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.thumb_up_alt_outlined),
                            onPressed: () {},
                            tooltip: 'Like',
                          ),
                          IconButton(
                            icon: const Icon(Icons.thumb_down_alt_outlined),
                            onPressed: () {},
                            tooltip: 'Dislike',
                          ),
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
                    IconButton(
                      icon: const Icon(Icons.chat_bubble_outline),
                      onPressed: _toggleReplying,
                      tooltip: 'Reply',
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            Text(
              widget.comment,
              style: TextStyle(color: widget.colorScheme.onSurface),
            ),
            if (_isReplying) ...[
              const SizedBox(height: 8.0),
              TextField(
                controller: _replyController,
                decoration: InputDecoration(
                  labelText: 'Add a reply',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: () {
                      if (_replyController.text.isNotEmpty) {
                        widget.onReply(_replyController.text);
                        _replyController.clear();
                        _toggleReplying();
                      }
                    },
                  ),
                  border: const OutlineInputBorder(),
                ),
              ),
            ],
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
