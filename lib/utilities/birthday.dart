import 'package:daty/utilities/birthday_data.dart';
import 'package:daty/utilities/notification_manager.dart';

class Birthday {
  late int _birthdayId;
  late String _name;
  late DateTime _date;
  late List<int> _notificationIds;
  late bool _allowNotifications;

  int get birthdayId {
    return _birthdayId;
  }

  set setbirthdayId(int birthdayId) {
    _birthdayId = birthdayId;
  }

  String get name {
    return _name;
  }

  set setname(String name) {
    _name = name;
  }

  DateTime get date {
    return _date;
  }

  set setdate(DateTime birthdayDate) {
    _date = _date;
  }

  List<int> get notificationIds {
    return _notificationIds;
  }

  set setnotificationIds(List<int> newNotificationIds) {
    _notificationIds = newNotificationIds;
  }

  bool get allowNotifications {
    return _allowNotifications;
  }

  set setAllowNotifications(bool value) {
    _allowNotifications = value;

    if (value) {
      createAllNotifications(getDataById(_birthdayId));
    } else {
      cancelAllNotifications(getDataById(_birthdayId));
    }
  }

  Birthday(this._name, this._date,
      [int? bdId, List<int>? notiIds, bool? allowNoti]) {
    _birthdayId = bdId == null ? getNewBirthdayId() : bdId;

    List<int>? newNotiIds = [
      int.parse(birthdayId.toString() + "1"),
      int.parse(birthdayId.toString() + "2"),
      int.parse(birthdayId.toString() + "3")
    ];

    _notificationIds = notiIds == null ? newNotiIds : notiIds;

    _allowNotifications = allowNoti == null ? true : allowNoti;
  }
}
