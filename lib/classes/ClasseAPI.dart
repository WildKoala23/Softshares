import 'dart:convert';
import 'dart:io';
import 'package:softshares/classes/areaClass.dart';
import 'package:softshares/classes/event.dart';
import 'utils.dart';
import '../classes/POI.dart';
import '../classes/forums.dart';
import '../classes/user.dart';
import '../classes/publication.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';

class API {
  var baseUrl = 'backendpint-w3vz.onrender.com';
  final box = GetStorage();

  Future<User> getUser(int id) async {
    var response =
        await http.get(Uri.https(baseUrl, '/api/dynamic//user-info/$id'));

    var jsonData = jsonDecode(response.body);

    var user = User(jsonData['data']['user_id'], jsonData['data']['first_name'],
        jsonData['data']['last_name'], jsonData['data']['email']);

    return user;
  }

  Future<List<Publication>> getAllPosts() async {
    List<Publication> publications = [];

    var response =
        await http.get(Uri.https(baseUrl, '/api/dynamic/all-content'));

    var jsonData = jsonDecode(response.body);

    for (var eachPub in jsonData['posts']) {
      User publisherUser = await getUser(eachPub['publisher_id']);
      var file;
      if (eachPub['filepath'] != null) {
        file = File(eachPub['filepath']);
      } else {
        file = null;
      }
      final publication = Publication(
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
    for (var eachPub in jsonData['forums']) {
      if (eachPub['event_id'] == null) {
        User publisherUser = await getUser(eachPub['publisher_id']);
        final publication = Forum(
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
    for (var eachPub in jsonData['events']) {
      var file;
      if (eachPub['filepath'] != null) {
        file = File(eachPub['filepath']);
      } else {
        file = null;
      }
      User publisherUser = await getUser(eachPub['publisher_id']);
      final publication = Event(
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
      int roundedAreaId = (eachPub['sub_area_id'] / 10).round();
      if (roundedAreaId == areaId) {
        User publisherUser = await getUser(eachPub['publisher_id']);
        if (type == 'posts') {
          final publication = Publication(
            publisherUser,
            null,
            eachPub['content'],
            eachPub['title'],
            eachPub['validated'],
            eachPub['sub_area_id'],
            DateTime.parse(eachPub['creation_date']),
            eachPub['filepath'],
            eachPub['p_location'],
          );
          await publication.getSubAreaName();
          publications.add(publication);
        } else if (type == 'forums') {
          final publication = Forum(
              publisherUser,
              null,
              eachPub['content'],
              eachPub['title'],
              eachPub['validated'],
              eachPub['sub_area_id'],
              DateTime.parse(eachPub['creation_date']));
          await publication.getSubAreaName();
          publications.add(publication);
        } else {
          final publication = Event(
              publisherUser,
              null,
              eachPub['description'],
              eachPub['name'],
              eachPub['validated'],
              eachPub['sub_area_id'],
              DateTime.parse(eachPub['creation_date']),
              eachPub['filepath'],
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

  Future<List<POI>> getAllPoI() async {
    List<POI> list = [];

    var response =
        await http.get(Uri.https(baseUrl, '/api/dynamic/all-content'));

    var jsonData = jsonDecode(response.body);

    for (var eachPub in jsonData['posts']) {
      if (eachPub['type'] == 'P') {
        User publisherUser = await getUser(eachPub['publisher_id']);
        final publication = POI(
          publisherUser,
          null,
          eachPub['content'],
          eachPub['title'],
          eachPub['validated'],
          eachPub['sub_area_id'],
          DateTime.parse(eachPub['creation_date']),
          eachPub['filepath'],
          eachPub['p_location'],
          3,
        );
        await publication.getSubAreaName();
        list.add(publication);
      }
    }
    return list;
  }

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
        // Send the request
        final streamedResponse = await request.send();

        // Get the response
        final response = await http.Response.fromStream(streamedResponse);

        // Check the response status
        if (response.statusCode == 200) {
          print('File uploaded successfully');
          var data = jsonDecode(response.body);
          print(data['file']);
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
      'filePath': path
    });
  }

  Future createEvent(Event event) async {
    var office = box.read('selectedCity');

    String? path;

    if (event.img != null) {
      path = await uploadPhoto(event.img!);
      print('Path: $path');
    }

    var response =
        await http.post(Uri.https(baseUrl, '/api/event/create'), body: {
      'subAreaId': event.subCategory.toString(),
      'officeId': office.toString(),
      'publisher_id': event.user.id.toString(),
      'name': event.title,
      'description': event.desc,
      'filepath': path,
      'eventDate':
          event.eventDate.toIso8601String(), //Convert DateTime to string
      'location': 'somewhere',
    });

    print(response.statusCode);
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
      print('Path: $path');
    }

    var response =
        await http.post(Uri.https(baseUrl, '/api/post/create'), body: {
      'subAreaId': poi.subCategory.toString(),
      'officeId': office.toString(),
      'publisher_id': poi.user.id.toString(),
      'title': poi.title,
      'content': poi.desc,
      'type': 'P',
      'filePath': path
    });
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
}
