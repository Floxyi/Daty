import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:daty/utilities/Birthday.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'notification_manager.dart';

// list of all created birthdays
List<Birthday> birthdayList = [];

// list of all birthday ids to load the birthdays by their ids
String takenIdsKey = "takenIds";

// keep the last deleted birthday saved for restore option
Birthday? lastDeleted;

/*

data representation of a saved Birthday object as an array:
- 0: name
- 1: year
- 2: month
- 3: day
- 4: hour
- 5: minute
- 6: birthday id
- 7: notification id day
- 8: notification id week
- 9: notification id month
- 10: allow notifications

*/

Future<void> loadBirthdays() async {
  final prefs = await SharedPreferences.getInstance();

  List<String>? takenIds = await prefs.getStringList(takenIdsKey);

  if (takenIds == null) {
    return;
  }

  for (int i = 0; i < takenIds.length; i++) {
    List<String>? birthdayArray = await prefs.getStringList(takenIds[i]);

    if (birthdayArray != null) {
      Birthday? birthday = Birthday(
        // name of birthday
        birthdayArray[0],

        // time of birthday
        DateTime(
          int.parse(birthdayArray[1]),
          int.parse(birthdayArray[2]),
          int.parse(birthdayArray[3]),
          int.parse(birthdayArray[4]),
          int.parse(birthdayArray[5]),
        ),

        // birthday id
        int.parse(birthdayArray[6]),

        // notification ids
        [
          int.parse(birthdayArray[7]),
          int.parse(birthdayArray[8]),
          int.parse(birthdayArray[9]),
        ],

        // allow notifications
        birthdayArray[10].toLowerCase() == 'true',
      );

      birthdayList.add(birthday);
    } else {
      // if birthday id has no data remove it
      takenIds.remove(takenIds[i]);
      await prefs.setStringList(takenIdsKey, takenIds);
    }
  }
}

void addBirthday(Birthday birthday) async {
  birthdayList.add(birthday);
  createAllNotifications(birthday);

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
      birthday.birthdayId.toString(),
      birthday.notificationIds[0].toString(),
      birthday.notificationIds[1].toString(),
      birthday.notificationIds[2].toString(),
      birthday.allowNotifications.toString(),
    ],
  );

  // add its id to the list of ids for later access
  List<String>? takenIds = prefs.getStringList(takenIdsKey);
  if (takenIds == null) {
    await prefs.setStringList(takenIdsKey, [birthday.birthdayId.toString()]);
  } else {
    takenIds.add(birthday.birthdayId.toString());
    await prefs.setStringList(takenIdsKey, takenIds);
  }
}

void removeBirthday(birthdayId) async {
  Birthday? removedBirthday = getDataById(birthdayId);

  lastDeleted = removedBirthday;

  AwesomeNotifications().cancel(removedBirthday.notificationIds[0]);
  AwesomeNotifications().cancel(removedBirthday.notificationIds[1]);
  AwesomeNotifications().cancel(removedBirthday.notificationIds[2]);

  birthdayList.removeAt(
    birthdayList.indexWhere((birthday) => birthday.birthdayId == birthdayId),
  );

  final prefs = await SharedPreferences.getInstance();

  // remove birthday data array
  await prefs.remove(birthdayId.toString());

  // remove birthday id in id array
  List<String>? takenIds = prefs.getStringList(takenIdsKey);
  takenIds?.remove(birthdayId.toString());
  await prefs.setStringList(takenIdsKey, takenIds!);
}

void updateBirthday(int oldBirthdayId, Birthday updatedBirthday) {
  Birthday? oldBirthday = getDataById(oldBirthdayId);

  // keep same ids
  updatedBirthday.setbirthdayId = oldBirthdayId;
  updatedBirthday.setnotificationIds = [
    oldBirthday.notificationIds[0],
    oldBirthday.notificationIds[1],
    oldBirthday.notificationIds[2],
  ];

  removeBirthday(oldBirthdayId);
  addBirthday(updatedBirthday);
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
