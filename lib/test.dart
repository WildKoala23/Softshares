import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class test extends StatefulWidget {
  const test({Key? key});

  @override
  State<test> createState() => _testState();
}

class _testState extends State<test> {
  TextEditingController subAreaIdCx = TextEditingController();
  TextEditingController officeIdCx = TextEditingController();
  TextEditingController publisherIdCx = TextEditingController();
  TextEditingController titleCx = TextEditingController();
  TextEditingController contentCx = TextEditingController();

  var url = Uri.http('192.168.56.1:8000', '/api/post/create');

  Future createPost(
    int subAreaId,
    int officeId,
    int publisherId,
    String title,
    String content,
  ) async {
    var response = await http.post(url, body: {
      'subAreaId': subAreaId.toString(),
      'officeId': officeId.toString(),
      'publisher_id': publisherId.toString(),
      'title': title,
      'content': content,
      'plocation': '',
      'filePath': '',
    });
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    subAreaIdCx.dispose();
    officeIdCx.dispose();
    publisherIdCx.dispose();
    titleCx.dispose();
    contentCx.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              //SubAreaID
              TextField(
                  controller: subAreaIdCx,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), label: Text('Subarea'))),
              const SizedBox(
                height: 10,
              ),
              //Office ID
              TextField(
                  controller: officeIdCx,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), label: Text('Office Id'))),
              const SizedBox(
                height: 10,
              ),
              //Publisher id
              TextField(
                  controller: publisherIdCx,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      label: Text('Publisher id'))),
              const SizedBox(
                height: 10,
              ),
              //Title
              TextField(
                  controller: titleCx,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), label: Text('Title'))),
              const SizedBox(
                height: 10,
              ),
              //Content
              TextField(
                  controller: contentCx,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), label: Text('Content'))),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                  onPressed: () {
                    createPost(
                        int.parse(subAreaIdCx.text),
                        int.parse(officeIdCx.text),
                        int.parse(publisherIdCx.text),
                        titleCx.text,
                        contentCx.text);
                  },
                  child: Text('Create post'))
            ],
          ),
        ),
      ),
    );
  }
}
