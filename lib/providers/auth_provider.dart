import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_storage/get_storage.dart';
import 'package:softshares/classes/ClasseAPI.dart';
import 'package:softshares/classes/user.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:crypto/crypto.dart';
import 'package:softshares/classes/db.dart';
import 'package:softshares/classes/areaClass.dart';

class AuthProvider with ChangeNotifier {
  final FlutterSecureStorage storage = FlutterSecureStorage();
  final box = GetStorage();
  User? _user;
  bool _isLoggedIn = false;
  List<AreaClass> _areas = [];
  Map<String, int> _cities = {};
  SQLHelper bd = SQLHelper.instance;
  API api = API();
  User? get user => _user;
  bool get isLoggedIn => _isLoggedIn;
  List<AreaClass> get areas => _areas;
  Map<String, int> get cities => _cities;

  //Sets the value to the opposite
  void setIsLogged() {
    _isLoggedIn = !_isLoggedIn;
  }

  Future login(String email, String password, bool keepSign) async {
    var accessToken = await api.logInDb(email, password); // Example API call
    _isLoggedIn = true;

    var user = await api.getUserLogged();
    //If getUserLogged() returns -1, it means the user is admin
    if (user == -1) {
      return -1;
    }
    _user = user;

    // If checkbox is selected
    if(keepSign){
      await bd.insertUser(user!.firstname, user.id, user.lastName, user.email);
    }

    // Load areas and cities data
    await loadAreasAndCities();
    notifyListeners();
    return accessToken;
  }

  Future<void> logout() async {
    _user = null;
    _isLoggedIn = false;

    // Clear stored user data
    await storage.deleteAll();

    notifyListeners();
  }

  Future setUser() async {
    try {
      _user = await bd.getUser();
    } catch (e) {
      _user = null;
    }
  }

  Future<void> checkLoginStatus() async {
    String? jwtToken = await api.getToken();
    if (jwtToken != null) {
      // Retrieve other user data
      _isLoggedIn = true;
    } else {
      _isLoggedIn = false;
    }

    notifyListeners();
  }

  Future<void> loadAreasAndCities() async {
    SQLHelper db = SQLHelper.instance;
    _areas = await db.getAreas();
    _cities = await db.getCities();
  }
}
