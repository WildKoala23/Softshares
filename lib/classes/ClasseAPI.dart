import 'dart:convert';
import 'package:softshares/classes/areaClass.dart';
import 'package:softshares/classes/event.dart';
import './usableIcons.dart';
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
    }
    for (var eachPub in jsonData['forums']) {
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

  Future<bool> createPost(Publication pub) async {
    var office = box.read('selectedCity');
    print('HERE');
    var response =
        await http.post(Uri.https(baseUrl, '/api/post/create'), body: {
      'subAreaId': pub.subCategory.toString(),
      'officeId': office.toString(),
      'publisher_id': pub.user.id.toString(),
      'title': pub.title,
      'content': pub.desc,
    });

    print(response.statusCode);

    return true;
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
}
