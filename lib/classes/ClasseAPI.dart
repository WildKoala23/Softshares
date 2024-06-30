import 'dart:convert';
import '../classes/POI.dart';
import '../classes/forums.dart';
import '../classes/user.dart';
import '../classes/publication.dart';
import 'package:http/http.dart' as http;

class API {
  var baseUrl = 'backendpint-w3vz.onrender.com';

  Future<User> getUser(int id) async {
    var response =
        await http.get(Uri.https(baseUrl, '/api/dynamic//user-info/$id'));

    var jsonData = jsonDecode(response.body);

    var user = User(jsonData['user_id'], jsonData['first_name'],
        jsonData['last_name'], jsonData['email']);

    return user;
  }

  Future<List<Publication>> getAllPosts() async {
    List<Publication> publications = [];

    var response =
        await http.get(Uri.https(baseUrl, '/api/dynamic/all-content'));

    var jsonData = jsonDecode(response.body);

    for (var eachPub in jsonData['posts']) {
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
          DateTime.parse(eachPub['creation_date']));
      publications.add(publication);
    }
    for (var eachPub in jsonData['forums']) {
      User publisherUser = await getUser(eachPub['publisher_id']);
      final publication = Forum(
          publisherUser,
          null,
          eachPub['content'],
          'Viseu',
          eachPub['title'],
          eachPub['validated'],
          'Sports',
          'Football',
          DateTime.parse(eachPub['creation_date']));
      publications.add(publication);
    }

    publications.sort((a, b) => a.datePost.compareTo(b.datePost));
    return publications;
  }

  Future<List<POI>> getAllPoI() async {
    List<POI> list = [];

    var response =
        await http.get(Uri.https(baseUrl, '/api/dynamic/all-content'));

    var jsonData = jsonDecode(response.body);

    for (var eachPub in jsonData['posts']) {
      if (eachPub['type'] == 'P' && list.length < 1) {
        User publisherUser = await getUser(eachPub['publisher_id']);
        final publication = POI(
            publisherUser,
            null,
            eachPub['content'],
            'Viseu',
            eachPub['title'],
            eachPub['validated'],
            'Sports',
            'Football',
            DateTime.now(),
            3,
            null);
        list.add(publication);
      }
    }
    return list;
  }

  //Change when api is complete
  Future<bool> createPost(Publication pub) async {
    var response =
        await http.post(Uri.https(baseUrl, '/api/post/create'), body: {
      'sub_area_id': 1001,
      'office_id': 1,
      'publisher_id': pub.user.id,
      'creation_date': pub.datePost.toString(),
      'type': 'N',
      'validated': pub.validated,
      'title': pub.title,
      'content': pub.desc,
    });

    print(response.statusCode);

    return true;
  }
}
