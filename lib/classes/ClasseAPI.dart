import 'dart:convert';
import 'package:softshares/classes/areaClass.dart';
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
          DateTime.parse(eachPub['creation_date']));
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
      if (eachPub['type'] == 'P') {
        User publisherUser = await getUser(eachPub['publisher_id']);
        final publication = POI(
            publisherUser,
            null,
            eachPub['content'],
            eachPub['title'],
            eachPub['validated'],
            eachPub['sub_area_id'],
            DateTime.now(),
            3,
            null);
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
      'subAreaId': pub.subCategory,
      'officeId': office,
      'publisher_id': pub.user.id,
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
            id: subarea['area_id'],
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

  Future<List<AreaClass>> getSubareas(int areaId) async {
    List<AreaClass> list = [];
    var response =
        await http.get(Uri.https(baseUrl, '/api/categories/get-sub-areas'));

    var jsonData = jsonDecode(response.body);

    for (var area in jsonData['data']) {
      if (area['area_id'] == areaId) {
        var dummyArea = AreaClass(
          id: area['area_id'],
          areaName: area['title'],
        );
        list.add(dummyArea);
      }
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
