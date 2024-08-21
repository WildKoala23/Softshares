import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:softshares/Pages/chooseCityPage.dart';
import 'package:softshares/Pages/recovery.dart';
import 'package:softshares/Pages/settings.dart';
import 'package:softshares/classes/db.dart';
import 'package:softshares/classes/user.dart';
import 'classes/ThemeNotifier.dart';
import 'Pages/homepage.dart';
import 'Pages/MyProfile.dart';
import 'Pages/calendar.dart';
import 'Pages/customCheckForm.dart';
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

import 'package:softshares/classes/ClasseAPI.dart';
//firebase
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'firebase_options.dart';

final storage = FlutterSecureStorage();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

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

  // Uncomment if you need to handle background messages
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeNotifier()),
        ChangeNotifierProvider(
          create: (_) => AuthProvider()..checkLoginStatus(),
        ),
      ],
      child: MyApp(
        logged: logged,
        user: user,
      ),
    ),
  );
}

// Uncomment if you need to handle background messages
// Background message handler
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Handling a background message: ${message.messageId}");
}

class MyApp extends StatefulWidget {
  MyApp({super.key, required this.logged, required this.user});
  bool logged;
  User? user;

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    initializeFCM();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<ThemeNotifier, AuthProvider>(
      builder: (context, themeNotifier, authProvider, child) {
        return MaterialApp(
          title: 'SoftShares',
          theme: themeNotifier.themeData,
          debugShowCheckedModeBanner: false,
          initialRoute: widget.logged == true ? '/Login' : '/SignIn',
          //initialRoute: '/test',
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
            '/Login': (context) => MyLoginIn(user: widget.user!),
            '/SignIn': (context) => const SignIn(),
            '/SignUp': (context) => SignUp(cities: authProvider.cities),
            '/createPost': (context) => createPost(areas: authProvider.areas),
            '/createRadioBtnForm': (context) => customRadioBtnForm(),
            '/createFieldTextForm': (context) => customFieldtextForm(),
            '/createCheckboxForm': (context) => customCheckboxForm(),
            '/notifications': (context) =>
                Notifications(areas: authProvider.areas),
            '/settings': (context) => SettingsPage(),
            '/chooseCity': (context) => ChooseCityPage(),
            '/recovery': (context) => Recovery(),
            '/test': (context) => test(),
          },
        );
      },
    );
  }
}

void initializeFCM() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  // Request permission to send notifications (necessary for iOS)
  await messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );
  API api = API();
  // Check if the token is already stored locally
  String? fcmtoken = api.retrieveToken();
  if (fcmtoken == null) {
    // If not, get a new token
    fcmtoken = await messaging.getToken();
    if (fcmtoken != null) {
      print("FCM Token: $fcmtoken");
      api.saveToken(fcmtoken);

      // Send this token to your server
      String userId = "yourUserId"; // Replace with the actual user ID

      await api.sendTokenToServer(fcmtoken);
    }
  } else {
    print("FCM Token retrieved from local storage: $fcmtoken");
    // Ensure the token is sent to the server even if it's retrieved locally
    await api.sendTokenToServer(fcmtoken);
  }

  // Listen for foreground messages
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print("Message received: ${message.notification?.title}");
    // Handle the message
  });

  // Handle notification clicks when the app is in the background or terminated
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    print('Message clicked!');
    // Navigate to a specific screen based on the message
  });
}
