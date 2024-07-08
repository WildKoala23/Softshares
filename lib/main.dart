import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:softshares/Pages/chooseCityPage.dart';
import 'package:softshares/Pages/pubsPages/postsPage.dart';
import 'package:softshares/Pages/settings.dart';
import 'package:softshares/classes/ClasseAPI.dart';
import 'package:softshares/classes/areaClass.dart';
import 'package:softshares/classes/db.dart';
import 'classes/ThemeNotifier.dart';
import 'Pages/homepage.dart';
import 'Pages/MyProfile.dart';
import 'Pages/calendar.dart';
import 'Pages/createCheckboxForm.dart';
import 'Pages/createForm.dart';
import 'Pages/createPub.dart';
import 'Pages/customFieldTextForm.dart';
import 'Pages/customRadioBtnForm.dart';
import 'Pages/editProfile.dart';
import 'Pages/login.dart';
import 'Pages/notifications.dart';
import 'Pages/pointsOfInterest.dart';
import 'Pages/signIn.dart';
import 'Pages/signup.dart';
import 'test.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

final storage = FlutterSecureStorage();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();

  SQLHelper db = SQLHelper.instance;

  List<AreaClass> areas = await db.getAreas();
  Map<String, int> cities = await db.getCities();

  // Print current directory and its contents
  // Directory currentDir = Directory.current;
  // print('Current directory: ${currentDir.path}');
  // List<FileSystemEntity> files = currentDir.listSync();
  // for (var file in files) {
  //   print(file.path);
  // }

  try {
    await dotenv.load(fileName: ".env");
    runApp(
      ChangeNotifierProvider(
        create: (_) => ThemeNotifier(),
        child: MyApp(
          areas: areas,
          cities: cities,
        ),
      ),
    );
  } catch (e) {
    print('Error loading .env file: $e');
  }
}

class MyApp extends StatelessWidget {
  MyApp({super.key, required this.areas, required this.cities});
  final List<AreaClass> areas;
  final Map<String, int> cities;
  final box = GetStorage();

  int? get userId => box.read('userId');

  @override
  Widget build(BuildContext context) {

    return Consumer<ThemeNotifier>(
      builder: (context, themeNotifier, child) {
        return MaterialApp(
          title: 'SoftShares',
          theme: themeNotifier.themeData,
          debugShowCheckedModeBanner: false,
          initialRoute: userId != null ? '/Login' : '/SignIn',
          routes: {
            '/home': (context) => MyHomePage(
                  areas: areas,
                ),
            '/PointOfInterest': (context) => PointsOfInterest(
                  areas: areas,
                ),
            '/Calendar': (context) => Calendar(
                  areas: areas,
                ),
            '/Profile': (context) => MyProfile(
                  areas: areas,
                ),
            '/Editprofile': (context) => EditProfile(
                  areas: areas,
                ),
            '/Login': (context) => MyLoginIn(userID: userId!),
            '/SignIn': (context) => const SignIn(),
            '/SignUp': (context) => SignUp(
                  cities: cities,
                ),
            '/createPost': (context) => createPost(
                  areas: areas,
                ),
            '/createForm': (context) => createForm(),
            '/createRadioBtnForm': (context) => customRadioBtnForm(),
            '/createFieldTextForm': (context) => customFieldtextForm(),
            '/createCheckboxForm': (context) => customCheckboxForm(),
            '/notifications': (context) => Notifications(
                  areas: areas,
                ),
            '/settings': (context) => SettingsPage(),
            '/chooseCity': (context) => ChooseCityPage(),
            '/test': (context) => test(),
          },
        );
      },
    );
  }
}
