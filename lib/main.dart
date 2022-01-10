import 'package:firebase_core/firebase_core.dart';
import 'package:fisikamu/Pages/DetailsNotifikasi.dart';
import 'package:fisikamu/Pages/DetailsVideoMateri.dart';
import 'package:fisikamu/Pages/FormEditProfil.dart';
import 'package:fisikamu/Pages/HasilUjian.dart';
import 'package:fisikamu/Pages/HomeLayout.dart';
import 'package:fisikamu/Pages/Invoice.dart';
import 'package:fisikamu/Pages/Login.dart';
import 'package:fisikamu/Pages/NotificationList.dart';
import 'package:fisikamu/Pages/ProfilPage.dart';
import 'package:fisikamu/Pages/Register.dart';
import 'package:fisikamu/Pages/ShowSoal.dart';
import 'package:fisikamu/Pages/ShowsoalMirror.dart';
import 'package:fisikamu/Pages/SplashScreen.dart';
import 'package:fisikamu/Pages/SubBabList.dart';
import 'package:fisikamu/Provider/GlobalProvider.dart';
import 'package:fisikamu/Provider/ThemeProvider.dart';
import 'package:fisikamu/Provider/UserProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
// ignore: close_sinks
final BehaviorSubject<String?> selectNotificationSubject =
    BehaviorSubject<String?>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('app_icon');
  final IOSInitializationSettings initializationSettingsIOS =
      IOSInitializationSettings(
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false,
          onDidReceiveLocalNotification: (
            int id,
            String? title,
            String? body,
            String? payload,
          ) async {});
  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
  );
  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: (String? payload) async {
    if (payload != null) {
      debugPrint('notification payload: $payload');
    }
    selectNotificationSubject.add(payload);
  });
  await Firebase.initializeApp();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => UserProvider()),
      ChangeNotifierProvider(create: (context) => ThemeProvider()),
      ChangeNotifierProvider(create: (context) => GlobalProvider()),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fisikamu',
      theme: ThemeData(scaffoldBackgroundColor: Color(0xFFffffff)),
      initialRoute: '/splashScreen',
      debugShowCheckedModeBanner: false,
      routes: {
        '/splashScreen': (context) => SplashScreen(),
        '/login': (context) => Login(),
        '/home': (context) => HomeLayout(),
        '/register': (context) => Register(),
        '/subBab': (context) => SubBabList(),
        '/detailsVideoMateri': (context) => DetailsVideoMateri(),
        '/showSoal': (context) => ShowSoal(),
        '/showSoalMirror': (context) => ShowSoalMirror(),
        '/hasilUjian': (context) => HasilUjian(),
        '/profil': (context) => ProfilPage(),
        '/formEditProfil': (context) => FormEditProfil(),
        '/detailsNotif': (context) => DetailsNotifikasi(),
        '/notifList': (context) => NotificationList(),
        '/invoice': (context) => Invoice(),
      },
    );
  }
}
