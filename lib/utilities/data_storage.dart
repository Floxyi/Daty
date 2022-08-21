import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:daty/utilities/Birthday.dart';

import 'notification_manager.dart';

List<Birthday> birthdayList = [
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

Birthday? lastDeleted;

void addBirthday(Birthday birthday) {
  birthday.setbirthdayId = getNewBirthdayId();
  birthday.setnotificationId = getNewNotificationId();

  birthdayList.add(birthday);
  createNotification(birthday);
}

void removeBirthday(birthdayId) {
  Birthday? removedBirthday = getDataById(birthdayId);

  lastDeleted = removedBirthday;

  AwesomeNotifications().cancel(removedBirthday.notificationId);
  birthdayList.removeAt(
    birthdayList.indexWhere((birthday) => birthday.birthdayId == birthdayId),
  );
}

void updateBirthday(int oldBirthdayId, Birthday newBirthday) {
  Birthday? oldBirthday = getDataById(oldBirthdayId);

  newBirthday.setbirthdayId = oldBirthdayId;

  removeBirthday(oldBirthdayId);
  addBirthday(newBirthday);

  AwesomeNotifications().cancel(oldBirthday.notificationId);
}

bool restoreBirthday() {
  if (birthdayList.contains(lastDeleted)) {
    return false;
  }

  birthdayList.add(lastDeleted!);
  return true;
}

Birthday getDataById(int birthdayId) {
  for (int i = 0; i < birthdayList.length; i++) {
    if (birthdayList[i].birthdayId == birthdayId) {
      return birthdayList[i];
    }
  }

  return birthdayList.first;
}

int getNewBirthdayId() {
  if (birthdayList.length == 0) {
    return 0;
  }

  int highestId = birthdayList[0].birthdayId;
  for (int i = 0; i < birthdayList.length; i++) {
    if (birthdayList[i].birthdayId > highestId) {
      highestId = birthdayList[i].birthdayId;
    }
  }

  return highestId + 1;
}
