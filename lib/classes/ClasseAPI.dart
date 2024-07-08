import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:softshares/classes/areaClass.dart';
import 'package:softshares/classes/event.dart';
import 'utils.dart';
import '../classes/POI.dart';
import '../classes/forums.dart';
import '../classes/user.dart';
import '../classes/publication.dart';

import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
//import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../env.dart';

class API {
  //var baseUrl = Env.apiUrl;
  var baseUrl = 'localhost:8000';
  final box = GetStorage();
  final storage = const FlutterSecureStorage();

  Future<User> getUser(int id) async {
    var response =
        await http.get(Uri.https(baseUrl, '/api/dynamic/user-info/$id'));

    var jsonData = jsonDecode(response.body);

    var user = User(jsonData['data']['user_id'], jsonData['data']['first_name'],
        jsonData['data']['last_name'], jsonData['data']['email']);

    return user;
  }

  Future<List<Publication>> getPosts() async {
    List<Publication> publications = [];
    int officeId = box.read('selectedCity');

    try {
      String? jwtToken = await getToken();
      // Check if the token is not null before proceeding
      if (jwtToken == null) {
        print('Failed to retrieve JWT token');
        throw Exception('Failed to retrieve JWT Token');
      }
      var response = await sendRequest(
        method: 'GET',
        url: baseUrl,
        jwtToken: jwtToken,
      );

      // var response = await http
      //     .get(Uri.https(baseUrl, '/api/dynamic/posts-by-city/$officeId'));
      // autentication header 'Bearer' +
      print(response.statusCode);

      var jsonData = jsonDecode(response.body);

      //Get all Posts
      for (var eachPub in jsonData['data']) {
        //Filter posts with poi's
        if (eachPub['type'] == 'N') {
          User publisherUser = await getUser(eachPub['publisher_id']);
          var file;
          if (eachPub['filepath'] != null) {
            file = File(eachPub['filepath']);
          } else {
            file = null;
          }
          final publication = Publication(
            eachPub['post_id'],
            publisherUser,
            null,
            eachPub['content'],
            eachPub['title'],
            eachPub['validated'],
            eachPub['sub_area_id'],
            DateTime.parse(eachPub['creation_date']),
            file,
            eachPub['p_location'],
          );
          await publication.getSubAreaName();
          publications.add(publication);
        }
      }
      //Sort for most recent first
      publications.sort((a, b) => b.datePost.compareTo(a.datePost));

      return publications;
    } catch (err) {
      print(err);
      rethrow; // rethrow the error if needed or handle it accordingly
    }
  }

  Future<List<Forum>> getForums() async {
    List<Forum> publications = [];
    int officeId = box.read('selectedCity');

    var response = await http
        .get(Uri.https(baseUrl, '/api/dynamic/forums-by-city/${officeId}'));

    var jsonData = jsonDecode(response.body);

    for (var eachPub in jsonData['data']) {
      if (eachPub['event_id'] == null) {
        User publisherUser = await getUser(eachPub['publisher_id']);
        final publication = Forum(
          eachPub['forum_id'],
          publisherUser,
          null,
          eachPub['content'],
          eachPub['title'],
          eachPub['validated'],
          eachPub['sub_area_id'],
          DateTime.parse(eachPub['creation_date']),
        );
        await publication.getSubAreaName();
        publications.add(publication);
      }
    }

    //Sort for most recent first
    publications.sort((a, b) => b.datePost.compareTo(a.datePost));

    return publications;
  }

  Future<List<Event>> getEvents() async {
    List<Event> publications = [];
    int officeId = box.read('selectedCity');

    var response = await http
        .get(Uri.https(baseUrl, '/api/dynamic/events-by-city/$officeId'));

    var jsonData = jsonDecode(response.body);

    //Get all events
    for (var eachPub in jsonData['data']) {
      var file;
      if (eachPub['filepath'] != null) {
        file = File(eachPub['filepath']);
      } else {
        file = null;
      }
      User publisherUser = await getUser(eachPub['publisher_id']);
      final publication = Event(
          eachPub['event_id'],
          publisherUser,
          null,
          eachPub['description'],
          eachPub['name'],
          eachPub['validated'],
          eachPub['sub_area_id'],
          DateTime.parse(eachPub['creation_date']),
          file,
          eachPub['event_location'],
          DateTime.parse(eachPub['event_date']),
          eachPub['recurring']);
      await publication.getSubAreaName();
      publications.add(publication);
    }

    //Sort for most recent first
    publications.sort((a, b) => b.datePost.compareTo(a.datePost));

    return publications;
  }

