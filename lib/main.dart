import 'package:flutter/material.dart';
import 'package:softshares/Pages/area.dart';
import 'package:softshares/Pages/MyProfile.dart';
import 'package:softshares/Pages/calendar.dart';
import 'package:softshares/Pages/createCheckboxForm.dart';
import 'package:softshares/Pages/createFrom.dart';
import 'package:softshares/Pages/customFieldTextForm.dart';
import 'package:softshares/Pages/customRadioBtnForm.dart';
import 'package:softshares/Pages/editProfile.dart';
import 'package:softshares/Pages/login.dart';
import 'package:softshares/Pages/pointsOfInterest.dart';
import 'package:softshares/Pages/signIn.dart';
import 'package:softshares/Pages/signup.dart';
import 'package:softshares/test.dart';
import './Pages/homepage.dart';

const lightColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: Color(0xff80ADD7),
  onPrimary: Colors.white,
  secondary: Color(0xff00C2FF),
  onSecondary: Colors.black,
  error: Colors.red,
  onError: Colors.white,
  background: Colors.white,
  onBackground: Colors.black,
  surface: Color(0xFFFEF7FF),
  onSurface: Colors.black,
  onTertiary: Color(0xFF49454F),
  
);

void main() {
  List<String> areas = [
    'Education',
    'Gastronomy',
    'Health',
    'Housing',
    'Leisure',
    'Sports',
    'Transports'
  ];

  runApp(MyApp(
    areas: areas,
  ));
}

class MyApp extends StatelessWidget {
  final List<String> areas;

  const MyApp({super.key, required this.areas});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Map<String, WidgetBuilder> routes = {
      '/home': (context) => const MyHomePage(),
      '/PointOfInterest': (context) => PointsOfInterest(),
      '/Calendar': (context) => Calendar(),
      '/Profile': (context) => const MyProfile(),
      '/Editprofile': (context) => EditProfile(),
      '/Login': (context) => const MyLoginIn(username: 'Gui'),
      '/SignIn': (context) => const SignIn(),
      '/SignUp': (context) => const SignUp(),
      '/createForm': (context) => createForm(),
      '/createRadioBtnForm': (context) => customRadioBtnForm(),
      '/createFieldTextForm': (context) => customFieldtextForm(),
      '/createCheckboxForm': (context) => customCheckboxForm(),
      '/test': (context) => test()
    };

    for (var area in areas) {
      routes['/$area'] = (context) => Area(title: area);
    }

    return MaterialApp(
      title: 'SoftShares',
      theme: ThemeData(
          brightness: Brightness.light, colorScheme: lightColorScheme),
      debugShowCheckedModeBanner: false,
      initialRoute: '/Login',
      routes: routes,
      home: const MyHomePage(),
    );
  }
}
