import 'dart:io';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:daty/screens/home_page.dart';
import 'package:daty/utilities/birthday_data.dart';
import 'package:daty/utilities/notification_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  initializeNotificationSystem();
  await loadBirthdays().then((value) => FlutterNativeSplash.remove());

  runApp(MaterialApp(
    home: const DatyApp(),
    title: "Daty",
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: const [
      Locale('en', ''),
      Locale('de', ''),
    ],
    debugShowCheckedModeBanner: false,
    initialRoute: '/',
    navigatorKey: navigatorKey,
  ));
}

class DatyApp extends StatefulWidget {
  const DatyApp({Key? key}) : super(key: key);

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
    if (Platform.isIOS) {
      AwesomeNotifications().getGlobalBadgeCounter().then((value) {
        return AwesomeNotifications().setGlobalBadgeCounter(value - 1);
      });
    }

    return const HomePage();
  }
}
