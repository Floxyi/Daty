import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:daty/utilities/Birthday.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'notification_manager.dart';

List<Birthday> birthdayList = [];
Birthday? lastDeleted;

String idKey = "takenIds";

Future<void> loadData() async {
  final prefs = await SharedPreferences.getInstance();

  List<String>? takenIds = await prefs.getStringList(idKey);
  if (takenIds == null) {
    return;
  }

  for (int i = 0; i < takenIds.length; i++) {
    List<String>? birthdayData = await prefs.getStringList(takenIds[i]);

    Birthday? birthday = Birthday(
      birthdayData![0],
      DateTime(
        int.parse(birthdayData[1]),
        int.parse(birthdayData[2]),
        int.parse(birthdayData[3]),
        int.parse(birthdayData[4]),
        int.parse(birthdayData[5]),
      ),
    );

    birthdayList.add(birthday);
  }
}

Future<void> addBirthday(Birthday birthday) async {
  birthday.setbirthdayId = getNewBirthdayId();
  birthday.setnotificationId = getNewNotificationId();

  birthdayList.add(birthday);
  createNotification(birthday);

  final prefs = await SharedPreferences.getInstance();

  await prefs.setStringList(
    birthday.birthdayId.toString(),
    [
      birthday.name,
      birthday.date.year.toString(),
      birthday.date.month.toString(),
      birthday.date.day.toString(),
      birthday.date.hour.toString(),
      birthday.date.minute.toString(),
      birthday.notificationId.toString(),
    ],
  );

  List<String>? takenIds = prefs.getStringList(idKey);
  if (takenIds == null) {
    await prefs.setStringList(idKey, [birthday.birthdayId.toString()]);
  } else {
    takenIds.add(birthday.birthdayId.toString());
    await prefs.setStringList(idKey, takenIds);
  }
}

Future<void> removeBirthday(birthdayId) async {
  Birthday? removedBirthday = getDataById(birthdayId);
  lastDeleted = removedBirthday;

  AwesomeNotifications().cancel(removedBirthday.notificationId);

  birthdayList.removeAt(
    birthdayList.indexWhere((birthday) => birthday.birthdayId == birthdayId),
  );

  final prefs = await SharedPreferences.getInstance();

  await prefs.remove(birthdayId.toString());

  List<String>? takenIds = prefs.getStringList(idKey);
  takenIds?.remove(birthdayId.toString());
  await prefs.setStringList(idKey, takenIds!);
}

void updateBirthday(int oldBirthdayId, Birthday newBirthday) {
  Birthday? oldBirthday = getDataById(oldBirthdayId);
  newBirthday.setbirthdayId = oldBirthdayId;

  removeBirthday(oldBirthdayId);
  AwesomeNotifications().cancel(oldBirthday.notificationId);

  addBirthday(newBirthday);
}

bool restoreBirthday() {
  if (birthdayList.contains(lastDeleted)) {
    return false;
  }

  addBirthday(lastDeleted!);
  return true;
}

Birthday getDataById(int birthdayId) {
  for (int i = 0; i <= birthdayList.length; i++) {
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