  Future<List<Publication>> getAllPubsByArea(int areaId, String type) async {
    List<Publication> publications = [];

    var response =
        await http.get(Uri.https(baseUrl, '/api/dynamic/all-content'));

    var jsonData = jsonDecode(response.body);

    for (var eachPub in jsonData[type]) {
      var file;
      if (eachPub['filepath'] != null) {
        file = File(eachPub['filepath']);
      } else {
        file = null;
      }
      int roundedAreaId = (eachPub['sub_area_id'] / 10).round();
      if (roundedAreaId == areaId) {
        User publisherUser = await getUser(eachPub['publisher_id']);
        if (type == 'posts' && eachPub['type'] == 'N') {
          final publication = Publication(
            eachPub['post_id'],
            publisherUser,
            null,
            eachPub['content'],
            eachPub['title'],
            eachPub['validated'],
            eachPub['sub_area_id'],
            DateTime.parse(eachPub['creation_date']),
            file,
            eachPub['p_location'],
          );
          await publication.getSubAreaName();
          publications.add(publication);
        } else if (type == 'forums') {
          final publication = Forum(
              eachPub['forum_id'],
              publisherUser,
              null,
              eachPub['content'],
              eachPub['title'],
              eachPub['validated'],
              eachPub['sub_area_id'],
              DateTime.parse(eachPub['creation_date']));
          await publication.getSubAreaName();
          publications.add(publication);
        } else if (type == 'events') {
          final publication = Event(
              eachPub['event_id'],
              publisherUser,
              null,
              eachPub['description'],
              eachPub['name'],
              eachPub['validated'],
              eachPub['sub_area_id'],
              DateTime.parse(eachPub['creation_date']),
              file,
              eachPub['eventLocation'],
              DateTime.parse(eachPub['event_date']),
              eachPub['recurring']);
          await publication.getSubAreaName();
          publications.add(publication);
        }
      }
    }

    //Sort for most recent first
    publications.sort((a, b) => b.datePost.compareTo(a.datePost));

    return publications;
  }

  Future<List<Publication>> getAllPosts() async {
    List<Publication> pubs = [];
    List<Publication> posts = [];
    List<Event> events = [];
    List<Forum> forums = [];

    try {
      posts = await getPosts();
      // events = await getEvents();
      // forums = await getForums();
      pubs.addAll(posts);
      pubs.addAll(events);
      pubs.addAll(forums);
    } catch (e) {
      print(e);
    }

    //Sort for most recent first
    pubs.sort((a, b) => b.datePost.compareTo(a.datePost));

    return pubs;
  }

  Future<List<POI>> getAllPoI() async {
    List<POI> list = [];

    var response =
        await http.get(Uri.https(baseUrl, '/api/dynamic/all-content'));

    var jsonData = jsonDecode(response.body);

    for (var eachPub in jsonData['posts']) {
      var file;
      if (eachPub['filepath'] != null) {
        file = File(eachPub['filepath']);
      } else {
        file = null;
      }
      if (eachPub['type'] == 'P') {
        User publisherUser = await getUser(eachPub['publisher_id']);
        final publication = POI(
          eachPub['post_id'],
          publisherUser,
          null,
          eachPub['content'],
          eachPub['title'],
          eachPub['validated'],
          eachPub['sub_area_id'],
          DateTime.parse(eachPub['creation_date']),
          file,
          eachPub['p_location'],
          3,
        );
        await publication.getSubAreaName();
        list.add(publication);
      }
    }
    return list;
  }

  //This function is used everytime a user creates something with an image
  Future uploadPhoto(File img) async {
    String baseUrl = 'https://backendpint-w3vz.onrender.com/upload/upload';

    // Check if the file exists
    if (await img.exists()) {
      final Uri url = Uri.parse(baseUrl);
      final request = http.MultipartRequest('POST', url);

      // Add the file to the request
      request.files.add(await http.MultipartFile.fromPath(
        'image',
        img.path,
      ));

      try {
        final streamedResponse = await request.send();

        final response = await http.Response.fromStream(streamedResponse);

        if (response.statusCode == 200) {
          print('File uploaded successfully');
          var data = jsonDecode(response.body);
          return data['file']['filename'];
        } else {
          print('Failed to upload file. Status code: ${response.statusCode}');
          print(response.body);
        }
      } catch (e) {
        print('Error uploading file: $e');
      }
    } else {
      print('No valid image path provided.');
    }
  }

