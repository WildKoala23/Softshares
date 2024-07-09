import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:softshares/Pages/chooseCityPage.dart';
import 'package:softshares/Pages/pubsPages/postsPage.dart';
import 'package:softshares/Pages/settings.dart';
import 'package:softshares/classes/ClasseAPI.dart';
import 'package:softshares/classes/areaClass.dart';
import 'package:softshares/classes/db.dart';
import 'package:softshares/classes/user.dart';
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
import 'package:softshares/providers/auth_provider.dart';

final storage = FlutterSecureStorage();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await dotenv.load(fileName: ".env");
  SQLHelper db = SQLHelper.instance;
  User? user;
  bool logged;
  try {
    user = await db.getUser();
    if (user != null) {
      logged = true;
    } else {
      logged = false;
    }
  } catch (e) {
    print(e);
    logged = false;
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeNotifier()),
      ],
      child: MyApp(
        logged: logged,
        user: user,
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  MyApp({super.key, required this.logged, required this.user});
  bool logged;
  User? user;
  @override
  Widget build(BuildContext context) {
    return Consumer2<ThemeNotifier, AuthProvider>(
      builder: (context, themeNotifier, authProvider, child) {
        return MaterialApp(
          title: 'SoftShares',
          theme: themeNotifier.themeData,
          debugShowCheckedModeBanner: false,
          initialRoute: logged == true ? '/Login' : '/SignIn',
          routes: {
            '/home': (context) => MyHomePage(areas: authProvider.areas),
            '/PointOfInterest': (context) =>
                PointsOfInterest(areas: authProvider.areas),
            '/Calendar': (context) => Calendar(areas: authProvider.areas),
            '/Profile': (context) => MyProfile(
                  areas: authProvider.areas,
                  user: authProvider.user!,
                ),
            '/Editprofile': (context) => EditProfile(areas: authProvider.areas),
            '/Login': (context) => MyLoginIn(user: user!),
            '/SignIn': (context) => const SignIn(),
            '/SignUp': (context) => SignUp(cities: authProvider.cities),
            '/createPost': (context) => createPost(areas: authProvider.areas),
            '/createForm': (context) => createForm(),
            '/createRadioBtnForm': (context) => customRadioBtnForm(),
            '/createFieldTextForm': (context) => customFieldtextForm(),
            '/createCheckboxForm': (context) => customCheckboxForm(),
            '/notifications': (context) =>
                Notifications(areas: authProvider.areas),
            '/settings': (context) => SettingsPage(),
            '/chooseCity': (context) => ChooseCityPage(),
            '/test': (context) => test(),
          },
        );
      },
    );
  }
}
