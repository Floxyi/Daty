import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:daty/utilities/Birthday.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'notification_manager.dart';

List<Birthday> birthdayList = [];
String takenIdsKey = "takenIds";
Birthday? lastDeleted;

SharedPreferences? prefs;

Future<void> initializeDataSystem() async {
  prefs = await SharedPreferences.getInstance();
  List<String>? takenIds = prefs!.getStringList(takenIdsKey);
  takenIds == null ? await prefs!.setStringList(takenIdsKey, []) : 0;
  loadBirthdays();
}

Future<void> loadBirthdays() async {
  List<String>? takenIds = prefs!.getStringList(takenIdsKey);

  for (int i = 0; i < takenIds!.length; i++) {
    List<String>? birthdayArray = prefs!.getStringList(takenIds[i]);

    if (birthdayArray == null) {
      takenIds.remove(takenIds[i]);
      await prefs!.setStringList(takenIdsKey, takenIds);
      return;
    }

    Birthday birthday = createBirthdayFromData(birthdayArray);
    birthdayList.add(birthday);
  }
}

Birthday createBirthdayFromData(List<String> birthdayArray) {
  String name = birthdayArray[0];
  int year = int.parse(birthdayArray[1]);
  int month = int.parse(birthdayArray[2]);
  int day = int.parse(birthdayArray[3]);
  int hour = int.parse(birthdayArray[4]);
  int minute = int.parse(birthdayArray[5]);
  int birthdayId = int.parse(birthdayArray[6]);
  int notificationDayId = int.parse(birthdayArray[7]);
  int notificationWeekId = int.parse(birthdayArray[8]);
  int notificationMonthId = int.parse(birthdayArray[9]);
  bool allowNotifications = birthdayArray[10].toLowerCase() == 'true';

  Birthday? birthday = Birthday(
    name,
    DateTime(year, month, day, hour, minute),
    birthdayId,
    [notificationDayId, notificationWeekId, notificationMonthId],
    allowNotifications,
  );

  return birthday;
}

Future<void> addBirthday(Birthday birthday) async {
  await prefs!.setStringList(
    birthday.birthdayId.toString(),
    [
      birthday.name,
      birthday.date.year.toString(),
      birthday.date.month.toString(),
      birthday.date.day.toString(),
      birthday.date.hour.toString(),
      birthday.date.minute.toString(),
      birthday.birthdayId.toString(),
      birthday.notificationIds[0].toString(),
      birthday.notificationIds[1].toString(),
      birthday.notificationIds[2].toString(),
      birthday.allowNotifications.toString(),
    ],
  );

  List<String>? takenIds = prefs!.getStringList(takenIdsKey);

  takenIds!.add(birthday.birthdayId.toString());
  await prefs!.setStringList(takenIdsKey, takenIds);

  birthdayList.add(birthday);
  createAllNotifications(birthday);
}

Future<void> removeBirthday(birthdayId) async {
  Birthday? removedBirthday = getDataById(birthdayId);
  lastDeleted = removedBirthday;

  AwesomeNotifications().cancel(removedBirthday.notificationIds[0]);
  AwesomeNotifications().cancel(removedBirthday.notificationIds[1]);
  AwesomeNotifications().cancel(removedBirthday.notificationIds[2]);

  birthdayList.removeAt(
    birthdayList.indexWhere((birthday) => birthday.birthdayId == birthdayId),
  );

  await prefs!.remove(birthdayId.toString());

  List<String>? takenIds = prefs!.getStringList(takenIdsKey);
  takenIds?.remove(birthdayId.toString());
  await prefs!.setStringList(takenIdsKey, takenIds!);
}

Future<void> updateBirthday(int oldBirthdayId, Birthday updatedBirthday) async {
  Birthday? oldBirthday = getDataById(oldBirthdayId);
  removeBirthday(oldBirthdayId);

  updatedBirthday.setbirthdayId = oldBirthday.birthdayId;
  updatedBirthday.setnotificationIds = [
    oldBirthday.notificationIds[0],
    oldBirthday.notificationIds[1],
    oldBirthday.notificationIds[2],
  ];

  AwesomeNotifications().cancel(oldBirthday.notificationIds[0]);
  AwesomeNotifications().cancel(oldBirthday.notificationIds[1]);
  AwesomeNotifications().cancel(oldBirthday.notificationIds[2]);

  await addBirthday(updatedBirthday);
}

bool restoreBirthday() {
  if (birthdayList.contains(lastDeleted)) {
    return false;
  }

  addBirthday(lastDeleted!);
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
  if (birthdayList.isEmpty) {
    return 1;
  }

  int highestId = birthdayList[0].birthdayId;
  for (int i = 0; i < birthdayList.length; i++) {
    if (birthdayList[i].birthdayId > highestId) {
      highestId = birthdayList[i].birthdayId;
    }
  }

  return highestId + 1;
}