  Future createPost(Publication pub) async {
    var office = box.read('selectedCity');
    String? path;

    if (pub.img != null) {
      path = await uploadPhoto(pub.img!);
      print('Path: $path');
    }

    var response =
        await http.post(Uri.https(baseUrl, '/api/post/create'), body: {
      'subAreaId': pub.subCategory.toString(),
      'officeId': office.toString(),
      'publisher_id': pub.user.id.toString(),
      'title': pub.title,
      'content': pub.desc,
      'filePath': path.toString(),
      'pLocation': pub.location.toString(),
    });

    print(response.body);
    print(response.statusCode);
  }

  Future createEvent(Event event) async {
    var office = box.read('selectedCity');

    String? path;

    if (event.img != null) {
      path = await uploadPhoto(event.img!);
    }

    var response =
        await http.post(Uri.https(baseUrl, '/api/event/create'), body: {
      'subAreaId': event.subCategory.toString(),
      'officeId': office.toString(),
      'publisher_id': event.user.id.toString(),
      'name': event.title,
      'description': event.desc,
      'filePath': path.toString(),
      'eventDate':
          event.eventDate.toIso8601String(), //Convert DateTime to string
      'location': event.location.toString(),
    });
  }

  Future createForum(Forum forum) async {
    var office = box.read('selectedCity');

    var response =
        await http.post(Uri.https(baseUrl, '/api/forum/create'), body: {
      'officeID': office.toString(),
      'subAreaId': forum.subCategory.toString(),
      'title': forum.title,
      'description': forum.desc,
      'publisher_id': forum.user.id.toString(),
    });

    print(response.statusCode);
  }

  Future createPOI(POI poi) async {
    var office = box.read('selectedCity');
    String? path;

    if (poi.img != null) {
      path = await uploadPhoto(poi.img!);
    }

    var response =
        await http.post(Uri.https(baseUrl, '/api/post/create'), body: {
      'subAreaId': poi.subCategory.toString(),
      'officeId': office.toString(),
      'publisher_id': poi.user.id.toString(),
      'title': poi.title,
      'content': poi.desc,
      'type': 'P',
      'filePath': path.toString(),
      'pLocation': poi.location.toString(),
      'rating': poi.aval.round().toString()
    });

    print(response.statusCode);
    print(response.body);
  }

  Future<List<AreaClass>> getAreas() async {
    List<AreaClass> list = [];
    var response =
        await http.get(Uri.https(baseUrl, '/api/categories/get-areas'));
    var responseSub =
        await http.get(Uri.https(baseUrl, '/api/categories/get-sub-areas'));

    var jsonData = jsonDecode(response.body);
    var jsonDataSub = jsonDecode(responseSub.body);

    for (var area in jsonData['data']) {
      List<AreaClass> subareas = [];
      //Get subareas reletated to each area
      for (var subarea in jsonDataSub['data']) {
        if (subarea['area_id'] == area['area_id']) {
          var dummyArea = AreaClass(
            id: subarea['sub_area_id'],
            areaName: subarea['title'],
          );
          subareas.add(dummyArea);
        }
      }
      var dummyArea = AreaClass(
          id: area['area_id'],
          areaName: area['title'],
          icon: iconMap[area['icon_name']],
          subareas: subareas);
      list.add(dummyArea);
    }
    return list;
  }

  Future<String> getSubAreaName(int id) async {
    var result = '';

    var response =
        await http.get(Uri.https(baseUrl, '/api/categories/get-sub-areas'));

    var jsonData = jsonDecode(response.body);

    for (var area in jsonData['data']) {
      if (area['sub_area_id'] == id) {
        result = area['title'];
        break;
      }
    }
    return result;
  }

