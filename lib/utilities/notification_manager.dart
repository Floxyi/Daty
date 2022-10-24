import 'dart:io';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:daty/screens/birthday_info_page.dart';
import 'package:daty/utilities/Birthday.dart';
import 'package:daty/utilities/birthday_data.dart';
import 'package:daty/utilities/calculator.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utilities/constants.dart';

bool addedNotificationListener = false;

bool notiOneWeekBefore = false;
bool notiOneMonthBefore = false;

void setNotiOneWeekBefore(value) {
  notiOneWeekBefore = value;

  for (int i = 0; i < birthdayList.length; i++) {
    if (notiOneWeekBefore) {
      createNotificationOneWeekBefore(birthdayList[i]);
    } else {
      AwesomeNotifications().cancel(birthdayList[i].notificationIds[1]);
    }
  }
}

void setNotiOneMonthBefore(value) {
  notiOneMonthBefore = value;

  for (int i = 0; i < birthdayList.length; i++) {
    if (notiOneMonthBefore) {
      createNotificationOneMonthBefore(birthdayList[i]);
    } else {
      AwesomeNotifications().cancel(birthdayList[i].notificationIds[2]);
    }
  }
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
    channelGroups: [
      NotificationChannelGroup(
        channelGroupkey: 'basic_channel_group',
        channelGroupName: 'Basic group',
      )
    ],
  );

  final prefs = await SharedPreferences.getInstance();

  bool? settingOneWeek = await prefs.getBool('notificationOneWeekBefore');
  if (settingOneWeek == null) {
    await prefs.setBool('notificationOneWeekBefore', false);
  } else {
    notiOneWeekBefore = settingOneWeek;
  }

  bool? settingOneMonth = await prefs.getBool('getNotificationOneMonthBefore');
  if (settingOneMonth == null) {
    await prefs.setBool('getNotificationOneMonthBefore', false);
  } else {
    notiOneMonthBefore = settingOneMonth;
  }
}

setNotificationOneWeekBefore(bool value) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool('notificationOneWeekBefore', value);
}

setNotificationOneMonthBefore(bool value) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool('getNotificationOneMonthBefore', value);
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
  if (addedNotificationListener) {
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

  addedNotificationListener = true;
}

Future<void> createNotifications(Birthday birthday) async {
  createNotification(birthday, birthday.date);

  if (notiOneWeekBefore) {
    createNotificationOneWeekBefore(birthday);
  }

  if (notiOneMonthBefore) {
    createNotificationOneMonthBefore(birthday);
  }
}

void createNotificationOneWeekBefore(Birthday birthday) {
  DateTime time = DateTime(
    birthday.date.year,
    birthday.date.month,
    birthday.date.day - 7,
    birthday.date.hour,
    birthday.date.minute,
  );

  createNotification(birthday, time);
}

void createNotificationOneMonthBefore(Birthday birthday) {
  DateTime time = DateTime(
    birthday.date.year,
    birthday.date.month - 1,
    birthday.date.day,
    birthday.date.hour,
    birthday.date.minute,
  );

  createNotification(birthday, time);
}

Future<void> createNotification(Birthday birthday, DateTime time) async {
  await AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: birthday.notificationIds[0],
      channelKey: 'scheduled_channel',
      title: "It's birthday time! ${Emojis.smile_partying_face}",
      body: birthday.name +
          " just turned " +
          Calculator.calculateAge(birthday.date).toString() +
          "!",
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
      month: time.month,
      day: time.day,
      hour: time.hour,
      minute: time.minute,
      second: 0,
      millisecond: 0,
      repeats: true,
      allowWhileIdle: true,
      preciseAlarm: true,
    ),
  );
}
