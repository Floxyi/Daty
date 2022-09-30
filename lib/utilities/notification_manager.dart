import 'dart:io';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:daty/screens/birthday_info_page.dart';
import 'package:daty/utilities/Birthday.dart';
import 'package:daty/utilities/calculator.dart';
import 'package:flutter/material.dart';
import '../utilities/constants.dart';

bool hasAddedListener = false;

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
    channelGroups: [
      NotificationChannelGroup(
        channelGroupkey: 'basic_channel_group',
        channelGroupName: 'Basic group',
      )
    ],
  );
}

void requestNotificationAccess(BuildContext context) async {
  await AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
    if (!isAllowed) {
      if (Platform.isIOS) {
        AwesomeNotifications()
            .requestPermissionToSendNotifications()
            .then((value) => value ? addNotificationListener(context) : null);
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
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 18,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  AwesomeNotifications()
                      .requestPermissionToSendNotifications()
                      .then(
                    (value) {
                      value ? addNotificationListener(context) : null;
                      Navigator.pop(context);
                    },
                  );
                },
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
  });
}

void disposeNotificationSystem() {
  AwesomeNotifications().actionSink.close();
  AwesomeNotifications().createdSink.close();
}

void addNotificationListener(BuildContext context) {
  if (hasAddedListener) {
    return;
  }

  AwesomeNotifications().actionStream.listen((notification) {
    if (Platform.isIOS) {
      AwesomeNotifications().getGlobalBadgeCounter().then(
          (value) => AwesomeNotifications().setGlobalBadgeCounter(value - 1));
    }

    if (notification.channelKey == 'scheduled_channel') {
      int id = int.parse(notification.payload!.entries.first.value);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return BirthdayInfoPage(id);
          },
        ),
      );
    }
  });

  hasAddedListener = true;
}

Future<void> createNotification(Birthday birthday) async {
  String name = birthday.name;
  int age = Calculator.calculateAge(birthday.date);

  await AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: birthday.notificationId,
      channelKey: 'scheduled_channel',
      title: "It's birthday time! ${Emojis.smile_partying_face}",
      body: name + " just turned " + age.toString() + "!",
      notificationLayout: NotificationLayout.Default,
      payload: {"id": birthday.birthdayId.toString()},
    ),
    actionButtons: [
      NotificationActionButton(
        key: 'MARK_DONE',
        label: 'Open Birthday',
      ),
    ],
    schedule: NotificationCalendar(
      month: birthday.date.month,
      day: birthday.date.day,
      hour: birthday.date.hour,
      minute: birthday.date.minute,
      second: 0,
      millisecond: 0,
      repeats: true,
      allowWhileIdle: true,
      preciseAlarm: true,
    ),
  );
}

int getNewNotificationId() {
  return DateTime.now().millisecondsSinceEpoch.remainder(100000);
}