  Future<Map<DateTime, List<Event>>> getEventCalendar() async {
    Map<DateTime, List<Event>> events = {};

    try {
      var response =
          await http.get(Uri.https(baseUrl, '/api/dynamic/all-content'));
      var jsonData = jsonDecode(response.body);

      for (var eachPub in jsonData['events']) {
        var file = eachPub['filepath'] != null
            ? File(eachPub['filepath'])
            : null; // Check if event has image
        User publisherUser = await getUser(eachPub['publisher_id']); // Get user

        DateTime creationDate = DateTime.parse(eachPub['creation_date']);
        DateTime eventDate = DateTime.parse(eachPub['event_date']);

        // Create Event object
        final publication = Event(
            eachPub['event_id'],
            publisherUser,
            null,
            eachPub['description'],
            eachPub['name'],
            eachPub['validated'],
            eachPub['sub_area_id'],
            creationDate,
            file,
            eachPub['eventLocation'],
            eventDate,
            eachPub['recurring']);

        await publication.getSubAreaName();

        // Get event day with only date (year, month, day)
        DateTime eventDay =
            DateTime(eventDate.year, eventDate.month, eventDate.day);

        // Initialize List if not already initialized
        events[eventDay] ??= [];

        // Add the publication to the list of events for that day
        events[eventDay]!.add(publication);
      }
    } catch (e) {
      print('Error fetching event data: $e');
      return {};
    }

    return events;
  }

  Future getComents(
    Publication pub,
  ) async {
    Map<User, String> comments = {};

    late String type;
    switch (pub) {
      case Forum _:
        type = 'forum';
        break;
      case Event _:
        type = 'event';
        break;
      default:
        type = 'post';
    }
    var response = await http.get(Uri.https(
        baseUrl, '/api/comment/get-comment-tree/content/$type/id/${pub.id}'));

    var jsonData = jsonDecode(response.body);

    for (var comment in jsonData['data']) {
      User user = await getUser(comment['publisher_id']);
      comments[user] = comment['content'];
    }

    return comments;
  }

  Future createComment(Publication pub, String comment) async {
    late String type;

    switch (pub) {
      case Forum _:
        type = 'forum';
        break;
      default:
        type = 'post';
    }

    var response =
        await http.post(Uri.https(baseUrl, '/api/comment/add-comment'), body: {
      'contentID': pub.id.toString(),
      'contentType': type,
      'userID': "1", //Change with loggin
      'commentText': comment
    });

    if (response.statusCode == 200) {
      // Handle successful response
      print('Comment created successfully');
    } else {
      // Handle error response
      print('Failed to create comment: ${response.body}');
    }
  }

  Future registerUser(
      String email, String fName, String lName, int city) async {
    var response =
        await http.post(Uri.https(baseUrl, '/api/auth/register'), body: {
      'email': email,
      'firstName': fName,
      'lastName': lName,
      'centerId': city.toString()
    });

    if (response.statusCode == 201) {
      // Handle successful response
      print('User registered successfully');
      return true;
    } else {
      // Handle error response
      print('Failed to register new user: ${response.body}');
    }
  }

  Future logInDb(String email, String password) async {
    var response =
        await http.post(Uri.https(baseUrl, '/api/auth/login_mobile'), body: {
      'email': email,
      'password': password,
    });

    if (response.statusCode == 200) {
      // Handle successful response
      print('User login successfull');

      var jsonData = jsonDecode(response.body);
      var token = jsonData['token'];
      // Store the JWT token
      await storage.write(key: 'jwt_token', value: token);
      return token;
    } else {
      // Handle error response
      print('Failed to log in: ${response.body}');
    }
  }

  Future<String?> getToken() async {
    return await storage.read(key: 'jwt_token');
  }

  Future<void> logout() async {
    await storage.delete(key: 'jwt_token');
  }
}

Future<http.Response> sendRequest({
  required String method,
  required String url,
  required String jwtToken,
  Map<String, String>? headers,
  dynamic body,
}) async {
  // Add the Authorization header with the JWT token
  headers = headers ?? {};
  headers['Content-Type'] = 'application/json';
  headers['Authorization'] = 'Bearer $jwtToken';

  // Encode the body if it's provided
  dynamic encodedBody = body != null ? jsonEncode(body) : null;

  http.Response response;

  // Choose the correct method
  switch (method.toUpperCase()) {
    case 'POST':
      response =
          await http.post(Uri.parse(url), headers: headers, body: encodedBody);
      break;
    case 'PUT':
      response =
          await http.put(Uri.parse(url), headers: headers, body: encodedBody);
      break;
    case 'PATCH':
      response =
          await http.patch(Uri.parse(url), headers: headers, body: encodedBody);
      break;
    case 'GET':
    default:
      response = await http.get(Uri.parse(url), headers: headers);
  }

  // Handle the response
  if (response.statusCode >= 200 && response.statusCode < 300) {
    // Request was successful
    print('Response data: ${response.body}');
    return response;
  } else {
    // Request failed
    print('Failed to load data: ${response.statusCode}');
    print('Response body: ${response.body}');
    throw Exception('No response from server');
  }
}
