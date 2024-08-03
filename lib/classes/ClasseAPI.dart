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
import 'package:softshares/classes/fieldClass.dart';
import '../env.dart';

//import files
import 'utils.dart';
import '../classes/POI.dart';
import '../classes/forums.dart';
import '../classes/user.dart';
import '../classes/publication.dart';
import '../classes/InvalidTokenExceptionClass.dart';

class API {
  var baseUrl = 'backendpint-w3vz.onrender.com';
  //var baseUrl = '10.0.2.2:8000';
  final box = GetStorage();
  final storage = const FlutterSecureStorage();
  final SQLHelper bd = SQLHelper.instance;

  Future<void> refreshAccessToken() async {
    String? refreshToken = await getRefreshToken();
    if (refreshToken == null) {
      print('Failed to retrieve refreshToken');
      throw Exception('Failed to retrieve refreshToken');
    }

    var response = await http.post(
        Uri.https(baseUrl, '/api/auth/refresh-token'),
        body: {'refreshToken': refreshToken});
    if (response.statusCode != 200) {
      throw Exception('Failed to refresh token');
    }

    var jsonData = jsonDecode(response.body);
    var token = jsonData['accessToken'];
    await storage.write(key: 'jwt_token', value: jsonEncode(token));
  }

  Future<User> getUser(int id) async {
    try {
      String? jwtToken = await getToken();

      var response = await http
          .get(Uri.https(baseUrl, '/api/dynamic/user-info/$id'), headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $jwtToken'
      });
      if (response.statusCode == 401) {
        throw InvalidTokenExceptionClass('token access expired');
      }

      var jsonData = jsonDecode(response.body);
      var user = User(
          jsonData['data']['user_id'],
          jsonData['data']['first_name'],
          jsonData['data']['last_name'],
          jsonData['data']['email']);

      return user;
    } on InvalidTokenExceptionClass catch (e) {
      await refreshAccessToken();
      return getUser(id);
      // Re-throwing the exception after handling it
    } catch (e, s) {
      print('inside getUserifo $e');
      print('Stack trace:\n $s');
      rethrow;
    }
  }

  Future getUserLogged() async {
    try {
      String? jwtToken = await getToken();

      var response = await http
          .get(Uri.https(baseUrl, '/api/auth/get-user-by-token/'), headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $jwtToken'
      });
      if (response.statusCode == 401) {
        throw InvalidTokenExceptionClass('token access expired');
      }

      var jsonData = jsonDecode(response.body);

      print(jsonData['user']['office_id']);

      // If user is admin
      if (jsonData['user']['office_id'] == 0) {
        return -1;
      }
      print('jsonData $jsonData');
      var user = User(
          jsonData['user']['user_id'],
          jsonData['user']['first_name'],
          jsonData['user']['last_name'],
          jsonData['user']['email']);

      box.write('selectedCity', jsonData['user']['office_id']);
      return user;
    } on InvalidTokenExceptionClass catch (e) {
      print('Caught an InvalidTokenExceptionClass: $e');
      await refreshAccessToken();
      return getUserLogged();
      // Re-throwing the exception after handling it
    } catch (e, s) {
      print('inside getUserLogged $e');
      print('Stack trace:\n $s');
      rethrow;
    }
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

      var response = await http.get(
          Uri.https(baseUrl, '/api/dynamic/posts-by-city/$officeId'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $jwtToken'
          });
      if (response.statusCode == 401) {
        throw InvalidTokenExceptionClass('token access expired');
      }

      print(response.statusCode);

      var jsonData = jsonDecode(response.body);

      // print('inside json data $jsonData');
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
          publication.price = eachPub['price'];
          await publication.getSubAreaName();
          publications.add(publication);
        }
      }
      //Sort for most recent first
      publications.sort((a, b) => b.datePost.compareTo(a.datePost));

      return publications;
    } on InvalidTokenExceptionClass catch (e) {
      print('Caught an InvalidTokenExceptionClass: $e');
      await refreshAccessToken();
      return getPosts();
      // Re-throwing the exception after handling it
    } catch (err, s) {
      print('inside get all posts $err');
      print('Stack trace:\n $s');
      rethrow; // rethrow the error if needed or handle it accordingly
    }
  }

  Future<List<Forum>> getForums() async {
    try {
      List<Forum> publications = [];
      int officeId = box.read('selectedCity');
      String? jwtToken = await getToken();

      var response = await http.get(
          Uri.https(baseUrl, '/api/dynamic/forums-by-city/${officeId}'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $jwtToken'
          });
      if (response.statusCode == 401) {
        throw InvalidTokenExceptionClass('token access expired');
      }
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
    } on InvalidTokenExceptionClass catch (e) {
      print('Caught an InvalidTokenExceptionClass: $e');
      await refreshAccessToken();
      return getForums();
      // Re-throwing the exception after handling it
    } catch (err, s) {
      print('isnide get all forums $err');
      print('Stack trace:\n $s');
      rethrow;
    }
  }

  Future<List<Event>> getEvents() async {
    try {
      List<Event> publications = [];
      int officeId = box.read('selectedCity');

      String? jwtToken = await getToken();

      var response = await http.get(
          Uri.https(baseUrl, '/api/dynamic/events-by-city/$officeId'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $jwtToken'
          });
      if (response.statusCode == 401) {
        throw InvalidTokenExceptionClass('token access expired');
      }
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
        User? adminUser = eachPub['admin_id'] != null
            ? await getUser(eachPub['admin_id'])
            : null;
        DateTime creationDate = DateTime.parse(eachPub['creation_date']);
        DateTime eventDate = DateTime.parse(eachPub['event_date']);
        // Create Event object
        final publication = Event(
            eachPub['event_id'],
            publisherUser,
            adminUser,
            eachPub['description'],
            eachPub['name'],
            eachPub['validated'],
            eachPub['sub_area_id'],
            creationDate,
            file,
            eachPub['eventLocation'],
            eventDate,
            eachPub['recurring'],
            eachPub['recurring_pattern']?.toString(),
            null,
            null);
        print('Object created -> ${publication.id}');
        await publication.getSubAreaName();
        publications.add(publication);
      }

      //Sort for most recent first
      publications.sort((a, b) => b.datePost.compareTo(a.datePost));

      return publications;
    } on InvalidTokenExceptionClass catch (e) {
      print('Caught an InvalidTokenExceptionClass: $e');
      await refreshAccessToken();
      return getEvents();
      // Re-throwing the exception after handling it
    } catch (e, s) {
      print('inside GetEvents');
      print(e);
      print('Stack trace:\n $s');
      rethrow;
    }
  }

  Future<List<Publication>> getAllPubsByArea(int areaId, String type) async {
    try {
      List<Publication> publications = [];
      int officeId = box.read('selectedCity');

      String? jwtToken = await getToken();

      var response = await http.get(
          Uri.https(baseUrl, '/api/dynamic/all-content-per/$officeId'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $jwtToken'
          });
      if (response.statusCode == 401) {
        throw InvalidTokenExceptionClass('token access expired');
      }
      var jsonData = jsonDecode(response.body);

      //Get all events
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
          } else if (type == 'forums' && eachPub['event_id'] == null) {
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
                eachPub['recurring'],
                eachPub['recurring_pattern'],
                null,
                null);
            await publication.getSubAreaName();
            publications.add(publication);
          }
        }
      }
      //Sort for most recent first
      publications.sort((a, b) => b.datePost.compareTo(a.datePost));

      return publications;
    } on InvalidTokenExceptionClass catch (e) {
      print('Caught an InvalidTokenExceptionClass: $e');
      await refreshAccessToken();
      return getAllPubsByArea(areaId, type);
      // Re-throwing the exception after handling it
    } catch (e, s) {
      print('inside GetAllPubsByArea');
      print('Stack trace:\n $s');
      rethrow;
    }
  }

  Future<List<Publication>> getAllPosts() async {
    try {
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
        print(' iside GetAllPost $e');
      }

      //Sort for most recent first
      pubs.sort((a, b) => b.datePost.compareTo(a.datePost));

      return pubs;
    }
    // Re-throwing the exception after handling it
    catch (e, s) {
      print('error in getAllPosts $e');
      print('Stack trace:\n $s');
      rethrow;
    }
  }

  Future<List<POI>> getAllPoI() async {
    try {
      List<POI> list = [];
      int officeId = box.read('selectedCity');
      String? jwtToken = await getToken();

      var response = await http.get(
          Uri.https(baseUrl, '/api/dynamic/all-content-per/$officeId'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $jwtToken'
          });
      if (response.statusCode == 401) {
        throw InvalidTokenExceptionClass('token access expired');
      }
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
    } on InvalidTokenExceptionClass catch (e) {
      print('Caught an InvalidTokenExceptionClass: $e');
      await refreshAccessToken();
      return getAllPoI();
      // Re-throwing the exception after handling it
    } catch (e, s) {
      print('error in getAllPoI $e');
      print('Stack trace:\n $s');
      rethrow;
    }
  }

  //This function is used everytime a user creates something with an image
  Future uploadPhoto(File img) async {
    String baseUrl = 'http://backendpint-w3vz.onrender.com/upload/upload';
    String? jwtToken = await getToken();

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
        if (response.statusCode == 401) {
          throw InvalidTokenExceptionClass('token access expired');
        }
        if (response.statusCode == 200) {
          print('File uploaded successfully');
          var data = jsonDecode(response.body);
          return data['file']['filename'];
        } else {
          print('Failed to upload file. Status code: ${response.statusCode}');
          print(response.body);
        }
      } on InvalidTokenExceptionClass catch (e) {
        print('Caught an InvalidTokenExceptionClass: $e');
        await refreshAccessToken();
        return uploadPhoto(img);
        // Re-throwing the exception after handling it
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

    try {
      var response =
          await http.post(Uri.https(baseUrl, '/api/post/create'), body: {
        'subAreaId': pub.subCategory.toString(),
        'officeId': office.toString(),
        'publisher_id': pub.user.id.toString(),
        'title': pub.title,
        'content': pub.desc,
        'filePath': path.toString(),
        'pLocation': pub.location.toString(),
        'price': pub.price.toString()
      }, headers: {
        'Authorization': 'Bearer $jwtToken'
      });
      if (response.statusCode == 401) {
        throw InvalidTokenExceptionClass('token access expired');
      }

      print(response.body);
      print(response.statusCode);
    } on InvalidTokenExceptionClass catch (e) {
      print('Caught an InvalidTokenExceptionClass: $e');
      await refreshAccessToken();
      return createPost(pub);
      // Re-throwing the exception after handling it
    } catch (e, s) {
      print('inside creating Post');
      print('Stack trace:\n $s');
      rethrow;
    }
  }

  // Create dynamic form related to specific event
  Future<void> createForm(int id, dynamic jsonData) async {
    String? jwtToken = await getToken();

    // Print raw and encoded JSON data for debugging
    print('Raw: $jsonData');
    print('Decode: ${jsonDecode(jsonData)}');
    print('Encode: ${jsonEncode(jsonData)}');

    try {
      // Ensure jsonData is a JSON-encoded string
      final jsonDataString = jsonEncode(jsonData);

      var response = await http.post(
        Uri.https(baseUrl, '/api/form/create-form'),
        headers: {
          'Authorization': 'Bearer $jwtToken',
          'Content-Type': 'application/json' // Set content type to JSON
        },
        body: jsonEncode(
            {'eventID': id.toString(), 'customFieldsJson': jsonDataString}),
      );

      // Print response information for debugging
      print('Dynamic form created successfully');
      print('Response: ${response.statusCode}');
      print('Response body: ${response.body}');
    } catch (e) {
      print('Something went wrong (createForm())');
      print('Error: $e');
    }
  }

  // Get specific form to event
  Future getForm(int id) async {
    String? jwtToken = await getToken();
    List<Field> formItens = [];
    var response = await http
        .get(Uri.https(baseUrl, '/api/form/event-form/$id'), headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $jwtToken'
    });
    // print('Response status: ${response.statusCode}');
    var jsonData = jsonDecode(response.body);
    print('FORM:');
    print(jsonData);
    for (var item in jsonData['data']) {
      List<String> options = [];
      if (item['field_type'] == 'Radio' || item['field_type'] == 'Checkbox') {
        for (var option in jsonDecode(item['field_value'])) {
          print(option);
          options.add(option.toString());
        }
      }
      Field field = Field(
          name: item['field_name'], type: item['field_type'], options: options);
      formItens.add(field);
    }

    return formItens;
  }

  Future createEvent(Event event) async {
    var office = box.read('selectedCity');
    String? jwtToken = await getToken();

    String? path;

    var recurring_aux = jsonEncode(event.recurring_path);

    if (event.img != null) {
      path = await uploadPhoto(event.img!);
    }
    try {
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
        'recurring': event.recurring.toString(),
        'recurring_pattern': recurring_aux
      }, headers: {
        'Authorization': 'Bearer $jwtToken'
      });
      if (response.statusCode == 401) {
        throw InvalidTokenExceptionClass('token access expired');
      }

      Map<String, dynamic> decodedJson = json.decode(response.body);
      int id = decodedJson['data'];
      print(id);
      return id;
    } on InvalidTokenExceptionClass catch (e) {
      print('Caught an InvalidTokenExceptionClass: $e');
      await refreshAccessToken();
      return createEvent(event);
      // Re-throwing the exception after handling it
    } catch (e, s) {
      print('create Event');
      print('Stack trace:\n $s');
      rethrow;
    }
  }

  Future createForum(Forum forum) async {
    var office = box.read('selectedCity');
    String? jwtToken = await getToken();

    try {
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
      if (response.statusCode == 401) {
        throw InvalidTokenExceptionClass('token access expired');
      }
      print(response.statusCode);
    } on InvalidTokenExceptionClass catch (e) {
      print('Caught an InvalidTokenExceptionClass: $e');
      await refreshAccessToken();
      return createForum(forum);
      // Re-throwing the exception after handling it
    } catch (e, s) {
      print('create Forum');
      print('Stack trace:\n $s');
      rethrow;
    }
  }

  Future createPOI(POI poi) async {
    var office = box.read('selectedCity');
    String? path;
    String? jwtToken = await getToken();

    if (poi.img != null) {
      path = await uploadPhoto(poi.img!);
    }

    try {
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
      if (response.statusCode == 401) {
        throw InvalidTokenExceptionClass('token access expired');
      }
      print(response.statusCode);
      print(response.body);
    } on InvalidTokenExceptionClass catch (e) {
      print('Caught an InvalidTokenExceptionClass: $e');
      await refreshAccessToken();
      return createPOI(poi);
      // Re-throwing the exception after handling it
    } catch (e, s) {
      print('create POI');
      print('Stack trace:\n $s');
      rethrow;
    }
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

      if (response.statusCode == 401) {
        throw InvalidTokenExceptionClass('token access expired');
      }

      var responseSub = await http
          .get(Uri.https(baseUrl, '/api/categories/get-sub-areas'), headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $jwtToken'
      });

      if (response.statusCode == 401) {
        throw InvalidTokenExceptionClass('token access expired');
      }

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
    } on InvalidTokenExceptionClass catch (e) {
      print('Caught an InvalidTokenExceptionClass: $e');
      await refreshAccessToken();
      return getAreas();
      // Re-throwing the exception after handling it
    } catch (e, s) {
      print('error inside gertAReas : $e');
      print('Stack trace:\n $s');
      rethrow;
    }
  }

  Future<String> getSubAreaName(int id) async {
    try {
      var result = '';
      String? jwtToken = await getToken();

      var response = await http
          .get(Uri.https(baseUrl, '/api/categories/get-sub-areas'), headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $jwtToken'
      });

      if (response.statusCode == 401) {
        throw InvalidTokenExceptionClass('token access expired');
      }
      var jsonData = jsonDecode(response.body);

      for (var area in jsonData['data']) {
        if (area['sub_area_id'] == id) {
          result = area['title'];
          break;
        }
      }
      return result;
    } on InvalidTokenExceptionClass catch (e) {
      print('Caught an InvalidTokenExceptionClass: $e');
      await refreshAccessToken();
      return getSubAreaName(id);
      // Re-throwing the exception after handling it
    } catch (e, s) {
      print('error in getSubAreaName $e');
      print('Stack trace:\n $s');
      rethrow;
    }
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
      if (response.statusCode == 401) {
        throw InvalidTokenExceptionClass('token access expired');
      }
      var jsonData = jsonDecode(response.body);

      for (var eachPub in jsonData['data']) {
        print(eachPub);
        var file = eachPub['filepath'] != null
            ? File(eachPub['filepath'])
            : null; // Check if event has image
        User publisherUser = await getUser(eachPub['publisher_id']); // Get user
        User? adminUser = eachPub['admin_id'] != null
            ? await getUser(eachPub['admin_id'])
            : null;
        DateTime creationDate = DateTime.parse(eachPub['creation_date']);
        DateTime eventDate = DateTime.parse(eachPub['event_date']);
        print('Pattern: ${eachPub['recurring_pattern'].toString()}');

        // Create Event object
        final publication = Event(
            eachPub['event_id'],
            publisherUser,
            adminUser,
            eachPub['description'],
            eachPub['name'],
            eachPub['validated'],
            eachPub['sub_area_id'],
            creationDate,
            file,
            eachPub['eventLocation'],
            eventDate,
            eachPub['recurring'],
            eachPub['recurring_pattern'].toString(),
            null,
            null);

        await publication.getSubAreaName();

        // Get event day with only date (year, month, day)
        DateTime eventDay =
            DateTime(eventDate.year, eventDate.month, eventDate.day);

        // Initialize List if not already initialized
        events[eventDay] ??= [];

        //Handle recurring events -> weekly
        if (publication.recurring_path == 'Weekly') {
          DateTime recurrenceDate = eventDate;

          // Add occurrences for a reasonable future range (e.g., 6 months)
          for (int i = 1; i <= 26; i++) {
            recurrenceDate = recurrenceDate.add(Duration(days: 7));
            if (recurrenceDate.year > DateTime.now().year + 1) break;

            DateTime recurrenceDay = DateTime(
                recurrenceDate.year, recurrenceDate.month, recurrenceDate.day);
            events[recurrenceDay] ??= [];
            events[recurrenceDay]!.add(publication);
          }
        }
        //Handle recurring events -> monthly
        else if (publication.recurring_path == 'Monthly') {
          DateTime recurrenceDate = eventDate;

          // Add occurrences for a reasonable future range (e.g., 6 months)
          for (int i = 1; i <= 6; i++) {
            recurrenceDate = recurrenceDate.add(Duration(days: 31));
            if (recurrenceDate.year > DateTime.now().year + 1) break;

            DateTime recurrenceDay = DateTime(
                recurrenceDate.year, recurrenceDate.month, recurrenceDate.day);
            events[recurrenceDay] ??= [];
            events[recurrenceDay]!.add(publication);
          }
        }

        // Add the publication to the list of events for that day
        events[eventDay]!.add(publication);
      }
      print(events.length);
      return events;
    } on InvalidTokenExceptionClass catch (e) {
      print('Caught an InvalidTokenExceptionClass: $e');
      await refreshAccessToken();
      return getEventCalendar();
      // Re-throwing the exception after handling it
    } catch (e, s) {
      print('Error fetching event data: $e');
      print('Stack trace:\n $s');
      return {};
    }
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
    try {
      String? jwtToken = await getToken();

      var response = await http.get(
          Uri.https(baseUrl,
              '/api/comment/get-comment-tree/content/$type/id/${pub.id}'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $jwtToken'
          });
      if (response.statusCode == 401) {
        throw InvalidTokenExceptionClass('token access expired');
      }
      var jsonData = jsonDecode(response.body);

      for (var comment in jsonData['data']) {
        User user = await getUser(comment['publisher_id']);
        comments[user] = comment['content'];
      }

      return comments;
    } on InvalidTokenExceptionClass catch (e) {
      print('Caught an InvalidTokenExceptionClass: $e');
      await refreshAccessToken();
      return getComents(pub);
      // Re-throwing the exception after handling it
    } catch (e, s) {
      print('error getting comments');
      print('Stack trace:\n $s');
      rethrow;
    }
  }

  Future createComment(Publication pub, String comment) async {
    late String type;

    switch (pub) {
      case Forum _:
        type = 'Forum';
        break;
      case Event _:
        type = 'Forum';
        break;
      default:
        type = 'Post';
    }
    try {
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
      if (response.statusCode == 401) {
        throw InvalidTokenExceptionClass('token access expired');
      }

      if (response.statusCode == 200) {
        // Handle successful response
        print('Comment created successfully');
      } else {
        // Handle error response
        print('Failed to create comment: ${response.body}');
      }
    } on InvalidTokenExceptionClass catch (e) {
      print('Caught an InvalidTokenExceptionClass: $e');
      await refreshAccessToken();
      return createComment(pub, comment);
      // Re-throwing the exception after handling it
    } catch (e, s) {
      print('error creating comment');
      print('Stack trace:\n $s');
      rethrow;
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
      var accessToken = jsonData['token'];
      var refreshToken = jsonData['refreshToken'];
      print('accessToken: $accessToken ');
      print('refreshToken: $refreshToken ');
      //decrypt the recieved token
      // var decryptedToken = await decryptToken(token);

      // //print('Decrypted TOKEN: $decryptedToken');
      // //decod decrypted token so the user_id can be accessed
      // final jwt = JWT.decode(decryptedToken);
      // final payload = jwt.payload;
      // print('Decoded TOKEN: ${payload}');
      // //get the user id from the payload
      // final _id = payload['id'];
      // //Get city
      //await getUserLogged(_id);
      //print('USER ID: $_id');
      // Store the JWT token
      await storage.write(key: 'jwt_token', value: jsonEncode(accessToken));
      await storage.write(
          key: 'jwt_refresh_token', value: jsonEncode(refreshToken));
      return accessToken;
    } else {
      // Handle error response
      print('Failed to log in: ${response.body}');
    }
  }

  Future<String?> getToken() async {
    return await storage.read(key: 'jwt_token');
  }

  Future<String?> getRefreshToken() async {
    return await storage.read(key: 'jwt_refresh_token');
  }

  Future<void> logout() async {
    await storage.delete(key: 'jwt_token');
  }

  //FIREBASE
  // Method to send the FCM token to the server
  Future<void> sendTokenToServer(String token) async {
    User? user = await bd.getUser();

    final response = await http.post(
      Uri.https(baseUrl, '/api/store-token'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'token': token,
        // Can also send user id or other necessary information here
        'userId': user!.id.toString(),
      }),
    );

    if (response.statusCode == 200) {
      print('Token stored successfully');
    } else {
      print('Failed to store token');
    }
  }
}
