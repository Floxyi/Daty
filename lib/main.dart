import 'package:daty/screens/home_page.dart';
import 'package:daty/screens/settings_page.dart';
import 'package:flutter/material.dart';
import 'utilities/constants.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

void main() {
  AwesomeNotifications().initialize(
    null,
    [
      NotificationChannel(
        channelGroupKey: 'scheduled_channel_group',
        channelKey: 'scheduled_channel',
        channelName: 'Scheduled Notifications',
        channelDescription: 'Notification channel for basic notifications',
        defaultColor: Constants.bluePrimary,
        importance: NotificationImportance.High,
        channelShowBadge: true,
      )
    ],
    // Channel groups are only visual and are not required
    channelGroups: [
      NotificationChannelGroup(
          channelGroupkey: 'basic_channel_group',
          channelGroupName: 'Basic group')
    ],
  );

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
