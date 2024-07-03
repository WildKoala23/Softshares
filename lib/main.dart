import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:softshares/Pages/chooseCityPage.dart';
import 'package:softshares/Pages/postsPage.dart';
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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  SQLHelper db = SQLHelper.instance;

  List<AreaClass> areas = await db.getAreas();

  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeNotifier(),
      child: MyApp(
        areas: areas,
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  MyApp({super.key, required this.areas});
  final List<AreaClass> areas;
  final box = GetStorage();

  int? get userId => box.read('userId');

  @override
  Widget build(BuildContext context) {
    box.write('selectedCity', 1);

    return Consumer<ThemeNotifier>(
      builder: (context, themeNotifier, child) {
        return MaterialApp(
          title: 'SoftShares',
          theme: themeNotifier.themeData,
          debugShowCheckedModeBanner: false,
          initialRoute: '/home', //userId != null ? '/home' : '/SignIn',
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
            '/SignUp': (context) => const SignUp(),
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
