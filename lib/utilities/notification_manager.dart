import 'dart:io';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:daty/screens/birthday_info_page.dart';
import 'package:daty/utilities/calculator.dart';
import 'package:flutter/material.dart';
import '../utilities/constants.dart';

void requestAccess(BuildContext context) {
  AwesomeNotifications().isNotificationAllowed().then(
    (isAllowed) {
      if (!isAllowed) {
        if (Platform.isIOS) {
          AwesomeNotifications().requestPermissionToSendNotifications();
        } else {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Allow Notifications'),
              content: Text(
                'Our app would like to send you notifications to let you know whenever someone has birthday.',
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Don\'t Allow',
                    style: TextStyle(color: Colors.grey, fontSize: 18),
                  ),
                ),
                TextButton(
                  onPressed: () => AwesomeNotifications()
                      .requestPermissionToSendNotifications()
                      .then((_) => Navigator.pop(context)),
                  child: Text(
                    'Allow',
                    style: TextStyle(
                      color: Colors.teal,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      }
    },
  );
}

void initializeNotificationSystem() async {
  await AwesomeNotifications().initialize(
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
        channelGroupName: 'Basic group',
      )
    ],
  );
}

void disposeNotificationSystem() {
  AwesomeNotifications().actionSink.close();
  AwesomeNotifications().createdSink.close();
}

void addNotificationListener(Navigator navigator, BuildContext context) {
  AwesomeNotifications().actionStream.listen((notification) {
    if (notification.channelKey == 'scheduled_channel') {
      if (Platform.isIOS) {
        AwesomeNotifications().getGlobalBadgeCounter().then(
              (value) =>
                  AwesomeNotifications().setGlobalBadgeCounter(value - 1),
            );
      }
      int id = int.parse(notification.payload!.entries.first.value);
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        // return BirthdayInfoPage(id, "test", DateTime.now());
      }));
    }
  });
}

Future<void> createBirthdayReminderNotification(
  int id,
  DateTime birthday,
  String personName,
) async {
  await AwesomeNotifications().createNotification(
    content: NotificationContent(
        id: createUniqueId(),
        channelKey: 'scheduled_channel',
        title: "It's birthday time! ${Emojis.smile_partying_face}",
        body: personName +
            " just turned " +
            Calculator.calculateAge(birthday).toString() +
            "!",
        notificationLayout: NotificationLayout.Default,
        payload: {"id": id.toString()}),
    actionButtons: [
      NotificationActionButton(
        key: 'MARK_DONE',
        label: 'Open Birthday',
      ),
    ],
    /*
    schedule: NotificationCalendar(
      month: birthday.month,
      day: birthday.day,
      hour: birthday.hour,
      minute: birthday.minute,
      second: 0,
      millisecond: 0,
      repeats: true,
      allowWhileIdle: true,
      preciseAlarm: true,
    ),
    */
    schedule: NotificationCalendar(
      month: DateTime.now().month,
      day: DateTime.now().day,
      hour: DateTime.now().hour,
      minute: DateTime.now().minute + 1,
      second: 0,
      millisecond: 0,
      repeats: true,
      allowWhileIdle: true,
      preciseAlarm: true,
    ),
  );
}

int createUniqueId() {
  return DateTime.now().millisecondsSinceEpoch.remainder(100000);
}
