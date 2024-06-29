import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:softshares/Pages/chooseCityPage.dart';
import 'package:softshares/Pages/settings.dart';
import 'classes/ThemeNotifier.dart';
import 'Pages/homepage.dart';
import 'Pages/area.dart';
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
  //Replace with BD
  List<String> areas = [
    'Education',
    'Gastronomy',
    'Health',
    'Housing',
    'Leisure',
    'Sports',
    'Transports'
  ];

  await GetStorage.init();
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
  final List<String> areas;
  final box = GetStorage();

  int? get userId => box.read('userId');

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
      builder: (context, themeNotifier, child) {
        Map<String, WidgetBuilder> routes = {
          '/home': (context) => const MyHomePage(),
          '/PointOfInterest': (context) => PointsOfInterest(),
          '/Calendar': (context) => Calendar(),
          '/Profile': (context) => const MyProfile(),
          '/Editprofile': (context) => EditProfile(),
          '/Login': (context) => MyLoginIn(userID: userId!),
          '/SignIn': (context) => const SignIn(),
          '/SignUp': (context) => const SignUp(),
          '/createPost': (context) => createPost(),
          '/createForm': (context) => createForm(),
          '/createRadioBtnForm': (context) => customRadioBtnForm(),
          '/createFieldTextForm': (context) => customFieldtextForm(),
          '/createCheckboxForm': (context) => customCheckboxForm(),
          '/notifications': (context) => Notifications(),
          '/settings': (context) => SettingsPage(),
          '/chooseCity': (context) => ChooseCityPage(),
          '/test': (context) => test()
        };

        for (var area in areas) {
          routes['/$area'] = (context) => Area(title: area);
        }

        return MaterialApp(
          title: 'SoftShares',
          theme: themeNotifier.themeData,
          debugShowCheckedModeBanner: false,
          initialRoute:userId != null ? '/Login' : '/SignIn',
          routes: routes,
        );
      },
    );
  }
}
