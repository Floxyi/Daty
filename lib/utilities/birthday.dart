import 'package:daty/utilities/birthday_data.dart';

class Birthday {
  late int _birthdayId;
  late String _name;
  late DateTime _date;
  late List<int> _notificationIds;

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

  Birthday(this._name, this._date, [int? bdId, List<int>? notiIds]) {
    setbirthdayId = bdId == null ? getNewBirthdayId() : bdId;

    List<int>? newNotiIds = [
      int.parse(birthdayId.toString() + "1"),
      int.parse(birthdayId.toString() + "2"),
      int.parse(birthdayId.toString() + "3")
    ];

    setnotificationIds = notiIds == null ? newNotiIds : notiIds;
  }
}
