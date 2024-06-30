import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:softshares/Pages/chooseCityPage.dart';
import 'package:softshares/Pages/settings.dart';
import 'package:softshares/classes/ClasseAPI.dart';
import 'package:softshares/classes/areaClass.dart';
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
  await GetStorage.init();

  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeNotifier(),
      child: MaterialApp(
        title: 'SoftShares',
        theme: ThemeNotifier().themeData,
        debugShowCheckedModeBanner: false,
        home: LoadingScreen(),
      ),
    ),
  );
}

class LoadingScreen extends StatelessWidget {
  final API api = API();

  Future<List<AreaClass>> _getAreas() async {
    var data = await api.getAreas();
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<AreaClass>>(
      future: _getAreas(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text('Error: ${snapshot.error}'),
            ),
          );
        } else if (snapshot.hasData) {
          return MyApp(areas: snapshot.data!);
        } else {
          return Scaffold(
            body: Center(
              child: Text('Unexpected error'),
            ),
          );
        }
      },
    );
  }
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
        Map<String, WidgetBuilder> routes = {
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
          '/createPost': (context) => createPost(areas: areas,),
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
        };

        for (var area in areas) {
          routes['/${area.areaName}'] = (context) => Area(
                title: area.areaName,
                areas: areas,
              );
        }

        return MaterialApp(
          title: 'SoftShares',
          theme: themeNotifier.themeData,
          debugShowCheckedModeBanner: false,
          initialRoute: '/home', //userId != null ? '/Login' : '/SignIn',
          routes: routes,
        );
      },
    );
  }
}
