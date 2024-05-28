import 'package:flutter/material.dart';
import 'package:softshares/Pages/area.dart';
import 'package:softshares/Pages/MyProfile.dart';
import 'package:softshares/Pages/calendar.dart';
import 'package:softshares/Pages/createCheckboxForm.dart';
import 'package:softshares/Pages/createForm.dart';
import 'package:softshares/Pages/createPub.dart';
import 'package:softshares/Pages/customFieldTextForm.dart';
import 'package:softshares/Pages/customRadioBtnForm.dart';
import 'package:softshares/Pages/editProfile.dart';
import 'package:softshares/Pages/login.dart';
import 'package:softshares/Pages/notifications.dart';
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

// const lightColorScheme = ColorScheme(
//     brightness: Brightness.dark,
//     primary: Color.fromARGB(255, 50, 63,
//         75), // Light blue primary color remains the same for consistency
//     onPrimary: Colors.white, // Black text on light primary color
//     secondary: Color.fromARGB(
//         255, 80, 128, 143), // Light blue secondary color remains the same
//     onSecondary: Colors.white, // White text on light secondary color
//     error: Colors
//         .redAccent, // Slightly lighter red for error to stand out on dark background
//     onError: Colors.black, // Black text on red error color
//     background: Color(0xFF121212), // Dark background color
//     onBackground: Colors.white, // White text on dark background
//     surface: Color(0xFF1E1E1E), // Dark surface color
//     onSurface: Colors.white, // White text on dark surface
//     onTertiary: Color(0xFFCACACA));

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
      '/createPost': (context) => createPost(),
      '/createForm': (context) => createForm(),
      '/createRadioBtnForm': (context) => customRadioBtnForm(),
      '/createFieldTextForm': (context) => customFieldtextForm(),
      '/createCheckboxForm': (context) => customCheckboxForm(),
      '/notifications': (context) => Notifications(),
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
