import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:softshares/Pages/settings.dart';
import 'Pages/classes/ThemeNotifier.dart';
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

  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeNotifier(),
      child: MyApp(areas: areas),
    ),
  );
}

class MyApp extends StatelessWidget {
  final List<String> areas;

  const MyApp({super.key, required this.areas});

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
          '/Login': (context) => const MyLoginIn(username: 'Gui'),
          '/SignIn': (context) => const SignIn(),
          '/SignUp': (context) => const SignUp(),
          '/createPost': (context) => createPost(),
          '/createForm': (context) => createForm(),
          '/createRadioBtnForm': (context) => customRadioBtnForm(),
          '/createFieldTextForm': (context) => customFieldtextForm(),
          '/createCheckboxForm': (context) => customCheckboxForm(),
          '/notifications': (context) => Notifications(),
          '/settings': (context) => SettingsPage(),
          '/test': (context) => test()
        };

        for (var area in areas) {
          routes['/$area'] = (context) => Area(title: area);
        }

        return MaterialApp(
          title: 'SoftShares',
          theme: themeNotifier.themeData,
          debugShowCheckedModeBanner: false,
          initialRoute: '/Login',
          routes: routes,
          home: const MyHomePage(),
        );
      },
    );
  }
}
