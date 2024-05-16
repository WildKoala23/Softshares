import 'package:flutter/material.dart';

class createPost extends StatefulWidget {
  const createPost({Key? key}) : super(key: key);

  @override
  State<createPost> createState() => _CreatePostState();
}

class _CreatePostState extends State<createPost> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: appBar(context, colorScheme),
      body: DefaultTabController(
        length: 3,
        child: Column(
          children: [
            TabBar(
              unselectedLabelColor: colorScheme.onSecondary,
              labelColor: colorScheme.onSecondary,
              indicatorColor: colorScheme.primary,
              tabs: const [
                Tab(
                  child: Text('Events'),
                ),
                Tab(
                  child: Text('Forums'),
                ),
                Tab(
                  child: Text('POI'),
                ),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  // Your TabBarView content goes here
                  Container(
                      color: Colors.red,
                      child: Column(
                        children: [
                          ElevatedButton(
                            child: const Text('Continue'),
                            onPressed: () {
                              Navigator.pushNamed(context, '/createForm');
                            },
                          ),
                        ],
                      )),
                  Container(color: Colors.green),
                  Container(color: Colors.blue),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  AppBar appBar(BuildContext context, ColorScheme colorScheme) {
    return AppBar(
      backgroundColor: colorScheme.primary,
      foregroundColor: colorScheme.onPrimary,
      leading: IconButton(
        icon: Icon(Icons.close),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      title: Text('Create Post'),
    );
  }
}
