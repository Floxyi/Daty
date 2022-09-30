import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:daty/utilities/constants.dart';
import 'package:daty/utilities/notification_manager.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FutureBuilder(
          future: AwesomeNotifications().isNotificationAllowed(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (!(snapshot.data as bool)) {
                return infoText();
              }
            }
            return Container();
          },
        ),
        Container(
          margin: const EdgeInsets.only(right: 50, left: 50),
          child: Column(
            children: [
              Container(),
            ],
          ),
        ),
      ],
    );
  }

  Widget infoText() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Container(
        decoration: BoxDecoration(
          color: Constants.darkGreySecondary,
          borderRadius: BorderRadius.all(Radius.circular(5)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Please allow us to send you birthday notifications.',
                  //'test',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Constants.lighterGrey,
                    fontSize: Constants.smallerFontSize + 2,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: (() {
                    requestNotificationAccess(context);
                  }),
                  child: const Text(
                    'Activate',
                    style: const TextStyle(
                      fontSize: Constants.smallerFontSize + 2,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
