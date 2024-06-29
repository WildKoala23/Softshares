import 'dart:convert';

import '../classes/POI.dart';
import '../classes/forums.dart';
import '../classes/user.dart';
import '../classes/publication.dart';
import 'package:http/http.dart' as http;

class API {
  var url = 'backendpint-w3vz.onrender.com';

  Future<User> getUser(int id) async {
    var response =
        await http.get(Uri.https(url, '/api/dynamic//user-info/$id'));

    var jsonData = jsonDecode(response.body);

    var user =
        User(jsonData['first_name'], jsonData['last_name'], jsonData['email']);

    return user;
  }

  Future<List<Publication>> getAllPosts() async {
    List<Publication> publications = [];

    var response = await http.get(Uri.https(url, '/api/dynamic/all-content'));

    var jsonData = jsonDecode(response.body);

    for (var eachPub in jsonData['posts']) {
      if (eachPub['type'] == 'N' && publications.length < 9) {
        User publisherUser = await getUser(eachPub['publisher_id']);
        final publication = Publication(
            publisherUser,
            null,
            eachPub['content'],
            'Viseu',
            eachPub['title'],
            eachPub['validated'],
            'Sports',
            'Football',
            DateTime.now());
        publications.add(publication);
      }
    }
    return publications;
  }
}
