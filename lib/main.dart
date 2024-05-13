import 'package:flutter/material.dart';
import 'package:softshares/Pages/area.dart';
import 'package:softshares/Pages/MyProfile.dart';
import 'package:softshares/Pages/calendar.dart';
import 'package:softshares/Pages/createFrom.dart';
import 'package:softshares/Pages/editProfile.dart';
import 'package:softshares/Pages/login.dart';
import 'package:softshares/Pages/pointsOfInterest.dart';
import 'package:softshares/Pages/signIn.dart';
import 'package:softshares/Pages/signup.dart';
import './Pages/homepage.dart';
import 'package:google_fonts/google_fonts.dart';

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
      '/createFrom': (context) => createForm()
    };

    for (var area in areas) {
      routes['/$area'] = (context) => Area(title: area);
    }

    return MaterialApp(
      title: 'SoftShares',
      theme: ThemeData(
          textTheme: GoogleFonts.robotoTextTheme(), fontFamily: 'Roboto'),
      debugShowCheckedModeBanner: false,
      initialRoute: '/createFrom',
      routes: routes,
      home: const MyHomePage(),
    );
  }
}
