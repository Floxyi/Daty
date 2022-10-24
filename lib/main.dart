import 'package:daty/screens/home_page.dart';
import 'package:daty/screens/settings_page.dart';
import 'package:daty/utilities/birthday_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'utilities/constants.dart';
import 'utilities/notification_manager.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  initializeNotificationSystem();
  await loadBirthdays().then((value) => FlutterNativeSplash.remove());

  runApp(const MaterialApp(
    home: DatyApp(),
    title: "Daty",
    debugShowCheckedModeBanner: false,
    initialRoute: '/',
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
    disposeNotificationSystem();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.blackPrimary,
      appBar: appBar(),
      body: DatyApp.pageIndex == 0 ? const HomePage() : const SettingsPage(),
      bottomNavigationBar: bottomNavigationBar(),
    );
  }

  AppBar appBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Constants.blackPrimary,
      title: Text(
        DatyApp.pageIndex == 0 ? 'Birthdays' : 'Settings',
        style: const TextStyle(
          color: Constants.bluePrimary,
          fontSize: Constants.titleFontSizeSize,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  BottomNavigationBar bottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: DatyApp.pageIndex,
      type: BottomNavigationBarType.fixed,
      backgroundColor: Constants.blackPrimary,
      selectedItemColor: Constants.bluePrimary,
      unselectedItemColor: Constants.whiteSecondary,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(
            Icons.home,
          ),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.settings,
          ),
          label: 'Settings',
        ),
      ],
      onTap: (int index) {
        setState(() {
          DatyApp.pageIndex = index;
        });
      },
    );
  }
}
