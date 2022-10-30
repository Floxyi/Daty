import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:daty/screens/home_page.dart';
import 'package:daty/screens/settings_page.dart';
import 'package:daty/utilities/birthday_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'utilities/constants.dart';
import 'utilities/notification_manager.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  initializeNotificationSystem();
  await loadBirthdays().then((value) => FlutterNativeSplash.remove());

  runApp(MaterialApp(
    home: DatyApp(),
    title: "Daty",
    debugShowCheckedModeBanner: false,
    initialRoute: '/',
    navigatorKey: navigatorKey,
  ));
}

class DatyApp extends StatefulWidget {
  const DatyApp({Key? key}) : super(key: key);

  static int pageIndex = 0;

  @override
  State<DatyApp> createState() => _DatyAppState();
}

class _DatyAppState extends State<DatyApp> {
  @override
  void dispose() {
    AwesomeNotifications().dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.blackPrimary,
      appBar: appBar(),
      body: DatyApp.pageIndex == 0
          ? const HomePage()
          : DatyApp.pageIndex == 1
              ? const SettingsPage()
              : const HomePage(),
      bottomNavigationBar: curvedNavigationBar(),
    );
  }

  AppBar appBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Constants.blackPrimary,
      title: Text(
        DatyApp.pageIndex == 0
            ? 'Birthdays'
            : DatyApp.pageIndex == 1
                ? 'Settings'
                : 'About',
        style: const TextStyle(
          color: Constants.bluePrimary,
          fontSize: Constants.titleFontSizeSize,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  CurvedNavigationBar curvedNavigationBar() {
    return CurvedNavigationBar(
      color: Constants.bluePrimary,
      backgroundColor: Constants.blackPrimary,
      items: <Widget>[
        Icon(Icons.home, size: 30),
        Icon(Icons.settings, size: 30),
        Icon(Icons.info, size: 30),
      ],
      onTap: (int index) {
        setState(() {
          DatyApp.pageIndex = index;
        });
      },
    );
  }
}
