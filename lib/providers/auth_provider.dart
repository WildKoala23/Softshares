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

  Future login(String email, String password) async {
    // Add your login logic here and retrieve the user
    var token = await api.logInDb(email, password); // Example API call
    _isLoggedIn = true;
    var decryptedToken = await decryptToken(token);

    //print('Decrypted TOKEN: $decryptedToken');
    //decod decrypted token so the user_id can be accessed
    final jwt = JWT.decode(decryptedToken);
    final payload = jwt.payload;
    print('Decoded TOKEN: $payload');
    //get the user id from the payload
    final id = payload['id'];
    //Get city
    User user = await api.getUserLogged(id);
    _user = user;
    //print('USER ID: $_id');
    // Store the JWT token
    // Save user data securely
    // await storage.write(key: 'logged_user', value: user.toString());

    await bd.insertUser(user.firstname, user.id, user.lastName, user.email);

    // Load areas and cities data
    await loadAreasAndCities();
    notifyListeners();
    return token;
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
