import 'package:flutter/material.dart';
import 'package:softshares/classes/ClasseAPI.dart';
import 'package:softshares/classes/areaClass.dart';

class AreaAlbum extends StatefulWidget {
  const AreaAlbum({super.key, required this.area});

  final AreaClass area;

  @override
  State<AreaAlbum> createState() => _AreaAlbumState();
}

class _AreaAlbumState extends State<AreaAlbum> {
  API api = API();

  Future getAlbums() async {

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.area.areaName),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.close)),
      ),
    );
  }
}
