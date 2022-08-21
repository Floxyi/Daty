import 'package:awesome_notifications/awesome_notifications.dart';

import 'notification_manager.dart';

var birthdayList = [
  /*
  [1, 'Florian', DateTime(2005, 6, 15, 23, 4)],
  [2, 'Liam', DateTime(2004, 7, 27)],
  [3, 'Jannes', DateTime(2004, 12, 9)],
  [4, 'Max', DateTime(2005, 2, 24)],
  [5, 'Colin', DateTime(2004, 11, 11)],
  [6, 'Vincent', DateTime(2004, 3, 14)],
  [7, 'Riley', DateTime(2000, 6, 13)],
  [8, 'Riley', DateTime(2000, 6, 13)],
  [9, 'Riley', DateTime(2000, 6, 13)],
  [
    10,
    'Peter',
    DateTime(
      2005,
      DateTime.now().month,
      DateTime.now().day,
      DateTime.now().hour,
      DateTime.now().minute + 1,
    )
  ],*/
];

var lastDeleted;

void addBirthday(String name, DateTime birthday) {
  int birthdayId = getNewBirthdayId();
  int notificationId = getNewNotificationId();

  birthdayList.add([birthdayId, name.trim(), birthday, notificationId]);
  createNotification(birthdayId, notificationId);
}

void removeBirthday(birthdayId) {
  lastDeleted = getDataById(birthdayId);

  AwesomeNotifications().cancel(lastDeleted[3]);
  birthdayList.removeAt(
    birthdayList.indexWhere((element) => element[0] == birthdayId),
  );
}

void updateBirthday(int birthdayId, String name, DateTime birthday) {
  int oldNotificationId = getDataById(birthdayId)![3] as int;
  int newNotificationId = getNewNotificationId();

  birthdayList
      .elementAt(birthdayList
          .indexWhere((birthdayData) => birthdayData[0] == birthdayId))
      .setAll(
    0,
    [birthdayId, name, birthday, newNotificationId],
  );
  createNotification(birthdayId, newNotificationId);
  AwesomeNotifications().cancel(oldNotificationId);
}

bool restoreBirthday() {
  if (!birthdayList.contains(lastDeleted)) {
    birthdayList.add(
      [getNewBirthdayId(), lastDeleted[1], lastDeleted[2], lastDeleted[3]],
    );
    return true;
  }
  return false;
}

List<Object>? getDataById(int birthdayId) {
  for (int i = 0; i < birthdayList.length; i++) {
    if (birthdayList[i][0] as int == birthdayId) {
      return birthdayList[i];
    }
  }

  return null;
}

int getNewBirthdayId() {
  if (birthdayList.length == 0) {
    return 0;
  }

  int id = birthdayList[0][0] as int;
  for (int i = 0; i < birthdayList.length; i++) {
    if (birthdayList[i][0] as int > id) {
      id = birthdayList[i][0] as int;
    }
  }

  return id + 1;
}
