// import libraries
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:softshares/classes/areaClass.dart';
import 'package:softshares/classes/db.dart';
import 'package:softshares/classes/event.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
// jwt libraries
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import '../env.dart';

//import files
import 'utils.dart';
import '../classes/POI.dart';
import '../classes/forums.dart';
import '../classes/user.dart';
import '../classes/publication.dart';

class API {
  var baseUrl = 'backendpint-w3vz.onrender.com';
  //var baseUrl = '10.0.2.2:8000';
  final box = GetStorage();
  final storage = const FlutterSecureStorage();
  final SQLHelper bd = SQLHelper.instance;

  Future<User> getUser(int id) async {
    String? jwtToken = await getToken();

    var response = await http
        .get(Uri.https(baseUrl, '/api/dynamic/user-info/$id'), headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $jwtToken'
    });

    var jsonData = jsonDecode(response.body);
    var user = User(jsonData['data']['user_id'], jsonData['data']['first_name'],
        jsonData['data']['last_name'], jsonData['data']['email']);

    return user;
  }

  Future<User> getUserLogged(int id) async {
    String? jwtToken = await getToken();

    var response = await http
        .get(Uri.https(baseUrl, '/api/dynamic/user-info/$id'), headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $jwtToken'
    });

    var jsonData = jsonDecode(response.body);
    var user = User(jsonData['data']['user_id'], jsonData['data']['first_name'],
        jsonData['data']['last_name'], jsonData['data']['email']);
    box.write('selectedCity', jsonData['data']['OfficeWorker']['office_id']);

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
      // var response = await sendRequest(
      //   method: 'GET',
      //   url: baseUrl,
      //   jwtToken: jwtToken,
      // );
      // print('ccccccccccc');

      var response = await http.get(
          Uri.https(baseUrl, '/api/dynamic/posts-by-city/$officeId'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $jwtToken'
          });

      print(response.statusCode);

      var jsonData = jsonDecode(response.body);
      print(jsonData);
      //Get all Posts
      for (var eachPub in jsonData['data']) {
        //Filter posts with poi's
        if (eachPub['type'] == 'N') {
          User publisherUser = await getUser(eachPub['publisher_id']);
          print('ID: ${publisherUser.id} ');
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
          print('Publication ${publication.id}');
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
    String? jwtToken = await getToken();

    var response = await http.get(
        Uri.https(baseUrl, '/api/dynamic/forums-by-city/${officeId}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $jwtToken'
        });

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

    String? jwtToken = await getToken();

    var response = await http.get(
        Uri.https(baseUrl, '/api/dynamic/events-by-city/$officeId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $jwtToken'
        });

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
    String? jwtToken = await getToken();
    int officeId = box.read('selectedCity');

    print(jwtToken);

    var response = await http.get(
        Uri.http(baseUrl, '/api/dynamic/all-content-per/$officeId'),
        headers: {'Authorization': 'Bearer $jwtToken'});

    print('THIS IS DATA');

    var jsonData = jsonDecode(response.body);
    print(response.body);

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
      events = await getEvents();
      forums = await getForums();
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
    int officeId = box.read('selectedCity');
    String? jwtToken = await getToken();

    var response = await http.get(
        Uri.https(baseUrl, '/api/dynamic/all-content-per/$officeId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $jwtToken'
        });

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
    String? jwtToken = await getToken();
    //FOR YOU TO FIX
    // String? jwtToken = await getToken();

    // var response = await http
    //     .get(Uri.https(baseUrl, '/api/dynamic/all-content'), headers: {
    //   'Content-Type': 'application/json',
    //   'Authorization': 'Bearer $jwtToken'
    // });

    // Check if the file exists
    if (await img.exists()) {
      final Uri url = Uri.parse(baseUrl);
      final request = http.MultipartRequest('POST', url);

      request.headers['Authorization'] = 'Bearer $jwtToken';

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
    String? jwtToken = await getToken();

    if (pub.img != null) {
      path = await uploadPhoto(pub.img!);
      print('Path: $path');
    }

    // String? jwtToken = await getToken();

    // var response = await http
    //     .get(Uri.https(baseUrl, '/api/dynamic/all-content'), headers: {
    //   'Content-Type': 'application/json',
    //   'Authorization': 'Bearer $jwtToken'
    // });

    var response =
        await http.post(Uri.https(baseUrl, '/api/post/create'), body: {
      'subAreaId': pub.subCategory.toString(),
      'officeId': office.toString(),
      'publisher_id': pub.user.id.toString(),
      'title': pub.title,
      'content': pub.desc,
      'filePath': path.toString(),
      'pLocation': pub.location.toString(),
    }, headers: {
      'Authorization': 'Bearer $jwtToken'
    });

    print(response.body);
    print(response.statusCode);
  }

  Future createEvent(Event event) async {
    var office = box.read('selectedCity');
    String? jwtToken = await getToken();

    String? path;

    if (event.img != null) {
      path = await uploadPhoto(event.img!);
    }

    // String? jwtToken = await getToken();

    // var response = await http
    //     .get(Uri.https(baseUrl, '/api/dynamic/all-content'), headers: {
    //   'Content-Type': 'application/json',
    //   'Authorization': 'Bearer $jwtToken'
    // });

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
    }, headers: {
      'Authorization': 'Bearer $jwtToken'
    });
  }

  Future createForum(Forum forum) async {
    var office = box.read('selectedCity');
    String? jwtToken = await getToken();

    // String? jwtToken = await getToken();

    // var response = await http
    //     .get(Uri.https(baseUrl, '/api/dynamic/all-content'), headers: {
    //   'Content-Type': 'application/json',
    //   'Authorization': 'Bearer $jwtToken'
    // });

    var response =
        await http.post(Uri.https(baseUrl, '/api/forum/create'), body: {
      'officeID': office.toString(),
      'subAreaId': forum.subCategory.toString(),
      'title': forum.title,
      'description': forum.desc,
      'publisher_id': forum.user.id.toString(),
    }, headers: {
      'Authorization': 'Bearer $jwtToken'
    });

    print(response.statusCode);
  }

  Future createPOI(POI poi) async {
    var office = box.read('selectedCity');
    String? path;
    String? jwtToken = await getToken();

    if (poi.img != null) {
      path = await uploadPhoto(poi.img!);
    }

    // String? jwtToken = await getToken();

    // var response = await http
    //     .get(Uri.https(baseUrl, '/api/dynamic/all-content'), headers: {
    //   'Content-Type': 'application/json',
    //   'Authorization': 'Bearer $jwtToken'
    // });

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
    }, headers: {
      'Authorization': 'Bearer $jwtToken'
    });

    print(response.statusCode);
    print(response.body);
  }

  Future<List<AreaClass>> getAreas() async {
    try {
      List<AreaClass> list = [];

      String? jwtToken = await getToken();

      var response = await http
          .get(Uri.https(baseUrl, '/api/categories/get-areas'), headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $jwtToken'
      });

      var responseSub = await http
          .get(Uri.https(baseUrl, '/api/categories/get-sub-areas'), headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $jwtToken'
      });

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
    } catch (e) {
      rethrow;
    }
  }

  Future<String> getSubAreaName(int id) async {
    var result = '';
    String? jwtToken = await getToken();

    var response = await http
        .get(Uri.https(baseUrl, '/api/categories/get-sub-areas'), headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $jwtToken'
    });

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
    int officeId = box.read('selectedCity');

    try {
      String? jwtToken = await getToken();

      var response = await http.get(
          Uri.https(baseUrl, '/api/dynamic/events-by-city/$officeId'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $jwtToken'
          });

      var jsonData = jsonDecode(response.body);

      for (var eachPub in jsonData['data']) {
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
    print(events.length);
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
        type = 'forum';
        break;
      default:
        type = 'post';
    }

    String? jwtToken = await getToken();

    var response = await http.get(
        Uri.https(baseUrl,
            '/api/comment/get-comment-tree/content/$type/id/${pub.id}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $jwtToken'
        });

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
      case Event _:
        type = 'forum';
        break;
      default:
        type = 'post';
    }
    String? jwtToken = await getToken();
    // var _id = await getID();
    User? user = await bd.getUser();
    // print('in comments: $_id');
    // print(_id.runtimeType);
    var response = await http
        .post(Uri.https(baseUrl, '/api/comment/add-comment'), headers: {
      'Authorization': 'Bearer $jwtToken'
    }, body: {
      'contentID': pub.id.toString(),
      'contentType': type,
      'userID': user!.id.toString(),
      'commentText': comment
    });
    // var response =
    //     await http.post(Uri.https(baseUrl, '/api/comment/add-comment'), body: {
    //   'contentID': pub.id.toString(),
    //   'contentType': type,
    //   'userID': "1", //Change with loggin
    //   'commentText': comment
    // });

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
      print('TOKEN: $token ');
      //decrypt the recieved token
      var decryptedToken = await decryptToken(token);

      //print('Decrypted TOKEN: $decryptedToken');
      //decod decrypted token so the user_id can be accessed
      final jwt = JWT.decode(decryptedToken);
      final payload = jwt.payload;
      print('Decoded TOKEN: ${payload}');
      //get the user id from the payload
      final _id = payload['id'];
      //Get city
      //await getUserLogged(_id);
      //print('USER ID: $_id');
      // Store the JWT token
      await storage.write(key: 'jwt_token', value: jsonEncode(token));
      return token;
    } else {
      // Handle error response
      print('Failed to log in: ${response.body}');
    }
  }

  Future<String?> getToken() async {
    return await storage.read(key: 'jwt_token');
  }

  // Future<String?> getID() async {
  //   return await storage.read(key: 'user_id');
  // }

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

Future<String> decryptToken(encryptedToken) async {
  print('inside decrypt {$encryptedToken}');

  print(encryptedToken['iv']);
  final String encryptionKey = Env.encryption_key;
  final key = encrypt.Key.fromBase64(encryptionKey);
  // Convert the IV from hex to bytes
  final iv = encrypt.IV.fromBase16(encryptedToken['iv']);
  final encryptedData = encryptedToken['encryptedData'];

  final encrypter =
      encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc));

  // Convert the encrypted data from base64
  final encryptedBytes = encrypt.Encrypted.fromBase64(encryptedData);

  // Decrypt the data
  final decrypted = encrypter.decrypt(encryptedBytes, iv: iv);

  // print('Encrypted Data: $encryptedData');
  // print('IV: ${encryptedToken['iv']}');
  // print('Decrypted: $decrypted');
  // print(decrypted.runtimeType);

  return decrypted;
}
