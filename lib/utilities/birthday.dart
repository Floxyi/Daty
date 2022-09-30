import 'package:daty/utilities/birthday_data.dart';
import 'package:daty/utilities/notification_manager.dart';

class Birthday {
  late int _birthdayId;
  late String _name;
  late DateTime _date;
  late int _notificationId;

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

  int get notificationId {
    return _notificationId;
  }

  set setnotificationId(int notificationId) {
    _notificationId = notificationId;
  }

  Birthday(this._name, this._date) {
    setbirthdayId = getNewBirthdayId();
    setnotificationId = getNewNotificationId();
  }
}
