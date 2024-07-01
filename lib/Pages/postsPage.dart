import 'package:flutter/material.dart';
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
    return Scaffold();
  }
}
